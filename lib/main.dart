import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Jeopardy Trivia Game';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:5000'), //use ws://10.0.2.2:5000 for andriod studio
  );

  void _joinGame() {
  final userName = _nameController.text;
  if (userName.isNotEmpty) {
    _channel.sink.add('/name $userName');
  }
}

  void _buzzIn() {
    // Send '/buzz' to the server
    _channel.sink.add('/buzz');
  }

  void _submitAnswer() {
  final userAnswer = _answerController.text;
  if (userAnswer.isNotEmpty) {
    _channel.sink.add('/answer $userAnswer');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Enter your name'),
            ),
            ElevatedButton(
              onPressed: _joinGame,
              child: const Text('Join Game'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _buzzIn,
              child: const Text('Buzz In'),
            ),
            TextFormField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Enter your answer'),
            ),
            ElevatedButton(
              onPressed: _submitAnswer,
              child: const Text('Submit Answer'),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    _answerController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
