import 'package:fitness/scaffolds/base_scaffold.dart';
import 'package:fitness/views/camera_view.dart';
import 'package:flutter/material.dart';

class LocationProductScreen extends StatelessWidget {
  const LocationProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(
      body: SafeArea(
        child: CameraView(),
      ),
    );
  }
}