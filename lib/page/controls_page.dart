import 'dart:async';
import 'dart:io';

import 'package:drively/class/connection_class.dart';
import 'package:drively/class/pedals_class.dart';
import 'package:drively/code/controls_code.dart';
import 'package:drively/data/general_data.dart';
import 'package:drively/data/user_data.dart';
import 'package:drively/style/controls_style.dart';
import 'package:drively/style/general_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

//SCREEN Página de Conexion
class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});
  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final TextEditingController ipController = TextEditingController();
  final TextEditingController dataPortController = TextEditingController();
  final TextEditingController controllerPortController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Background(
      child: connected == true
          //SECTION Conectado
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: currentDevice == Device.desktop
                  //SECTION PC
                  ? []
                  //SECTION MOBILE
                  : [
                      //SECTION Abrir controles
                      ElevatedButton(
                        onPressed: () {
                          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DrivingControls()),
                          );
                        },
                        child: Text("Open Controls"),
                      ),
                      //SECTION Desconectar
                      ElevatedButton(
                        onPressed: () {
                          udpSocket.close();
                          setState(() {
                            connected = false;
                          });
                        },
                        child: Text("Disconnect"),
                      ),
                    ],
            )
          //SECTION No conectado
          : Scroll(
              padding: EdgeInsets.all(10),
              children: currentDevice == Device.desktop
                  //SECTION PC
                  ? [
                      //SECTION Inicializar
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PCInformation()),
                          );
                          connected = true;
                        },
                        child: Text("Init Service"),
                      ),
                    ]
                  //SECTION MOBILE
                  : [
                      //SECTION IP
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: ipController,
                        decoration: InputDecoration(hint: Text("IP")),
                      ),
                      //SECTION DATAPORT
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: dataPortController,
                        decoration: InputDecoration(hint: Text("DATA PORT")),
                      ),
                      //SECTION CONTROLLER PORT
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: controllerPortController,
                        decoration: InputDecoration(
                          hint: Text("CONTROLLER PORT (PREVIOUS PORT + 1)"),
                        ),
                      ),
                      //SECTION Conectar
                      ElevatedButton(
                        onPressed: () async {
                          ConnectionData connectionSingleton = ConnectionData.instance;
                          connectionSingleton.setData(
                            ipController.text,
                            dataPortController.text,
                            controllerPortController.text,
                          );
                          await openUDP();
                          setState(() {
                            connected = true;
                          });
                        },
                        child: Text("Connect"),
                      ),
                    ],
            ),
    );
  }
}

//SCREEN Controles
class DrivingControls extends StatefulWidget {
  const DrivingControls({super.key});
  @override
  State<DrivingControls> createState() => _DrivingControlsState();
}

class _DrivingControlsState extends State<DrivingControls> {
  Timer? sendTimer;

  void updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void startSending() {
    Duration delay = Duration(milliseconds: (1000 / hz).round());
    sendTimer = Timer.periodic(delay, (_) async {
      Uint8List packet = Uint8List.fromList([
        encodePedals(Pedals.instance.brake),
        encodePedals(Pedals.instance.gas),
        encodeDirection(Pedals.instance.rotation),
      ]);
      ConnectionData.instance.send(packet);
    });
  }

  @override
  void initState() {
    super.initState();
    acelerometerSubscription = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .listen((event) {
          Pedals.instance.updateData(
            newRotation: double.parse(event.y.toStringAsFixed(2)) * sensitivity,
          );
          updateState();
        });

    startSending();
  }

  @override
  void dispose() {
    super.dispose();
    acelerometerSubscription?.cancel();
    sendTimer?.cancel();
    sendTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //SECTION Pedal freno
            PedalSlider(pedal: Pedal.brake),
            //SECTION Controles Centrales
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 15,
                children: [
                  //SECTION Control de direccion
                  Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      DirectionBar(rotation: Pedals.instance.rotation),
                      DirectionIcon(rotation: Pedals.instance.rotation),
                    ],
                  ),
                  //SECTION Pedales (datos)
                  Row(
                    spacing: 10,
                    children: [
                      Text("Brake: ${Pedals.instance.brake}", style: TextStyle(fontSize: 20)),
                      Text("Gas: ${Pedals.instance.gas}", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  //SECTION Cerrar Controles
                  ElevatedButton(
                    onPressed: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitDown,
                        DeviceOrientation.portraitUp,
                      ]);
                      Navigator.pop(context);
                    },
                    child: Text("Close Controls"),
                  ),
                ],
              ),
            ),
            //SECTION Pedal Gas
            PedalSlider(pedal: Pedal.gas),
          ],
        ),
      ),
    );
  }
}

//SCREEN Informacion PC Conectado
class PCInformation extends StatefulWidget {
  const PCInformation({super.key});
  @override
  State<PCInformation> createState() => _PCInformationState();
}

class _PCInformationState extends State<PCInformation> {
  Process? controllerProcess;
  Timer? refreshTimer;
  String ip = "";
  String port = "";
  @override
  void initState() {
    super.initState();
    initIp();
  }

  void initIp() async {
    controllerProcess = await Process.start(
      kReleaseMode == true
          ? "data/flutter_assets/assets/controllers/ViGEmBridge.exe"
          : "assets/controllers/ViGEmBridge.exe",
      [],
      mode: ProcessStartMode.normal,
    );

    await openUDP();
    initDataReception();
    ip = await getOpenedIP();
    port = udpSocket.port.toString();
    startRefresh();
    Pedals.instance.updateData(newBrake: 0, newGas: 0, newRotation: 0);
    setState(() {});
  }

  void startRefresh() {
    Duration refreshTime = Duration(milliseconds: 10);
    refreshTimer = Timer.periodic(refreshTime, (_) async {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerProcess?.kill();
    controllerProcess = null;
    refreshTimer?.cancel();
    refreshTimer = null;
    udpSocket.close();
    connected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Scroll(
          padding: EdgeInsets.all(10),
          children: [
            //SECTION Datos
            Text("ACTIVE: \nIP: $ip \nPORT: $port", style: TextStyle(fontSize: 20)),
            //SECTION
            Text("Freno: ${Pedals.instance.brake}"),
            Text("Acelerador: ${Pedals.instance.gas}"),
            Text("Giro: ${Pedals.instance.rotation}"),
            Stack(
              alignment: AlignmentGeometry.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    VisualPedals(pedal: Pedal.brake),
                    VisualPedals(pedal: Pedal.gas),
                  ],
                ),
                DirectionBar(rotation: Pedals.instance.rotation),
                DirectionIcon(rotation: Pedals.instance.rotation),
              ],
            ),
            //SECTION Desconectar
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
