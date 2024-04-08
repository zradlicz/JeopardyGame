import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:convert';

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
                if(server.reconnectNeeded){server.reconnect();}
                String playerName = _nameController.text.trim();
                player.playerName = playerName;
                String playerJSON = json.encode(player.toJson());
                print(playerJSON);
                Navigator.pushNamed(context, '/start');
                server.sendToServer(playerJSON);
                // Navigate to the game page
                
              },
              child: Text('Join Game'),
            ),
          ],
        ),
      ),
    );
  }
}