const main = require('./aiQuestionGenerator.js');
const Player = require('./player');
const {Game, Board, Question} = require('./game');
const WebSocket = require("ws");

const DEBUG = false;


class JeopardyServer {
  constructor() {
    this.jeopardyGame = new Game();
    this.wss = new WebSocket.Server({ port: 5000 });
    if(DEBUG){console.log("Jeopardy Server Instantiated.")};
  }

  async generateQuestions(){
    while(this.jeopardyGame.gameBoard.questions.length < 25){
      const chatCompletion = await main();
        try {
            const question = JSON.parse(chatCompletion.choices[0].message.content);
            console.log("Generated question:", question);
            this.jeopardyGame.gameBoard.addQuestion(question);
        } catch (error) {
            console.error("Error generating question:", error);
        }
  }
}

  //method to handle player connecting to server
  handlePlayerConnection(ws){
    ws.id = Date.now().toString(); // Assign a unique ID to each WebSocket connection
    if(DEBUG){console.log("Player called TODO connected")};
  }

  //method to handle player disconnect from server
  handlePlayerDisconnection(ws){
    let player;
    this.jeopardyGame.players.forEach(currentPlayer => {
          if(currentPlayer.id === ws.id){
            player = currentPlayer;
            this.jeopardyGame.removePlayerById(player.id);
          }
        })
    this.sendGameToClients();
        
    if(DEBUG){console.log("Player called TODO disconnected")};
  }

  //method to handle message from client
  handleIncomingClientMessage(ws, message){
    
    let playerData;
    try {
      playerData = JSON.parse(message);
    } catch (error) {
      console.error("Error parsing JSON:", error);
      return; // Skip processing if the message is not valid JSON
    }
    if(DEBUG){console.log("Recieved client message:", playerData)};

    if(this.playerIsInGame(ws.id)){
      //console.log(Player.fromJSON(playerData));
      let newPlayer = Player.fromJSON(playerData);
      newPlayer.id = ws.id;
      this.jeopardyGame.updateGameFromPlayer(newPlayer);
      this.sendGameToClients();
    }
    else{
      this.addPlayer(ws.id, playerData);
    }
    

    if(DEBUG){console.log("Client message handled.")};
  }

  addPlayer(playerId, playerData){
    let player = Player.fromJSON(playerData);
    player.id = playerId;
    this.jeopardyGame.addPlayer(player);
    this.sendGameToClients();
  }

  playerIsInGame(playerId){
    let rv = false;
    this.jeopardyGame.players.forEach(currentPlayer => {
      if(currentPlayer.id === playerId){
        rv = true;
      }
    })
    return rv;
  }

  sendGameToClients(){
    this.wss.clients.forEach(client => {
              if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify(this.jeopardyGame.toJSON()));
              }
            });
    if(DEBUG){console.log("Sending game state to clients:", this.jeopardyGame.toJSON());}
  }
}

let js = new JeopardyServer();

js.generateQuestions();

js.wss.on("connection", ws => {
  js.handlePlayerConnection(ws);
  
  ws.on("message", message => {
      js.handleIncomingClientMessage(ws, message)
    });
  
  ws.on("close", () => {
      js.handlePlayerDisconnection(ws)
    })
  });