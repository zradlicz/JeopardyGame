import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:convert';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final TextEditingController _nameController = TextEditingController();
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
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _buzzIn,
                child: Text('Buzz In'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(40), // Increase padding for bigger button
                  shape: CircleBorder(), // Make the button circular
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buzzIn() {
    player.buzzStatus = true;
    print("Question:$question");
    print(game.toJson());
    Navigator.pushNamed(context, '/answer');
    String playerJSON = json.encode(player.toJson());
    server.sendToServer(playerJSON);
  }

  void _submitAnswer() {
    final userAnswer = _answerController.text;
    if (userAnswer.isNotEmpty) {
      server.sendToServer('/answer $userAnswer');
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}