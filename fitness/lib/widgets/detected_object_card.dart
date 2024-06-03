import 'package:fitness/controller/scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetectedObjectsCard extends StatelessWidget {
  final ScanController scanController = Get.find();

  DetectedObjectsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: scanController.getDetectedObjects().length,
        itemBuilder: (context, index) {
          var object = scanController.getDetectedObjects()[index];
          return Padding(
            padding: const EdgeInsets.all(
              20.0,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: const Icon(Icons.label),
                  title: Text(object["label"]),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
