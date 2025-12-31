import 'package:drively/data/general_data.dart';
import 'package:drively/page/controls_page.dart';
import 'package:drively/page/home_page.dart';
import 'package:drively/page/settings_page.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});
  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;
  List<Widget> navigationPages = [HomePage(), ConnectPage(), SettingsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SECTION Navigation Bar
      bottomNavigationBar: currentDevice == Device.mobile
          ? NavigationBar(
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              selectedIndex: selectedIndex,
              destinations: [
                NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                NavigationDestination(icon: Icon(Icons.cable_rounded), label: "Link"),
                NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
              ],
            )
          : null,

      //SECTION Cuerpo
      body: currentDevice == Device.mobile
          ? navigationPages[selectedIndex]
          : Row(
              children: [
                NavigationRail(
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  destinations: [
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text("Home")),
                    NavigationRailDestination(icon: Icon(Icons.cable_rounded), label: Text("Link")),
                    NavigationRailDestination(icon: Icon(Icons.settings), label: Text("Settings")),
                  ],
                  selectedIndex: selectedIndex,
                ),
                Expanded(child: navigationPages[selectedIndex]),
              ],
            ),
    );
  }
}
