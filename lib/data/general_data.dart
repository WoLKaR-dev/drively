import 'dart:async';

enum Device { mobile, desktop }

enum Pedal { clutch, brake, gas }

Device? currentDevice;
bool connected = false;
StreamSubscription? acelerometerSubscription; 