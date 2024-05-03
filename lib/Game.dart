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

  Map<String, dynamic> toJSON() {
    return {
      'players': players.map((player) => player.toJSON()).toList(),
      'gameBoard': gameBoard.toJSON(),
      'currentQuestion': currentQuestion.toJSON(),
    };
  }

  //create game from JSON object
  static Game fromJSON(Map<String, dynamic> json) {
    Game game = Game();
    List<dynamic> playersJson = json['players'];
    game.players = playersJson.map((playerJson) => Player.fromJSON(playerJson)).toList();
    game.gameBoard = Board.fromJSON(json['gameBoard']);
    game.currentQuestion = Question.fromJSON(json['currentQuestion']);
    return game;
  }

  //update game from server message
  static updateGameFromServer(String message){
    
  }
}



class Board{
  List<Question> questions = [];

  Map<String, dynamic> toJSON() {
    return {
      'questions': questions.map((question) => question.toJSON()).toList(),
    };
  }

  static Board fromJSON(Map<String, dynamic> json) {
    Board board = Board();
    List<dynamic> questionsJson = json['questions'];
    board.questions = questionsJson.map((questionJson) => Question.fromJSON(questionJson)).toList();
    return board;
  }
}

class Question {
  String question = '';
  String answer = '';

  Map<String, dynamic> toJSON() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  static Question fromJSON(Map<String, dynamic> json) {
    return Question()
      ..question = json['question']
      ..answer = json['answer'];
  }
}


