import 'Player.dart';

class Game {
  List<Player> players = [];
  late Board gameBoard;
  late Question currentQuestion;

  //return a list of all the names of the players in the game
  List<String> getPlayerNames() {
    List<String> names = [];
    for (Player player in players) {
      names.add(player.name);
    }
    return names;
  }

  //return a list of all the players names and scores
  List<String> getPlayerNamesWithScores() {
    return players.map((player) => '${player.name}: ${player.score}').toList();
  }

  //create game from JSON object
  static Game fromJSON(Map<String, dynamic> json) {
    Game game = Game();
    List<dynamic> playersJson = json['players'];
    game.players = playersJson.map((playerJson) => Player.fromJson(playerJson)).toList();
    game.gameBoard = json['gameBoard'];
    game.currentQuestion = json['currentQuestion'];
    return game;
  }

  //update game from server message
  static updateGameFromServer(String message){

  }
}



class Board{
  List<Question> questions = [];
}

class Question{
  String question = '';
  String answer = '';
}


