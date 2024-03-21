import 'package:flutter/material.dart';
import 'main.dart';

class StartPage extends StatefulWidget {
  final List<String> playerNames;

  const StartPage({Key? key, required this.playerNames}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
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
          ],
        ),
      ),
    );
  }

  void _startGame() {
    // Add logic to start the game, navigate to the game page, etc.
    Navigator.pushNamed(context, '/question');
  }
}