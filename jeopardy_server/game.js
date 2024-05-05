const main = require ('./aiQuestionGenerator.js');
const calculateScore = require('./answerChecking.js');

let DEBUG = true;

class Game {
    constructor() {
      this.players = [];
      this.gameBoard = new Board();
      this.currentQuestion = new Question();
    }
    
    setRandomQuestion() {
      const questions = this.gameBoard.questions;
      if (questions.length === 0) {
        console.log("No questions available in the board.");
        return;
      }
  
      // Get a random index within the questions array
      const randomIndex = Math.floor(Math.random() * questions.length);
  
      // Set the current question to the randomly selected question
      this.currentQuestion = questions[randomIndex];
      if(DEBUG){console.log("Random question set:", this.currentQuestion.question);}
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
      
      //if buzzzStatus is different
      if(oldPlayer.buzzStatus !== newPlayer.buzzStatus){
        this.handleBuzzStatusChange(newPlayer);
        oldPlayer.update(newPlayer);
        if(DEBUG){console.log("Handled buzz status change.")};
      }

      //if currentpage is different
      if(oldPlayer.currentPage !== newPlayer.currentPage){
        this.handlePageChange(newPlayer);
        oldPlayer.update(newPlayer);
        if(DEBUG){console.log("Handled page change.")};
      }
      
      //if answer is different
      if(oldPlayer.answer !== newPlayer.answer){
        this.handleAnswerChange(newPlayer);
        oldPlayer.update(newPlayer);
        if(DEBUG){console.log("Handled answer change.")};
      }

      console.log(newPlayer);
    }

    
    handlePageChange(newPlayer){
      if(newPlayer.currentPage === '/board'){
        this.gameBoard.markQuestionsAnswered(newPlayer.questionSelection);
        this.players.forEach(currentPlayer => {
          if(currentPlayer.id !== newPlayer.id){
            currentPlayer.currentPage = '/board';
          }
        })
      }else if(newPlayer.currentPage === '/question'){
        this.currentQuestion = this.gameBoard.questions[newPlayer.questionSelection];
        this.players.forEach(currentPlayer => {
          if(currentPlayer.id !== newPlayer.id){
            currentPlayer.currentPage = '/question';
          }
        })
    }
  }

    handleAnswerChange(newPlayer){
      let score = calculateScore(newPlayer.answer, this.currentQuestion.answer) 
      if(score === 2){
        this.players.forEach(currentPlayer => {
          currentPlayer.currentPage = "/board"
          currentPlayer.alreadyAnswered = false;
          //game.generateQuestion();
        });
        newPlayer.score+=2;
        newPlayer.alreadyAnswered = false;
        this.gameBoard.markQuestionsAnswered(newPlayer.questionSelection);
        newPlayer.currentPage = '/board';
      }else if(score === 1){
        this.players.forEach(currentPlayer => {
          currentPlayer.currentPage = "/board"
          currentPlayer.alreadyAnswered = false;
          //game.generateQuestion();
        });
        newPlayer.score+=1;
        newPlayer.alreadyAnswered = false;
        this.gameBoard.markQuestionsAnswered(newPlayer.questionSelection);
        newPlayer.currentPage = '/board';
      }else{
        this.players.forEach(currentPlayer => {
          currentPlayer.currentPage = "/question"
        });
        newPlayer.score-=1;
        newPlayer.currentPage = '/question';
        newPlayer.alreadyAnswered = true;
    }
    newPlayer.buzzStatus = false;
    newPlayer.answer = '';
  }

    handleSelectedQuestionChange(newPlayer){


    }

    handleBuzzStatusChange(newPlayer){
      this.players.forEach(currentPlayer => {
        if(currentPlayer.id !== newPlayer.id){
          currentPlayer.currentPage = '/wait';
        }else{
          newPlayer.currentPage = '/answer';
          newPlayer.buzzStatus = true;
        }
    });
    
  }
  
}

  class Board {
    constructor() {
      this.questions = [];
      this.questionsAnswered = [];
    }

    addQuestion(question){
      this.questions.push(question);
      this.questionsAnswered.push(false);
      if(DEBUG){console.log("Added question to board")};
    }

    markQuestionsAnswered(index){
      this.questionsAnswered[index] = true;
      if(DEBUG){console.log("Marked question as answered.")};
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
  
  module.exports = {Game, Board, Question};
