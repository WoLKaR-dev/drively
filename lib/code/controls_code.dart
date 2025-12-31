import 'dart:io';

import 'package:drively/class/pedals_class.dart';
import 'package:drively/data/general_data.dart';

//PART UDP SOCKET
late RawDatagramSocket udpSocket;
Future<void> openUDP() async {
  String ip = await getOpenedIP();
  if (ip != "") {
    int port = currentDevice == Device.mobile ? 0 : 55555;
    udpSocket = await RawDatagramSocket.bind(InternetAddress(ip), port);
    return; 
  }
}

/*
Obtiene una string con una ip iniciada
@return IP
*/
Future<String> getOpenedIP() async {
  List<NetworkInterface> interfaces = await NetworkInterface.list();
  for (NetworkInterface netInterface in interfaces) {
    if ((netInterface.name == "Wi-Fi" || netInterface.name == "wlan0") &&
        netInterface.addresses.isNotEmpty) {
      return netInterface.addresses[0].address;
    }
  }
  return "";
}

/*
Inicializa la escucha del socket
*/
void initDataReception() {
  udpSocket.listen((event) {
    if (event == RawSocketEvent.read) {
      Datagram? datagram = udpSocket.receive();
      if (datagram != null) {
        List<int> data = (datagram.data);

        Pedals.instance.updateData(
          newBrake: normalizePedals(data[0]),
          newGas: normalizePedals(data[1]),
          newRotation: normalizeDirection(data[2]),
        );
      }
    }
  });
}

/*
Retorna gas/brake transformado a bytes
@return Bytes (0-255)
*/
int encodePedals(double usage) {
  double byteValue = ((usage * 255) / 100);
  int bytes = int.parse(byteValue.toStringAsFixed(0));
  return bytes;
}

/*
Retorna el valor del volante transformado a bytes
@return bytes (0-255)
*/
int encodeDirection(double direction) {
  return (((direction.clamp(-10, 10) + 10) / 20) * 255).round();
}

/*
Normaliza el valor de los pedales
@return Double normalizado
*/
double normalizePedals(int bytes) {
  return ((bytes * 100) / 255)/10;
}

/*
Normaliza el valor de la direccion
@return Double normalizado
*/
double normalizeDirection(int bytes) {
  return ((bytes / 255) * 20) - 10;
}
