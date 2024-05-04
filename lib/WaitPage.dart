import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async'; // Import dart:async for Timer

class WaitPage extends StatefulWidget {
  const WaitPage({Key? key}) : super(key: key);

  @override
  _WaitPageState createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> {
  TextEditingController _answerController = TextEditingController();
  late Timer gameUpdateTimer;

  @override
  void initState() {
    startGameUpdateTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Background color
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: () {
            _goHome();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                    globalGame.currentQuestion.question, // Add your text here
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              ),
              Text(
              getCurrentAnswerer(),
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

void _goHome(){
    Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
    globalPlayer.setCurrentPage = '/landing';
    globalPlayer.setBuzzStatus = false;
    dispose();
  }

  String getCurrentAnswerer() {
      var name = '';
      for (var player in globalGame.players) {
        if (player.buzzStatus) {
          name = player.name;
        }
      }
      return '$name beat you to the buzzer...';
    }

  FutureOr restartTimer(dynamic value){
    setState((){
      if(!gameUpdateTimer.isActive)
      {
        startGameUpdateTimer();
      }
    });
  }

  void startGameUpdateTimer() {
    gameUpdateTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if(globalPlayer.getCurrentPage == '/board'){
        Navigator.of(context).pushNamedAndRemoveUntil("/board", (route) => false);
        dispose();   
      }
      if(globalPlayer.getCurrentPage == '/question'){
        Navigator.pop(context);
        dispose();
      }
    });
  }

  @override
  void dispose() {
    gameUpdateTimer.cancel();
    _answerController.dispose();
    super.dispose();
  }
}