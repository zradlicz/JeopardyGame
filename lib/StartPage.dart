import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StartPage extends StatefulWidget {
  final List<String> playerNames;

  const StartPage({Key? key, required this.playerNames}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:5000'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeopardy Trivia Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startGame,
              child: Text('Start Game', style: TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Players in the game:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.playerNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.playerNames[index]),
                  );
                },
              ),
            ),
            StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                },
              ),
          ],
        ),
      ),
    );
  }

  void _startGame() {
    // Add logic to start the game, navigate to the game page, etc.
    Navigator.pushNamed(context, '/game');
  }
}