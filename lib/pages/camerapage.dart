import 'dart:async';

import 'package:camera/camera.dart';
import 'package:carbonapp/pages/calheight.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  //
  CameraController? controller;
  bool _isCameraInitialized = false;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  double? xInclination;
  double? yInclination;
  double? zInclination;

  int _step = 0;
  String bottomText = "ขั้นตอนที่ 1 ถ่ายภาพที่โคนต้นไม้";

  double? topDegree;
  double? bottomDegree;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
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
      await cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // // Update the Boolean
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

  initSensorListener() {
    if (!mounted) {
      return;
    }
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            // _accelerometerValues = <double>[event.x, event.y, event.z];
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
  void initState() {
    super.initState();
    onNewCameraSelected(widget.cameras[0]);
    initSensorListener();
  }

  @override
  void dispose() {
    controller?.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: 1 / controller!.value.aspectRatio,
                  child: Stack(
                    children: [
                      // CameraPreview(controller!),
                      controller!.buildPreview(),
                      Center(child: drawHorizontalLine()),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 40.0, left: 20.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // child: Text("${yInclination!.round()}°"),
                          child: zInclination! >= 0
                              ? Text(
                                  "${90 - yInclination!.round()}°",
                                  style: const TextStyle(color: Colors.black),
                                )
                              : Text(
                                  "${90 + yInclination!.round()}°",
                                  style: const TextStyle(color: Colors.black),
                                ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: _step < 2
                                ? () {
                                    print(yInclination);
                                    print(zInclination);
                                    print("---------------");
                                    if (_step == 1) {
                                      setState(() {
                                        // topDegree = zInclination! >= 0
                                        //     ? yInclination!
                                        //     : 90 + yInclination!;
                                        _step = 2;
                                        bottomText = "ไปขั้นตอนถัดไป";
                                        topDegree = yInclination;
                                      });
                                      print("second capture");
                                      print(topDegree);
                                    } else if (_step == 0) {
                                      setState(() {
                                        _step = 1;
                                        bottomText =
                                            "ขั้นตอนที่ 2 ถ่ายภาพที่ยอดต้นไม้";
                                        // bottomDegree = zInclination! >= 0
                                        //     ? yInclination!
                                        //     : 90 + yInclination!;
                                        bottomDegree = yInclination;
                                        print("first capture");
                                        print(bottomDegree);
                                      });
                                    } else if (_step == 2) {
                                      setState(() {
                                        _step = 3;
                                      });
                                    }
                                  }
                                : null,
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ElevatedButton(
                                onPressed: _step == 2
                                    ? () {
                                        if (mounted) setState(() {});
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CalulateHeightPage(
                                                bottomDegree: bottomDegree,
                                                topDegree: topDegree,
                                                cameras: widget.cameras,
                                              ),
                                            ));
                                      }
                                    : null,
                                child: const Text("ถัดไป")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        bottomText,
                        style: const TextStyle(color: Colors.black),
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
