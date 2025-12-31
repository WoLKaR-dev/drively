import 'package:drively/data/user_data.dart';
import 'package:drively/style/general_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController sensitivityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scroll(
        padding: EdgeInsets.all(10),
        children: [
          //SECTION Sensibilidad
          TextField(
            controller: sensitivityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hint: Text("Sensitivity (Current: ${sensitivity.toString()})"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              sensitivity = double.tryParse(sensitivityController.text) ?? 1.0;
              setState(() {});
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
