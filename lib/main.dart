import 'package:flutter/material.dart';
import 'QuestionPage.dart';
import 'LandingPage.dart';
import 'StartPage.dart';
import "AnswerPage.dart";
import "WaitPage.dart";
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() => runApp(const MyApp());

Player player = Player();
Game game = Game();
Server server = Server();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Jeopardy Trivia Game';
    return MaterialApp(
      title: title,
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/start': (context) => StartPage(),
        '/question': (context) => QuestionPage(),
        '/answer': (context) => AnswerPage(),
        '/wait': (context) => WaitPage(),
      }
    );
  }
}

class Player {
  String name;
  String id;
  String currentPage;
  String answer;
  int score;
  bool buzzStatus;

  Player({this.name = '', this.id = '', this.currentPage = 'start', this.answer = '', this.score = 0, this.buzzStatus = false});

  // Convert Player object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'currentPage': currentPage,
      'answer': answer,
      'score': score,
      'buzzStatus': buzzStatus,
    };
  }

  // Create Player object from JSON map
  static Player fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] ?? '', // Default value in case 'name' is null
      id: json['id'] ?? '',
      currentPage: json['currentPage'] ?? '',
      answer: json['answer'] ?? '',
      score: json['score'] ?? 0, // Default value in case 'score' is null
      buzzStatus: json['buzzStatus'] ?? false, // Default value in case 'buzzStatus' is null
    );
  }

  String get playerName {
    return name;
  }

  set playerName(String name) {
    this.name = name;
  }

  void incrementScore() {
    score++;
  }

  void decrementScore() {
    score--;
  }

  bool buzzActive() {
    return buzzStatus;
  }

  void buzzActivate() {
    buzzStatus = true;
  }

  void buzzDeactivate() {
    buzzStatus = false;
  }
}

class Game {
  List<Player> players = [];
  String currentQuestion = '';


  void addPlayer(Player player) {
    players.add(player);
  }

  void removePlayer(Player player) {
    players.removeWhere((p) => p.name == player.name);
  }

  List<String> getPlayerNames() {
    List<String> names = [];
    for (Player player in players) {
      names.add(player.name);
    }
    return names;
  }

  Map<String, dynamic> toJson() {
    return {
      'players': players.map((player) => player.toJson()).toList(),
    };
  }

  static Game fromJSON(Map<String, dynamic> json) {
    Game game = Game();
    List<dynamic> playersJson = json['players'];
    game.players = playersJson.map((playerJson) => Player.fromJson(playerJson)).toList();
    game.currentQuestion = json['currentQuestion'];
    return game;
  }
}



class Server {
  late WebSocketChannel channel;
  late String messageFromServer;
  late bool reconnectNeeded = false;

  Server() {
    channel = WebSocketChannel.connect(
      //Uri.parse('wss://endless-lemming-only.ngrok-free.app'), //use for rpi server
      Uri.parse('ws://localhost:5000'), //use for dev server
    );
    channel.stream.listen((message){
    messageFromServer = message;
    handleMessage(message);
  });
  }

  void reconnect(){
    channel = WebSocketChannel.connect(
      //Uri.parse('wss://endless-lemming-only.ngrok-free.app'), //use for rpi server
      Uri.parse('ws://localhost:5000'), //use for dev server
    );
    channel.stream.listen((message){
    messageFromServer = message;
    handleMessage(message);
    });
    reconnectNeeded = false;
  }

  String get currentMessageFromServer{
    return messageFromServer;
  }

  void handleMessage(message){
  print('Received message: $message'); // Print the received message
  var jsonData = json.decode(message);
  print('Decoded JSON data: $jsonData');
  
  game = Game.fromJSON(jsonData);
  print(game.getPlayerNames());
  player = game.players.firstWhere((playerInGame) => playerInGame.name == player.name,
  orElse: () => player,
  );
  String playerJSON = json.encode(player.toJson());
  print('Current Player: $playerJSON');
  }


  void sendToServer(String message) {
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close();
    reconnectNeeded = true;
  } 
} 
