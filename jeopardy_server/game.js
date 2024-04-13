class Game {
    constructor() {
      this.players = [];
      this.currentQuestion = "";
    }
  
    addPlayer(player) {
      this.players.push(player);
    }
  
    removePlayer(id) {
      this.players = this.players.filter(player => player.id !== id);
    }
  
    getPlayerNames() {
      return this.players.map(player => player.name);
    }

    setRandomQuestion(questions) {
        if (!Array.isArray(questions) || questions.length === 0) {
            console.error("Invalid or empty questions array");
            return;
          }
      
          // Generate a random index within the range of the questions array
          const randomIndex = Math.floor(Math.random() * questions.length);
      
          // Return the question at the random index
          this.currentQuestion = questions[randomIndex];
    }
  
    toJSON() {
      return {
        players: this.players.map(player => player.toJSON()),
        currentQuestion: this.currentQuestion.question
      };
    }
  
    static fromJSON(json) {
      const game = new Game();
      json.players.forEach(playerJson => {
        const player = Player.fromJSON(playerJson);
        game.players.push(player);
      });
      return game;
    }
  }

  module.exports = Game;