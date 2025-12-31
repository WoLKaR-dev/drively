import 'package:drively/class/pedals_class.dart';
import 'package:drively/data/general_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//STYLE Pedales
class PedalSlider extends StatefulWidget {
  final Pedal pedal;
  const PedalSlider({super.key, required this.pedal});

  @override
  State<PedalSlider> createState() => _PedalSliderState();
}

class _PedalSliderState extends State<PedalSlider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(25),

      child: Container(
        decoration: BoxDecoration(
          color: switch (widget.pedal) {
            Pedal.brake => const Color.fromARGB(85, 255, 82, 82),
            Pedal.gas => const Color.fromARGB(90, 105, 240, 175),
            Pedal.clutch => const Color.fromARGB(88, 68, 137, 255),
          },
        ),
        width: MediaQuery.sizeOf(context).width * 0.25,
        height: MediaQuery.sizeOf(context).height * 0.85,
        child: Stack(
          alignment: AlignmentGeometry.bottomCenter,
          children: [
            Container(
              height: widget.pedal == Pedal.brake
                  ? ((Pedals.instance.brake * (MediaQuery.sizeOf(context).height * 0.85)) / 100)
                  : ((Pedals.instance.gas * (MediaQuery.sizeOf(context).height * 0.85)) / 100),
              decoration: BoxDecoration(
                color: switch (widget.pedal) {
                  Pedal.brake => Colors.redAccent,
                  Pedal.gas => Colors.green,
                  Pedal.clutch => Colors.blueAccent,
                },
              ),
            ),
            GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onVerticalDragUpdate: (details) {
                Offset localPosition = details.localPosition;
                final double maxHeight = MediaQuery.sizeOf(context).height * 0.85;
                double percentaje = (localPosition.dy * 100) / maxHeight;
                int localPercentaje = int.parse(percentaje.toStringAsFixed(0));
                if (localPercentaje < 0) {
                  localPercentaje = 0;
                } else if (localPercentaje > 100) {
                  localPercentaje = 100;
                }
                localPercentaje = (localPercentaje - 100).abs();
                setState(() {
                  Pedals.instance.updateData(
                    newBrake: widget.pedal == Pedal.brake ? localPercentaje.toDouble() : null,
                    newGas: widget.pedal == Pedal.gas ? localPercentaje.toDouble() : null,
                  );
                });
              },
              onVerticalDragEnd: (details) {
                setState(() {
                  Pedals.instance.updateData(
                    newBrake: widget.pedal == Pedal.brake ? 0 : null,
                    newGas: widget.pedal == Pedal.gas ? 0 : null,
                  );
                });
              },
            ),
            
          ],
        ),
      ),
    );
  }
}

//STYLE Visual Pedal
class VisualPedals extends StatefulWidget {
  final Pedal pedal;
  const VisualPedals({super.key, required this.pedal});
  @override
  State<VisualPedals> createState() => _VisualPedalsState();
}

class _VisualPedalsState extends State<VisualPedals> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(25),

      child: Container(
        decoration: BoxDecoration(
          color: switch (widget.pedal) {
            Pedal.brake => const Color.fromARGB(85, 255, 82, 82),
            Pedal.gas => const Color.fromARGB(90, 105, 240, 175),
            Pedal.clutch => const Color.fromARGB(88, 68, 137, 255),
          },
        ),
        width: MediaQuery.sizeOf(context).width * 0.05,
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Stack(
          alignment: AlignmentGeometry.bottomCenter,
          children: [
            Container(
              height: widget.pedal == Pedal.brake
                  ? ((Pedals.instance.brake * (MediaQuery.sizeOf(context).height * 0.8)) / 10)
                  : ((Pedals.instance.gas * (MediaQuery.sizeOf(context).height * 0.8)) / 10),
              decoration: BoxDecoration(
                color: switch (widget.pedal) {
                  Pedal.brake => Colors.redAccent,
                  Pedal.gas => Colors.green,
                  Pedal.clutch => Colors.blueAccent,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//STYLE Direction
class DirectionBar extends StatelessWidget {
  final double rotation;
  const DirectionBar({super.key, required this.rotation});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.40,
      height: 30,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 26, 26, 26),
        borderRadius: BorderRadius.circular(360),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: switch (rotation) {
              < -2 => const Color.fromARGB(190, 255, 82, 82),
              < 2 => const Color.fromARGB(185, 255, 214, 64),
              < 10 => const Color.fromARGB(186, 76, 175, 79),
              _ => Colors.blueAccent,
            },
            borderRadius: BorderRadius.circular(360),
          ),
          width: (rotation.abs() * (MediaQuery.sizeOf(context).width * 0.40)) / 10,
          height: 30,
        ),
      ),
    );
  }
}

//STYLE Direction Icon
class DirectionIcon extends StatelessWidget {
  final double rotation;
  const DirectionIcon({super.key, required this.rotation});
  @override
  Widget build(BuildContext context) {
    return Icon(
      switch (rotation) {
        < -2 => Icons.arrow_back,
        < 2 => Icons.arrow_upward,
        < 10 => Icons.arrow_forward,
        _ => Icons.arrow_upward,
      },
      size: 30,
      color: Colors.white,
    );
  }
}
