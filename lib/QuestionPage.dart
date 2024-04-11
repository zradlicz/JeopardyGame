import 'package:flutter/material.dart';
import 'main.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

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
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _buzzIn,
                child: Text('Buzz In'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(40), // Increase padding for bigger button
                  shape: CircleBorder(), // Make the button circular
                ),
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

  void _buzzIn() {
    server.sendToServer('/buzz');
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
