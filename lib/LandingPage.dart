import 'package:flutter/material.dart';
import 'main.dart';

class LandingPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Jeopardy!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _joinGame(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Join Game',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    void _joinGame(BuildContext context){
      if(globalPlayer.name == _nameController.text.trim()){
        globalPlayer.setCurrentPage = '/start';
        globalPlayer.sendPlayerToServer(globalServer);
        Navigator.pushNamed(context, globalPlayer.getCurrentPage);
      }else{
        globalPlayer.setName = _nameController.text.trim();
        globalPlayer.score = 0;
        globalPlayer.setCurrentPage = '/start';
        globalPlayer.sendPlayerToServer(globalServer);
        Navigator.pushNamed(context, globalPlayer.getCurrentPage);
      }
      
      
  }
}