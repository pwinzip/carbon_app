import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:carbonapp/pages/showcamera.dart';
import 'package:carbonapp/pages/showsensorvalue.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    print("%%%%%%%%");
    print(widget.cameras);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShowSensorValue(),
                      ));
                },
                child: const Text("เริ่มต้น SENSOR")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShowCamera(cameras: widget.cameras),
                      ));
                },
                child: const Text("เริ่มต้น CAMERA")),
          ],
        ),
      ),
    );
  }
}
