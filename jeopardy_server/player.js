class Player {
    constructor() {
      this.name = '';
      this.id = '';
      this.score = 0;
      this.buzzStatus = false;
    }
  
    get playerName() {
      return this.name;
    }
  
    set playerName(name) {
      this.name = name;
    }
  
    incrementScore() {
      this.score++;
    }
  
    decrementScore() {
      this.score--;
    }
  
    buzzActive() {
      return this.buzzStatus;
    }
  
    buzzActivate() {
      this.buzzStatus = true;
    }
  
    buzzDeactivate() {
      this.buzzStatus = false;
    }
  
    toJSON() {
      return {
        name: this.name,
        score: this.score,
        buzzStatus: this.buzzStatus
      };
    }
  
    static fromJSON(json) {
      const player = new Player();
      player.name = json.name;
      player.score = json.score;
      player.buzzStatus = json.buzzStatus;
      return player;
    }
  }

  module.exports = Player;