import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class ShowCamera extends StatefulWidget {
  const ShowCamera({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<ShowCamera> createState() => _ShowCameraState();
}

class _ShowCameraState extends State<ShowCamera> with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;

  String bottomText = "ถ่ายภาพส่วนที่ต่ำสุดของต้นไม้";

  List<double>? _accelerometerValues;

  String xAngle = "";
  String yAngle = "";
  String zAngle = "";
  double? xInclination;
  double? yInclination;
  double? zInclination;

  bool _isbottomTaken = false;
  double? topDegree;
  double? bottomDegree;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void initState() {
    super.initState();
    onNewCameraSelected(widget.cameras[0]);
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
            // Calculate angle
            double x = event.x, y = event.y, z = event.z;
            double normOfG = math.sqrt(
                event.x * event.x + event.y * event.y + event.z * event.z);
            x = event.x / normOfG;
            y = event.y / normOfG;
            z = event.z / normOfG;

            xInclination = -(math.asin(x) * (180 / math.pi));
            yInclination = (math.acos(y) * (180 / math.pi));
            zInclination = (math.atan(z) * (180 / math.pi));

            xAngle = "${xInclination!.round()}°";
            yAngle = "${yInclination!.round()}°";
            zAngle = "${zInclination!.round()}°";
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Accelerometor Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
      ),
      body: _isCameraInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: 1 / controller!.value.aspectRatio,
                  child: Stack(
                    children: [
                      controller!.buildPreview(),
                      Center(child: drawHorizontalLine()),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              print(yInclination);
                              print(zInclination);
                              print("---------------");
                              if (_isbottomTaken) {
                                print("waiting for taking top view");
                              } else {
                                print("bottom view taken");
                                setState(() {
                                  _isbottomTaken = true;
                                  bottomText = "ถ่ายภาพส่วนที่สูงสุดของต้นไม้";
                                });
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20)),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.grey[300]), // <-- Button color
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.lightBlue; // <-- Splash color
                                }
                                return null;
                              }),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.lightGreen,
                    child: Center(
                      child: Text(
                        "ถ่ายภาพส่วนที่ต่ำสุดของต้นไม้",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  Widget drawHorizontalLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 1.0,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
      ),
    );
  }
}
