import 'dart:io';

import 'package:drively/code/controls_code.dart';

class ConnectionData {
  static final ConnectionData _instance = ConnectionData._internal();

  //PART Atributos
  String ip = "";
  String dataPort = "";
  String controllerPort = "";

  //PART Constructor
  ConnectionData._internal();

  //PART Métodos
  void setData(String newIp, String newDataPort, String newControllerPort) {
    ip = newIp;
    dataPort = newDataPort;
    controllerPort = newControllerPort; 
  }

  void send(dynamic data) {
    udpSocket.send(data, InternetAddress(ip), int.parse(dataPort));
    udpSocket.send(data, InternetAddress(ip), int.parse(controllerPort));
  }

  //PART Getters
  static ConnectionData get instance => _instance;
}
