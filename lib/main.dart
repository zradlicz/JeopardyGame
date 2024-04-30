//package imports
import 'package:flutter/material.dart';
//other page package imports
import 'QuestionPage.dart';
import 'LandingPage.dart';
import 'StartPage.dart';
import "AnswerPage.dart";
import "WaitPage.dart";
import 'BoardPage.dart';
//classes package imports
import 'Game.dart';
import 'Player.dart';
import 'Server.dart';

void main() => runApp(const MyApp());


//global client classes
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
        '/board': (context) => BoardPage(),
        '/question': (context) => QuestionPage(),
        '/answer': (context) => AnswerPage(),
        '/wait': (context) => WaitPage(),
      }
    );
  }
}


