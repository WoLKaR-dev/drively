import 'dart:io';
import 'package:drively/data/general_data.dart';

void detectDevice() {
  if (Platform.isWindows) {
    currentDevice = Device.desktop;
  } else {
    currentDevice = Device.mobile;
  }
}
