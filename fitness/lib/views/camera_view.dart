import 'package:camera/camera.dart';
import 'package:fitness/controller/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            var detector = controller.getDetectedObjects();
            return controller.isCameraInitialized.value
                ? Stack(
                    children: [
                      CameraPreview(
                        controller.cameraController,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.green,
                          child: Text(
                            "$detector",
                          ),
                        ),
                      )
                    ],
                  )
                : const Center(
                    child: Text(
                      "Loading Preview...",
                    ),
                  );
          },
        ),
      ),
    );
  }
}
