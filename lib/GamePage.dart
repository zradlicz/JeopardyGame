import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:5000'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinGame() {
    final userName = _nameController.text;
    if (userName.isNotEmpty) {
      _channel.sink.add('/name $userName');
    }
  }

  void _buzzIn() {
    _channel.sink.add('/buzz');
  }

  void _submitAnswer() {
    final userAnswer = _answerController.text;
    if (userAnswer.isNotEmpty) {
      _channel.sink.add('/answer $userAnswer');
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _answerController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
