import 'package:flutter/material.dart';
import 'main.dart';

class LandingPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Jeopardy!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String playerName = _nameController.text.trim();
                player.playerName = playerName;
                game.addPlayer(player);
                server.sendToServer('/name $playerName');
                // Navigate to the game page
                Navigator.pushNamed(context, '/start');
              },
              child: Text('Join Game'),
            ),
          ],
        ),
      ),
    );
  }
}