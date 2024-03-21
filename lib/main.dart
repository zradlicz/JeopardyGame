import 'dart:async';

import 'package:flutter/material.dart';
import 'QuestionPage.dart';
import 'LandingPage.dart';
import 'StartPage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:async/async.dart';
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
        '/start': (context) => StartPage(playerNames: game.getPlayerNames()),
        '/question': (context) => QuestionPage(),
      }
    );
  }
}

class Player
{
  String name = '';
  int score = 0;
  bool buzzStatus = false;

  String get playerName{
    return name;
  }

  set playerName(String name){
    this.name = name;
  }

  void incrementScore(){
    score++;
  }

  void deccrementScore(){
    score--;
  }

  bool buzzActive(){
    return buzzStatus;
  }

  void buzzActivate(){
    buzzStatus = true;
  }

  void buzzDisactivate(){
    buzzStatus = false;
  }
}

class Game {
  List<Player> players = [];

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
}

class Server {
  late WebSocketChannel channel;
  late String messageFromServer;

  Server() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:5000'),
    );
    channel.stream.listen((message){
    messageFromServer = message;
    handleMessage(message);
  });
  }

  String get currentMessageFromServer{
    return messageFromServer;
  }

  void handleMessage(message){
  }

  void sendToServer(String message) {
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close();
  } 
} 
