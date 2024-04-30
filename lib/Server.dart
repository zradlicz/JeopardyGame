//packages imported
import 'package:web_socket_channel/web_socket_channel.dart';

class Server {
  late WebSocketChannel channel;
  late String messageFromServer;
  late bool reconnectNeeded = false;

  Server() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://endless-lemming-only.ngrok-free.app'), //use for rpi server
      //Uri.parse('ws://localhost:5000'), //use for dev server
    );
    channel.stream.listen((message){
    messageFromServer = message;
  });
  }

  void reconnect(){
    channel = WebSocketChannel.connect(
      Uri.parse('wss://endless-lemming-only.ngrok-free.app'), //use for rpi server
      //Uri.parse('ws://localhost:5000'), //use for dev server
    );
    channel.stream.listen((message){
    messageFromServer = message;
    });
    reconnectNeeded = false;
  }

  String get currentMessageFromServer{
    return messageFromServer;
  }

  void sendToServer(String message) {
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close();
    reconnectNeeded = true;
  } 
} 