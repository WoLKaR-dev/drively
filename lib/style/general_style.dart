import 'package:flutter/material.dart';

ColorScheme colorPallete = ColorScheme.fromSeed(seedColor: Colors.amber);
ThemeData appTheme() => ThemeData(
  colorScheme: colorPallete,
  //SECTION Navigation Bar
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    backgroundColor: colorPallete.primaryFixed,
    indicatorColor: colorPallete.primaryFixedDim,
  ),
  //SECTION AppBar
  appBarTheme: AppBarThemeData(centerTitle: true, backgroundColor: colorPallete.primaryFixed),
  //SECTION Rail
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: colorPallete.primaryFixed,
    labelType: NavigationRailLabelType.selected,
    indicatorColor: colorPallete.primaryFixedDim,
    groupAlignment: 0,
  ),
  fontFamily: "Outfit",
);

class Background extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const Background({super.key, required this.child, this.padding});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(color: colorPallete.surface),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: child,
      ),
    );
  }
}

class Scroll extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final EdgeInsets? padding;
  const Scroll({super.key, required this.children, this.padding, this.spacing});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(spacing: spacing ?? 0, children: children),
    );
  }
}
