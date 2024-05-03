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

    updateGameFromPlayer(newPlayer){
      //compare current player with id to player passed in
      let oldPlayer;
      this.players.forEach(currentPlayer => {
        if(currentPlayer.id === newPlayer.id){
          oldPlayer = currentPlayer;
        }
      })
      
      //if currentpage is different
      if(oldPlayer.currentPage !== newPlayer.currentPage){
        this.handlePageChange(oldPlayer, newPlayer);
        oldPlayer.update(newPlayer);
      }
      
      //if answer is different
      if(oldPlayer.answer !== newPlayer.answer){
        this.handleAnswerChange();
        oldPlayer.update(newPlayer);
      }
      
      //if selectedquestion is different
      if(oldPlayer.selectedQuestion !== newPlayer.selectedQuestion){
        this.handleSelectedQuestionChange();
        oldPlayer.update(newPlayer);
      }
      
      //if buzzzStatus is different
      if(oldPlayer.buzzStatus !== newPlayer.buzzStatus){
        this.handleBuzzStatusChange();
        oldPlayer.update(newPlayer);
      }
      if(DEBUG){console.log("Updated Game from client message.")};
    }

    
    handlePageChange(newPlayer){
      if(newPlayer.currentPage === '/question'){
        this.players.forEach(currentPlayer => {
            currentPlayer.currentPage = '/question';
            console.log("moved player to question")
        })
      }
    }

    handleAnswerChange(){

    }

    handleSelectedQuestionChange(){

    }

    handleBuzzStatusChange(){

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