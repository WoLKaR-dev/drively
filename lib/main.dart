import 'package:drively/code/general_code.dart';
import 'package:drively/core/navigation.dart';
import 'package:drively/style/general_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  detectDevice();
  runApp(const CurrentApp());
}

class CurrentApp extends StatelessWidget {
  const CurrentApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Drively",
      home: NavigationPage(),
      theme: appTheme(),
    );
  }
}
