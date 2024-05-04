const main = require('./aiQuestionGenerator.js');
const Player = require('./player');
const {Game, Board, Question} = require('./game');
const WebSocket = require("ws");

const DEBUG = true;

class JeopardyServer {
  constructor() {
    this.jeopardyGame = new Game();
    this.wss = new WebSocket.Server({ port: 5000 });
    if(DEBUG){console.log("Jeopardy Server Instantiated.")};
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

const triviaData = [
  {
    question: "What is the capital of France?",
    answer: "Paris"
  },
  {
    question: "Who painted the Mona Lisa?",
    answer: "Leonardo da Vinci"
  },
  {
    question: "What is the largest mammal on Earth?",
    answer: "Blue whale"
  },
  {
    question: "What is the longest river in the world?",
    answer: "Nile River"
  },
  {
    question: "What is the largest desert in the world?",
    answer: "Sahara Desert"
  },
  {
    question: "What is the smallest planet in our solar system?",
    answer: "Mercury"
  },
  {
    question: "Who wrote the play 'Hamlet'?",
    answer: "William Shakespeare"
  },
  {
    question: "What is the chemical symbol for gold?",
    answer: "Au"
  },
  {
    question: "Who invented the telephone?",
    answer: "Alexander Graham Bell"
  },
  {
    question: "What is the capital of Japan?",
    answer: "Tokyo"
  },
  {
    question: "What is the largest ocean on Earth?",
    answer: "Pacific Ocean"
  },
  {
    question: "What is the highest mountain in Africa?",
    answer: "Mount Kilimanjaro"
  },
  {
    question: "What is the largest moon of Saturn?",
    answer: "Titan"
  },
  {
    question: "What is the chemical symbol for water?",
    answer: "H2O"
  },
  {
    question: "Who discovered penicillin?",
    answer: "Alexander Fleming"
  },
  {
    question: "What is the national flower of England?",
    answer: "Rose"
  },
  {
    question: "Who wrote 'The Great Gatsby'?",
    answer: "F. Scott Fitzgerald"
  },
  {
    question: "What is the capital of Australia?",
    answer: "Canberra"
  },
  {
    question: "What is the largest bird in the world?",
    answer: "Ostrich"
  },
  {
    question: "What is the chemical symbol for oxygen?",
    answer: "O"
  },
  {
    question: "Who discovered the theory of relativity?",
    answer: "Albert Einstein"
  },
  {
    question: "What is the largest island in the Mediterranean Sea?",
    answer: "Sicily"
  },
  {
    question: "What is the largest planet in our solar system?",
    answer: "Jupiter"
  },
  {
    question: "Who wrote the play 'Romeo and Juliet'?",
    answer: "William Shakespeare"
  },
  {
    question: "What is the tallest mountain in the world?",
    answer: "Mount Everest"
  }
];

triviaData.forEach(data => {
  const question = Question.fromJSON(data);
  js.jeopardyGame.gameBoard.addQuestion(question);
});

js.jeopardyGame.setRandomQuestion();

js.wss.on("connection", ws => {
  js.handlePlayerConnection(ws);
  
  ws.on("message", message => {
      js.handleIncomingClientMessage(ws, message)
    });
  
  ws.on("close", () => {
      js.handlePlayerDisconnection(ws)
    })
  });