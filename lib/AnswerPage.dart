import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:convert';

class AnswerPage extends StatefulWidget {
  const AnswerPage({Key? key}) : super(key: key);

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final TextEditingController _answerController = TextEditingController();
  String question = game.currentQuestion;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
            Navigator.pop(context);
            Navigator.pop(context);
            player.currentPage = 'landing';
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
                'Question:$question', // Add your text here
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Enter your answer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitAnswer,
                child: Text('Submit Answer'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Adjust padding as needed
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

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}