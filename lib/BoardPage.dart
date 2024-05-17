import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async'; // Import dart:async for Timer
import 'Game.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
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
            _goHome();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _openQuestionMenu();
            },
          ),
        ],
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
                    Text(
                      'Select a question:',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 25,
                        itemBuilder: (BuildContext context, int index) {
                          bool questionAnswered = checkIfQuestionAnswered(index);
                          int pointValue = (index ~/ 5 + 1) * 100; // Calculate point value dynamically
                          return ElevatedButton(
                            onPressed: questionAnswered ? null : () => _questionSelected(index),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(questionAnswered ? Colors.grey : Colors.blue),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(16), // Adjust padding as needed
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(fontSize: 18), // Adjust font size
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            child: Text(
                              '$pointValue',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          );
                        },
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
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white, // Color of the bar
                    borderRadius: BorderRadius.circular(10), // Rounded edges
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
                    children: globalGame.players.map((player) {
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

  bool checkIfQuestionAnswered(int index) {
    return globalGame.gameBoard.questionsAnswered[index];
  }

  void _goHome() {
    Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
    globalPlayer.currentPage = '/landing';
    globalPlayer.buzzStatus = false;
    globalServer.dispose();
  }

  void _questionSelected(int index) {
    // Provide feedback to the user (e.g., show a snackbar or dialog)
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Question $index selected!')),
    // );

    // Update player's current page and send data to server
    globalPlayer.currentPage = '/question';
    globalPlayer.questionSelection = index;
    globalPlayer.sendPlayerToServer(globalServer);
    gameUpdateTimer.cancel();
    Navigator.pushNamed(context, globalPlayer.getCurrentPage).then(restartTimer);
  }

  FutureOr restartTimer(dynamic value) {
    setState(() {
      if (!gameUpdateTimer.isActive) {
        startGameUpdateTimer();
      }
    });
  }

  void startGameUpdateTimer() {
    gameUpdateTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {});
      if (globalPlayer.currentPage == '/question') {
        gameUpdateTimer.cancel();
        Navigator.pushNamed(context, globalPlayer.getCurrentPage).then(restartTimer);
      }
    });
  }

void _openQuestionMenu() {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.blueGrey[600],
        child: ListView(
          children: globalGame.gameBoard.questions.asMap().entries.map((entry) {
            int index = entry.key;
            Question question = entry.value;
            bool questionAnswered = globalGame.gameBoard.questionsAnswered[index];

            // Display the question and answer only if corresponding index in questionsAnswered is true
            if (questionAnswered) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        question.question,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        question.answer,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Handle question tap if necessary
                  Navigator.pop(context); // Close the menu
                },
              );
            } else {
              return Container(); // Return an empty container if question is not answered
            }
          }).toList(),
        ),
      );
    },
  );
}

  @override
  void dispose() {
    super.dispose();
    gameUpdateTimer.cancel();
  }
}