import 'Player.dart';

class Game {
  List<Player> players = [];
  late Board gameBoard;
  late Board nextBoard;
  late Question currentQuestion;

  //return a list of all the names of the players in the game
  List<String> getPlayerNames() {
    List<String> names = [];
    for (Player player in players) {
      names.add(player.name);
    }
    return names;
  }

  int getPlayerCount(){
    return players.length;
  }

  int getNumberofPlayersAnswered(){
    int count = 0;
    for (Player player in players){
      if(player.alreadyAnswered){
        count++;
      }
    }
    return count;
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
    game.nextBoard = Board.fromJSON(json['nextBoard']);
    game.currentQuestion = Question.fromJSON(json['currentQuestion']);
    return game;
  }


}



class Board{
  List<Question> questions = [];
  List<bool> questionsAnswered = [];

  Map<String, dynamic> toJSON() {
    return {
      'questions': questions.map((question) => question.toJSON()).toList(),
      'questionsAnswered': questionsAnswered,
    };
  }

  static Board fromJSON(Map<String, dynamic> json) {
    Board board = Board();
    List<dynamic> questionsJson = json['questions'];
    board.questions = questionsJson.map((questionJson) => Question.fromJSON(questionJson)).toList();
    board.questionsAnswered = json['questionsAnswered'].cast<bool>();
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


