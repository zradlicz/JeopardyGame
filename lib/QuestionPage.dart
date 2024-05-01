import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async'; // Import dart:async for Timer
import 'dart:convert';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late Timer gameUpdateTimer;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    startGameUpdateTimer(); // Start the timer to update player list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Background color
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: () {
            //Navigator.pop(context); // Navigate back to the previous screen
            //Navigator.pop(context);
            _goHome();
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                if (!isDrawerOpen) {
                  setState(() {
                    isDrawerOpen = true;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        game.currentQuestion.question, // Add your text here
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _buzzIn,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Button background color
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(100), // Increase padding for bigger button
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          CircleBorder(), // Make the button circular
                        ),
                      ),
                      child: Text(
                        '!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isDrawerOpen = !isDrawerOpen; // Toggle the drawer visibility
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 100,
                  height: 5,
                  color: Colors.white, // Color of the bar
                  child: Center(
                    child: Text(
                      isDrawerOpen ? 'Hide Players' : 'Show Players', // Text based on drawer state
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isDrawerOpen) ...[
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[600],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: game.players.map((player) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue[200],
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              player.name,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              player.score.toString(),
                              style: TextStyle(color: Colors.black),
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
        ],
      ),
    );
  }

  void _goHome(){
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
    player.setCurrentPage = '/landing';
    player.setBuzzStatus = false;
    server.dispose();
  }
  void _buzzIn() {
    player.setBuzzStatus = true;
    Navigator.pushNamed(context, '/answer');
    player.sendPlayerToServer(server);
  }

  void startGameUpdateTimer() {
    gameUpdateTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {});
      if(player.getCurrentPage == '/wait'){
        Navigator.pushNamed(context, player.getCurrentPage);
        gameUpdateTimer.cancel();
      }
    });
  }


  @override
  void dispose() {
    gameUpdateTimer.cancel();
    super.dispose();
  }
}
