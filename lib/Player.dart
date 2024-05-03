import 'Game.dart';
import 'Server.dart';
import 'dart:convert';

class Player {
  
  String name;
  String id;
  String currentPage;
  String answer;
  int score;
  bool buzzStatus;
  int questionSelection;

  //Construct player
  Player({this.name = '', 
          this.id = '',
          this.currentPage = '/start', 
          this.answer = '', 
          this.score = 0, 
          this.buzzStatus = false,
          this.questionSelection = 0});

  set setName(String name){
    this.name = name;
  }

  set setCurrentPage(String currentPage){
    this.currentPage = currentPage;
  }

  set setBuzzStatus(bool status){
    buzzStatus = status;
  }

  set setAnswer(String answer){
    this.answer = answer;
  }

  String get getCurrentPage{
    return currentPage;
  }

  //Convert Player object to JSON format
  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'id':id,
      'currentPage': currentPage,
      'answer': answer,
      'score': score,
      'buzzStatus': buzzStatus,
      'questionSelection': questionSelection
    };
  }

  //Create Player object from JSON map
  static Player fromJSON(Map<String, dynamic> json) {
    return Player(
      name: json['name'] ?? '', // Default value in case 'name' is null
      id: json['id'] ?? '',
      currentPage: json['currentPage'] ?? '',
      answer: json['answer'] ?? '',
      score: json['score'] ?? 0, // Default value in case 'score' is null
      buzzStatus: json['buzzStatus'] ?? false, // Default value in case 'buzzStatus' is null
      questionSelection: json['questionSelection'],
    );
  }
  //update Player from game
  static updatePlayerFromGame(Game game){

  }

  //send Player to server JSON format
  void sendPlayerToServer(Server server){
    if (server.reconnectNeeded) {
          server.reconnect();
        }
      server.sendToServer(json.encode(toJSON()));
  }
}