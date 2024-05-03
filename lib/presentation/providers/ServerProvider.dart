import 'dart:io';

import 'package:flutter/material.dart';


class ServerProvider with ChangeNotifier {
  bool isConnected = false;

  late Socket _socket;
  late Socket _senderSocket;
  late Socket _listenerSocket;

  Socket get socket => _socket;
  Socket get senderSocket => _senderSocket;
  Socket get listenerSocket => _listenerSocket;

  void add(String msg) {
    //_socket.sink.add(msg);
    notifyListeners();
  }

  /*socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });
  socket.on('event', (data) => print(data));
  socket.onDisconnect((_) => print('disconnect'));
  socket.on('fromServer', (_) => print(_));*/

  void setSocket({
    required Socket listenerSocket,
    required Socket senderSocket
  }) async {
    _senderSocket = senderSocket;
    _listenerSocket = listenerSocket;
    notifyListeners();
  }
}
