const Player = require('./player');
const Game = require('./game');

const WebSocket = require("ws");
const wss = new WebSocket.Server({ port: 5000 });


const triviaQuestions = [
  { question: "What is the smallest planet in our solar system?", answer: "Mercury" },
  { question: "Who wrote the novel '1984'?", answer: "George Orwell" },
  { question: "What is the national animal of China?", answer: "Giant Panda" },
  { question: "Who is often credited with inventing the light bulb?", answer: "Thomas Edison" },
  { question: "What is the currency of Japan?", answer: "Japanese yen" },
  { question: "Which planet is known as the Red Planet?", answer: "Mars" },
  { question: "Who painted 'The Last Supper'?", answer: "Leonardo da Vinci" },
  { question: "What is the largest mammal on Earth?", answer: "Blue Whale" },
  { question: "What is the official language of Brazil?", answer: "Portuguese" },
  { question: "Who is the lead vocalist of the band Queen?", answer: "Freddie Mercury" },
  { question: "What is the most spoken language in the world?", answer: "Mandarin Chinese" },
  { question: "Who is the creator of the 'Harry Potter' series?", answer: "J.K. Rowling" },
  { question: "What is the tallest mountain in the world?", answer: "Mount Everest" },
  { question: "Who wrote the 'I Have a Dream' speech?", answer: "Martin Luther King Jr." },
  { question: "What is the chemical symbol for gold?", answer: "Au" },
  { question: "Which planet is known for its beautiful rings?", answer: "Saturn" },
  { question: "Who is often referred to as the 'Father of Modern Physics'?", answer: "Albert Einstein" },
  { question: "What is the largest desert in the world?", answer: "Antarctica (Antarctic Desert)" },
  { question: "Who painted 'The Scream'?", answer: "Edvard Munch" },
  { question: "What is the national flower of Japan?", answer: "Cherry Blossom" },
  { question: "Who is known for discovering penicillin?", answer: "Alexander Fleming" },
  { question: "What is the capital of Canada?", answer: "Ottawa" }
  // Add more questions if you'd like
];

let game = new Game();
game.setRandomQuestion(triviaQuestions);

wss.on("connection", ws => {
  
  handlePlayerConnection(ws);

  ws.on("message", message => {
    handleIncomingClientMessage(ws, message)
  });

  ws.on("close", () => {
    handlePlayerDisconnection(ws)
  })
});

function handlePlayerConnection(ws)
{
  ws.id = Date.now().toString(); // Assign a unique ID to each WebSocket connection
  console.log("New client connected:", ws.id);
}

function handleIncomingClientMessage(ws, message)
{
  console.log("Received message from client:", message.toString());
    let data;
    try {
      data = JSON.parse(message);
    } catch (error) {
      console.error("Error parsing JSON:", error);
      return; // Skip processing if the message is not valid JSON
    }
    addPlayerFlag = true;
    game.players.forEach(currentPlayer => {
      if(currentPlayer.id === ws.id){
        addPlayerFlag = false;
      }
    })
    
    if(addPlayerFlag){
      player = Player.fromJSON(data);
      player.playerName = data.name;
      player.id = ws.id;
      game.addPlayer(player);
      console.log("Added player:", player.playerName, player.id);
      console.log("Current game:", game)
      wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
          console.log("Sending game state to clients:", game.toJSON());
          client.send(JSON.stringify(game.toJSON()));
        }
      });
    }
    else if(data.answer !== ''){
      console.log("got answer from client");
      if(data.answer === game.currentQuestion.answer){
        game.players.forEach(currentPlayer => {
          currentPlayer.currentPage = "question"
          game.setRandomQuestion(triviaQuestions);
          if(currentPlayer.id === ws.id){
            currentPlayer.incrementScore();
          }
        });
      }else{
        game.players.forEach(currentPlayer => {
          currentPlayer.currentPage = "question"
          if(currentPlayer.id === ws.id){
            currentPlayer.decrementScore();
          }
        });
      }
      wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
          console.log("Sending game state to clients:", game.toJSON());
          client.send(JSON.stringify(game.toJSON()));
        }
      });
    }
    else if(data.buzzStatus){
      game.players.forEach(currentPlayer => {
        if(currentPlayer.id !== ws.id){
          currentPlayer.currentPage = 'wait';
        }
        else{
          currentPlayer.currentPage = 'answer';
          currentPlayer.buzzStatus = true;
        }
      });
      wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
          console.log("Sending game state to clients:", game.toJSON());
          client.send(JSON.stringify(game.toJSON()));
        }
      });
    }
    else{
      game.players.forEach(currentPlayer => {
        currentPlayer.currentPage = data.currentPage;
      });
      wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
          console.log("Sending game state to clients:", game.toJSON());
          client.send(JSON.stringify(game.toJSON()));
        }
      });
    }
}

function handlePlayerDisconnection(ws)
{
  game.players.forEach(currentPlayer => {
    if(currentPlayer.id === ws.id){
      player = currentPlayer;
    }
  })
  game.removePlayer(player.id)
  console.log("Removed player:", player.playerName);
  console.log("Current game:", game)
  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      console.log("Sending game state to clients:", game.toJSON());
      client.send(JSON.stringify(game.toJSON()));
    }
  });
}


// wss.on("connection", ws => {
//   ws.id = Date.now().toString(); // Assign a unique ID to each WebSocket connection
//   console.log("New client connected:", ws.id);
//   wss.clients.forEach(client => {
//     client.send(`Welcome to Jeopardy!`);
//   });
//   ws.on("message", message => {
//     console.log("Received message from client:", message);
    
//     const parts = message.toString().split(' ');
//     const messageType = parts[0];
//     const messageContent = parts.slice(1).join(' ');
//     console.log("Message type:", messageType);
//     console.log("Message content:", messageContent);

//     wss.clients.forEach(client => {
//       client.send(messageType.toString());
//     });

//     if (messageType === "/name") {
//       const userName = messageContent;
//       users.push({ id: ws.id, name: userName });
//       ws.send(`Welcome, ${userName}! You are now connected.`);
//     } else if (messageType === "/buzz") {
//       if (!buzzerUser) {
//         buzzerUser = users.find(user => user.id === ws.id);
//         wss.clients.forEach(client => {
//           client.send(`${buzzerUser.name} has buzzed in!`);
//         });
//       }
//     } else if (messageType === "/answer") {
//       const userAnswer = messageContent;
//       ws.send(`${buzzerUser.name} answered: ${messageContent}`);
//       if (buzzerUser) {
//         const correctAnswer = triviaQuestions[currentQuestion].answer;
//         if (userAnswer.toLowerCase() === correctAnswer.toLowerCase()) {
//           wss.clients.forEach(client => {
//             client.send(`${buzzerUser.name} answered correctly!`);
//           });
//         } else {
//           wss.clients.forEach(client => {
//             client.send(`${buzzerUser.name} answered incorrectly!`);
//           });
//         }
//         buzzerUser = null;
//       }
//     }
//   });

//   ws.on("close", () => {
//     users = users.filter(user => user.id !== ws.id);
//     console.log("Client disconnected:", ws.id);
//   });
// });

// setInterval(() => {
//   if (users.length > 0 && !buzzerUser) {
//     sendQuestionToAll();
//   } else {
//     console.log("Waiting for connections...");
//   }
// }, 5000); // Change the interval as needed