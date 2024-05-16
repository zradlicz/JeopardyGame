import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async'; // Import dart:async for Timer

class AnswerPage extends StatefulWidget {
  const AnswerPage({Key? key}) : super(key: key);

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late TextEditingController _answerController;
  late Timer gameUpdateTimer;
  late Timer answerTimer;

  @override
  void initState() {
     _answerController = TextEditingController();
    startGameUpdateTimer();
    startAnswerTimer();
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
              SizedBox(height: 20),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Enter your answer',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Changed to white color
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                      onPressed: _submitAnswer,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Button background color
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Increase padding for bigger button
                        ),
                      ),
                      child: Text(
                        'Submit Answer',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  _goHome(){
    Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
    globalPlayer.setCurrentPage = '/landing';
    globalPlayer.setBuzzStatus = false;
    dispose();
  }
  void _submitAnswer() {
    final userAnswer = _answerController.text;
    if (userAnswer.isNotEmpty) {
      globalPlayer.answer = userAnswer;
      globalPlayer.sendPlayerToServer(globalServer);
    }
  }

  void startAnswerTimer() {
    answerTimer = Timer(Duration(seconds: 6), () {
      //_submitAnswer();
      answerTimer.cancel();
      });
  }

  void startGameUpdateTimer() {
    gameUpdateTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if(globalPlayer.getCurrentPage == '/board'){
        Navigator.of(context).pushNamedAndRemoveUntil("/board", (route) => false);
        dispose();   
      }
      if(globalPlayer.getCurrentPage == '/question'){
        Navigator.of(context).pushNamedAndRemoveUntil("/question", (route) => false);
        dispose();
      }
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    answerTimer.cancel();
    gameUpdateTimer.cancel();
    super.dispose();
  }
}
