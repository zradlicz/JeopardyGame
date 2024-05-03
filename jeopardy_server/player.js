class Player {
    constructor() {
      this.name = '';
      this.id = '';
      this.currentPage = '';
      this.answer = '';
      this.score = 0;
      this.buzzStatus = false;
      this.questionSelection = 0;
    }
    
    update(player){
      this.currentPage = player.currentPage;
      this.answer = player.answer;
      this.score = player.score;
      this.buzzStatus = player.buzzStatus;
      this.questionSelection = player.questionSelection;
    }

    toJSON() {
      return {
        name: this.name,
        id: this.id,
        currentPage: this.currentPage,
        answer: this.answer,
        score: this.score,
        buzzStatus: this.buzzStatus,
        questionSelection: this.questionSelection
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
      return player;
    }
  }

  module.exports = Player;