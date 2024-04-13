import 'package:flutter/material.dart';
import 'dart:async'; // Import dart:async for Timer
import 'dart:convert';
import 'main.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<String> playerList = [];
  late Timer updatePlayersTimer;

  @override
  void initState() {
    super.initState();
    startPlayerListUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Background color
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: () {
            server.dispose();
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startGame,
              child: Text('Start Game', style: TextStyle(fontSize: 24)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Button background color
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Button border radius
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Players in the game:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Text color
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: playerList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(playerList[index], style: TextStyle(color: Colors.white)), // Text color
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
    dispose();
    player.currentPage = 'question';
    String playerJSON = json.encode(player.toJson());
    server.sendToServer(playerJSON);
    print("Sending game page update");
  }
  
  void startPlayerListUpdate() {
    // Start a timer to update playerList every 2 seconds
    updatePlayersTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      updatePlayerList(); // Update playerList continuously
      if(player.currentPage == 'question'){
        Navigator.pushNamed(context, '/question');
        dispose();
      }
    });
  }

  void updatePlayerList() {
    setState(() {
      playerList = game.getPlayerNames();
    });
  }

  @override
  void dispose() {
    updatePlayersTimer.cancel(); // Cancel the timer in the dispose method
    super.dispose();
  }
}