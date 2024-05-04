class Player {
    constructor() {
      this.name = '';
      this.id = '';
      this.currentPage = '';
      this.answer = '';
      this.score = 0;
      this.buzzStatus = false;
      this.questionSelection = 0;
      this.alreadyAnswered = false;
    }
    
    update(player){
      this.currentPage = player.currentPage;
      this.answer = player.answer;
      this.score = player.score;
      this.buzzStatus = player.buzzStatus;
      this.questionSelection = player.questionSelection;
      this.alreadyAnswered = player.alreadyAnswered;
    }

    toJSON() {
      return {
        name: this.name,
        id: this.id,
        currentPage: this.currentPage,
        answer: this.answer,
        score: this.score,
        buzzStatus: this.buzzStatus,
        questionSelection: this.questionSelection,
        alreadyAnswered: this.alreadyAnswered
      };
    }
  
    static fromJSON(json) {
      const player = new Player();
      player.name = json.name;
      player.id = json.id;
      player.currentPage = json.currentPage;
      player.answer = json.answer;
      player.score = json.score;
      player.buzzStatus = json.buzzStatus;
      player.questionSelection = json.questionSelection;
      player.alreadyAnswered = json.alreadyAnswered;
      return player;
    }
  }

  module.exports = Player;