const calculateScore = require ('./answerChecking.js');
const main = require('./aiQuestionGenerator.js');
const Player = require('./player');
const Game = require('./game');
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
    self.jeopardyGame.players.forEach(currentPlayer => {
          if(currentPlayer.id === ws.id){
            player = currentPlayer;
          }
        })
        self.jeopardyGame.removePlayer(player.id)
    if(DEBUG){console.log("Player called TODO disconnected")};
  }

  //method to handle message from client
  handleIncomingClientMessage(ws, message){
    
    let data;
    try {
      data = JSON.parse(message);
    } catch (error) {
      console.error("Error parsing JSON:", error);
      return; // Skip processing if the message is not valid JSON
    }

    let player = Player.fromJSON(data);
    self.jeopardyGame.addPlayer(player);

    if(DEBUG){console.log("Client message handled.")};
  }

  sendGameToClients(){
    self.wss.clients.forEach(client => {
              if (client.readyState === WebSocket.OPEN) {
                console.log("Sending game state to clients:", self.jeopardyGame.toJSON());
                client.send(JSON.stringify(self.jeopardyGame.toJSON()));
              }
            });
  }
}

let js = new JeopardyServer();

js.wss.on("connection", ws => {
  js.handlePlayerConnection(ws);
  
  ws.on("message", message => {
      js.handleIncomingClientMessage(ws, message)
    });
  
  ws.on("close", () => {
      js.handlePlayerDisconnection(ws)
    })
  });

// const triviaQuestions = [];

// async function generateQuestion() {
//     while (triviaQuestions.length < 3) {
//         const chatCompletion = await main();
//         try {
//             const question = JSON.parse(chatCompletion.choices[0].message.content);
//             console.log("Generated question:", question);
//             triviaQuestions.push(question);
//         } catch (error) {
//             console.error("Error generating question:", error);
//         }
//     }
// }

// // Refill questions if less than 5
// function refillQuestionsIfNeeded() {
//     if(game.currentQuestion === ''){
//       game.setRandomQuestion(triviaQuestions);
//     }
//     //console.log(triviaQuestions);
//     if (triviaQuestions.length < 2) {
//         generateQuestion();
//     }
// }

// // Remove answered question
// function removeAnsweredQuestion(question) {
//     const index = triviaQuestions.indexOf(question);
//     if (index !== -1) {
//         triviaQuestions.splice(index, 1);
//         console.log("Removed answered question from the list.");
//     }
// }

// // Run generateQuestion continuously
// generateQuestion();

// // Set interval to check and refill questions
// setInterval(refillQuestionsIfNeeded, 1000); // Check every 30 seconds

// let game = new Game();

// //game.generateQuestion();

// wss.on("connection", ws => {
  
//   handlePlayerConnection(ws);

//   ws.on("message", message => {
//     handleIncomingClientMessage(ws, message)
//   });

//   ws.on("close", () => {
//     handlePlayerDisconnection(ws)
//   })
// });

// function handlePlayerConnection(ws)
// {
//   ws.id = Date.now().toString(); // Assign a unique ID to each WebSocket connection
//   console.log("New client connected:", ws.id);
// }

// function handleIncomingClientMessage(ws, message)
// {
//   console.log("Received message from client:", message.toString());
//     let data;
//     try {
//       data = JSON.parse(message);
//     } catch (error) {
//       console.error("Error parsing JSON:", error);
//       return; // Skip processing if the message is not valid JSON
//     }
//     addPlayerFlag = true;
//     game.players.forEach(currentPlayer => {
//       if(currentPlayer.id === ws.id){
//         addPlayerFlag = false;
//       }
//     })
    
//     if(addPlayerFlag){
//       player = Player.fromJSON(data);
//       player.playerName = data.name;
//       player.id = ws.id;
//       game.addPlayer(player);
//       console.log("Added player:", player.playerName, player.id);
//       console.log("Current game:", game)
//       wss.clients.forEach(client => {
//         if (client.readyState === WebSocket.OPEN) {
//           console.log("Sending game state to clients:", game.toJSON());
//           client.send(JSON.stringify(game.toJSON()));
//         }
//       });
//     }
//     else if(data.answer !== ''){
//       console.log("got answer from client");
//       score = calculateScore(data.answer, game.currentQuestion.answer) 
//       if(score === 2){
//         game.players.forEach(currentPlayer => {
//           currentPlayer.currentPage = "question"
//           removeAnsweredQuestion(game.currentQuestion);
//           game.setRandomQuestion(triviaQuestions);
//           //game.generateQuestion();
//           if(currentPlayer.id === ws.id){
//             currentPlayer.incrementScore();
//             currentPlayer.incrementScore();
//           }
//         });
//       }else if(score === 1){
//         game.players.forEach(currentPlayer => {
//           currentPlayer.currentPage = "question"
//           removeAnsweredQuestion(game.currentQuestion);
//           game.setRandomQuestion(triviaQuestions);
//           //game.generateQuestion();
//           if(currentPlayer.id === ws.id){
//             currentPlayer.incrementScore();
//           }
//         });
//       }else{
//         game.players.forEach(currentPlayer => {
//           currentPlayer.currentPage = "question"
//           if(currentPlayer.id === ws.id){
//             currentPlayer.decrementScore();
//           }
//         });
//       }
//       wss.clients.forEach(client => {
//         if (client.readyState === WebSocket.OPEN) {
//           console.log("Sending game state to clients:", game.toJSON());
//           client.send(JSON.stringify(game.toJSON()));
//         }
//       });
//     }
//     else if(data.buzzStatus){
//       game.players.forEach(currentPlayer => {
//         if(currentPlayer.id !== ws.id){
//           currentPlayer.currentPage = 'wait';
//         }
//         else{
//           currentPlayer.currentPage = 'answer';
//           currentPlayer.buzzStatus = true;
//         }
//       });
//       wss.clients.forEach(client => {
//         if (client.readyState === WebSocket.OPEN) {
//           console.log("Sending game state to clients:", game.toJSON());
//           client.send(JSON.stringify(game.toJSON()));
//         }
//       });
//     }
//     else{
//       game.players.forEach(currentPlayer => {
//         currentPlayer.currentPage = data.currentPage;
//       });
//       wss.clients.forEach(client => {
//         if (client.readyState === WebSocket.OPEN) {
//           console.log("Sending game state to clients:", game.toJSON());
//           client.send(JSON.stringify(game.toJSON()));
//         }
//       });
//     }
// }

// function handlePlayerDisconnection(ws)
// {
//   game.players.forEach(currentPlayer => {
//     if(currentPlayer.id === ws.id){
//       player = currentPlayer;
//     }
//   })
//   game.removePlayer(player.id)
//   console.log("Removed player:", player.playerName);
//   console.log("Current game:", game)
//   wss.clients.forEach(client => {
//     if (client.readyState === WebSocket.OPEN) {
//       console.log("Sending game state to clients:", game.toJSON());
//       client.send(JSON.stringify(game.toJSON()));
//     }
//   });
// }