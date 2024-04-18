import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async'; // Import dart:async for Timer

class WaitPage extends StatefulWidget {
  const WaitPage({Key? key}) : super(key: key);

  @override
  _WaitPageState createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer updatePageTimer;

  @override
  void initState() {
    super.initState();
    startPageUpdate();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    updatePageTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Background color
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home_filled),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst); // Navigate back to the landing page
            player.currentPage = 'landing';
            player.buzzStatus = false;
            server.dispose();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Waiting for answer...',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Text(
                  '...',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void startPageUpdate() {
    // Start a timer to update playerList every 2 seconds
    updatePageTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if(player.currentPage == 'question'){
        Navigator.pop(context);
        dispose();
      }
    });
  }
}


