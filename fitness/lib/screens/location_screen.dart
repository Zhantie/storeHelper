import 'package:fitness/controller/scan_controller.dart';
import 'package:fitness/scaffolds/base_scaffold.dart';
import 'package:fitness/views/camera_view.dart';
import 'package:fitness/widgets/detected_object_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationProductScreen extends StatelessWidget {
  const LocationProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ScanController());

    return BaseScaffold(
      body: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Stack(
          children: [
            const CameraView(),
            CustomPaint(
              size: Size.infinite,
              painter: HolePainter(
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            DetectedObjectsCard(),
          ],
        ),
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  final Color color;
  HolePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final holeSize = size.width * 0.6;
    final holeRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: holeSize,
      height: holeSize,
    );

    final borderRadius = BorderRadius.circular(24); // Pas de border radius aan
    final borderSize = 10.0;

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRRect(RRect.fromRectAndRadius(holeRect, Radius.circular(24))),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
