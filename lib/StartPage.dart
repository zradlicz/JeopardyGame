import 'package:flutter/material.dart';
import 'dart:async'; // Import dart:async for Timer
import 'main.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late Timer gameUpdateTimer;

  @override
  void initState() {
    super.initState();
    startGameUpdateTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Background color
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: () {
            _goHome();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startGame,
                child: Text('Start Game', style: TextStyle(fontSize: 24, color: Colors.white)),
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
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: globalGame.players.map((player) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          constraints: BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue[200], // Ovular card background color
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                player.name,
                                style: TextStyle(color: Colors.black), // Ovular card text color
                              ),
                              Text(
                                player.score.toString(), // Initial score
                                style: TextStyle(color: Colors.black), // Score text color
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goHome(){
    globalServer.dispose();
    Navigator.pop(context); // Navigate back to the previous screen
  }

  void _startGame() {
    globalPlayer.setCurrentPage = '/board';
    globalPlayer.sendPlayerToServer(globalServer);
    Navigator.pushNamed(context, globalPlayer.getCurrentPage);
    dispose();
  }
  
  void startGameUpdateTimer() {
    gameUpdateTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {});
      if(globalPlayer.getCurrentPage == '/board'){
        Navigator.pushNamed(context, globalPlayer.getCurrentPage);
        dispose();
      }
    });
  }

  @override
  void dispose() {
    gameUpdateTimer.cancel(); // Cancel the timer in the dispose method
    super.dispose();
  }
}
