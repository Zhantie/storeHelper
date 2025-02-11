import 'package:camera/camera.dart';
import 'package:fitness/controller/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanController>(
      init: ScanController(),
      builder: (controller) {
        return controller.isCameraInitialized.value
            ? CameraPreview(
                controller.cameraController,
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "Loading Preview...",
                    ),
                  ],
                ),
              );
      },
    );
  }
}