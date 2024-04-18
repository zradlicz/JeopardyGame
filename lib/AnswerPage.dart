import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:convert';
import 'dart:async'; // Import dart:async for Timer

class AnswerPage extends StatefulWidget {
  const AnswerPage({Key? key}) : super(key: key);

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final TextEditingController _answerController = TextEditingController();
  String question = game.currentQuestion;
  late Timer updatePageTimer;

  @override
  void initState() {
    startPageUpdate();
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
            Navigator.of(context).popUntil((route) => route.isFirst); // Navigate back to the landing page
            player.currentPage = 'landing';
            player.buzzStatus = false;
            server.dispose();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  question, // Add your text here
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                          EdgeInsets.all(10), // Increase padding for bigger button
                        ),
                      ),
                      child: Text(
                        'Submit Answer',
                        style: TextStyle(
                          fontSize: 14,
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

  void _submitAnswer() {
    final userAnswer = _answerController.text;
    if (userAnswer.isNotEmpty) {
      player.answer = userAnswer;
      String playerJSON = json.encode(player.toJson());
      server.sendToServer(playerJSON);
    }
  }

  void startPageUpdate() {
    // Start a timer to update playerList every 2 seconds
    updatePageTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if(player.currentPage == 'question'){
        dispose();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    updatePageTimer.cancel();
    _answerController.dispose();
    super.dispose();
  }
}
