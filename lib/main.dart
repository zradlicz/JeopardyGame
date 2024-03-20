import 'package:flutter/material.dart';
import 'GamePage.dart';
import 'LandingPage.dart';
import 'StartPage.dart';
void main() => runApp(const MyApp());

Player player = Player();
Game game = Game();

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
        '/game': (context) => GamePage(),
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
