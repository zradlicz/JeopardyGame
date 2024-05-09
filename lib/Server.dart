//packages imported
import 'package:web_socket_channel/web_socket_channel.dart';
import 'main.dart';
import 'Game.dart';
import 'dart:convert';

const DEBUG = false;

class Server {
  late WebSocketChannel channel;
  late String messageFromServer;
  late bool reconnectNeeded = false;

  Server() {
    channel = WebSocketChannel.connect(
      //Uri.parse('wss://endless-lemming-only.ngrok-free.app'), //use for rpi server
      Uri.parse('ws://localhost:5000'), //use for dev server
    );
    channel.stream.listen((message){
    if(DEBUG){print(message);}
    messageFromServer = message;
    handleMessage(message);
  });
  }

  void reconnect(){
    channel = WebSocketChannel.connect(
      //Uri.parse('wss://endless-lemming-only.ngrok-free.app'), //use for rpi server
      Uri.parse('ws://localhost:5000'), //use for dev server
    );
    channel.stream.listen((message){
    if(DEBUG){print(message);}
    messageFromServer = message;
    handleMessage(message);
    });
    reconnectNeeded = false;
  }

  String get currentMessageFromServer{
    return messageFromServer;
  }

  void handleMessage(message){
    var jsonData = json.decode(message);
    globalGame = Game.fromJSON(jsonData);
    globalPlayer = globalGame.players.firstWhere((playerInGame) => playerInGame.name == globalPlayer.name,
    orElse: () => globalPlayer,
    );
    if(DEBUG){
      print("Handled server game update:");
      print("New player:");
      print(json.encode(globalPlayer.toJSON()));
      //print("New Game:");
      //print(json.encode(globalGame.toJSON()));
      }

  }

  void sendToServer(String message) {
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close();
    reconnectNeeded = true;
  } 
} 