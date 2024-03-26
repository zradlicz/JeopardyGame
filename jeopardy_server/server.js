const WebSocket = require("ws");
const wss = new WebSocket.Server({ port: 5000 });

let users = [];
let buzzerUser = null;
let currentQuestion = 0;

const triviaQuestions = [
  { question: "What is the capital of France?", answer: "Paris" },
  { question: "Who painted the Mona Lisa?", answer: "Leonardo da Vinci" },
  // Add more questions as needed
];

function sendQuestionToAll() {
  const randomIndex = Math.floor(Math.random() * triviaQuestions.length);
  const question = triviaQuestions[randomIndex].question;
  currentQuestion = randomIndex;
  console.log("Sending question to all clients:", question);
  wss.clients.forEach(client => {
    client.send(`Question: ${question}`);
  });
}

wss.on("connection", ws => {
  ws.id = Date.now().toString(); // Assign a unique ID to each WebSocket connection
  console.log("New client connected:", ws.id);
  wss.clients.forEach(client => {
    client.send(`Welcome to Jeopardy!`);
  });
  ws.on("message", message => {
    console.log("Received message from client:", message);
    
    const parts = message.toString().split(' ');
    const messageType = parts[0];
    const messageContent = parts.slice(1).join(' ');
    console.log("Message type:", messageType);
    console.log("Message content:", messageContent);

    wss.clients.forEach(client => {
      client.send(messageType.toString());
    });

    if (messageType === "/name") {
      const userName = messageContent;
      users.push({ id: ws.id, name: userName });
      ws.send(`Welcome, ${userName}! You are now connected.`);
    } else if (messageType === "/buzz") {
      if (!buzzerUser) {
        buzzerUser = users.find(user => user.id === ws.id);
        wss.clients.forEach(client => {
          client.send(`${buzzerUser.name} has buzzed in!`);
        });
      }
    } else if (messageType === "/answer") {
      const userAnswer = messageContent;
      ws.send(`${buzzerUser.name} answered: ${messageContent}`);
      if (buzzerUser) {
        const correctAnswer = triviaQuestions[currentQuestion].answer;
        if (userAnswer.toLowerCase() === correctAnswer.toLowerCase()) {
          wss.clients.forEach(client => {
            client.send(`${buzzerUser.name} answered correctly!`);
          });
        } else {
          wss.clients.forEach(client => {
            client.send(`${buzzerUser.name} answered incorrectly!`);
          });
        }
        buzzerUser = null;
      }
    }
  });

  ws.on("close", () => {
    users = users.filter(user => user.id !== ws.id);
    console.log("Client disconnected:", ws.id);
  });
});

setInterval(() => {
  if (users.length > 0 && !buzzerUser) {
    sendQuestionToAll();
  } else {
    console.log("Waiting for connections...");
  }
}, 5000); // Change the interval as needed
