import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async'; // Import dart:async for Timer

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late Timer gameUpdateTimer;
  late Timer buzzTimer;

  @override
  void initState() {
    super.initState();
    startGameUpdateTimer(); // Start the timer to update player list
    startBuzzTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Background color
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: _goHome,
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
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _buzzIn,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Button background color
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(100), // Increase padding for bigger button
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    CircleBorder(), // Make the button circular
                  ),
                ),
                child: Text(
                  '!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
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
    globalServer.dispose();
  }

  void _buzzIn() {
    if(globalPlayer.alreadyAnswered){
      return;
    }
    buzzTimer.cancel();
    globalPlayer.setBuzzStatus = true;
    globalPlayer.setCurrentPage = '/answer';
    globalPlayer.alreadyAnswered = true;
    gameUpdateTimer.cancel();
    globalPlayer.sendPlayerToServer(globalServer);
    Navigator.pushNamed(context, globalPlayer.getCurrentPage).then(restartTimer);
  }

  FutureOr restartTimer(dynamic value){
    setState((){
      if(!gameUpdateTimer.isActive)
      {
        startGameUpdateTimer();
      }
      if(!buzzTimer.isActive)
      {
        startBuzzTimer();
      }
    });
  }

  void startBuzzTimer() {
    buzzTimer = Timer(Duration(seconds: 1), () {
      globalPlayer.setCurrentPage = '/board';
      globalPlayer.alreadyAnswered = false;
      globalPlayer.sendPlayerToServer(globalServer);
      Navigator.of(context).pushNamedAndRemoveUntil("/board", (route) => false);
      dispose();
    });
  }

  void startGameUpdateTimer() {
    gameUpdateTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {});
      if(globalPlayer.getCurrentPage == '/wait'){
        gameUpdateTimer.cancel();
        buzzTimer.cancel();
        Navigator.pushNamed(context, '/wait').then(restartTimer);
      }
    });
  }

  @override
  void dispose() {
    gameUpdateTimer.cancel();
    buzzTimer.cancel();
    super.dispose();
  }
}
