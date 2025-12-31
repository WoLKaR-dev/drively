class Pedals {
  //PART Atributos
  static final Pedals _instance = Pedals._internal();
  double _gas = 0;
  double _brake = 0;
  double _rotation = 0;

  //PART Constructor
  Pedals._internal();

  //PART Métodos
  void updateData({double? newGas, double? newBrake, double? newRotation}) {
    _gas = newGas ?? _gas;
    _brake = newBrake ?? _brake;
    _rotation = newRotation ?? _rotation;
  }

  //PART Getters
  double get gas => _gas;
  double get brake => _brake;
  double get rotation => _rotation; 
  static Pedals get instance => _instance;
}
