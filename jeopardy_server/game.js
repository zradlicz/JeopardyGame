const main = require ('./aiQuestionGenerator.js');

let DEBUG = true;

class Game {
    constructor() {
      this.players = [];
      this.gameBoard = new Board();
      this.currentQuestion = new Question();
    }
  
    addPlayer(player) {
      this.players.push(player);
      if(DEBUG){console.log("Added player to game.")};
    }
  
    removePlayerById(id) {
      this.players = this.players.filter(player => player.id !== id);
      if(DEBUG){console.log("Removed player from game.")};
    }
  
    getPlayerNames() {
      if(DEBUG){console.log("Got player names.")};
      return this.players.map(player => player.name); 
    }

    toJSON() {
      return {
        players: this.players.map(player => player.toJSON()),
        gameBoard: this.gameBoard,
        currentQuestion: this.currentQuestion
      };
    }
  }

  class Board {
    constructor() {
      this.questions = [];
    }

    addQuestion(question){
      this.questions.push(question);
      if(DEBUG){console.log("Added question to board")};
    }
  }

  class Question {
    constructor() {
      this.question = '';
      this.answer = '';
    }

    static fromJSON(json) {
      const question = new Question();
      question.question = json.question;
      question.answer = json.answer;
      return question;
    }
  }
  
  module.exports = Game;