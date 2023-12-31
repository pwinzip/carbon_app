import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

import 'countstepspage.dart';

class ShowCamera extends StatefulWidget {
  const ShowCamera(
      {super.key, required this.cameras, required this.personheight});

  final List<CameraDescription> cameras;
  final String personheight;

  @override
  State<ShowCamera> createState() => _ShowCameraState();
}

class _ShowCameraState extends State<ShowCamera> with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;

  String bottomText = "ถ่ายภาพส่วนที่ต่ำสุดของต้นไม้";

  // List<double>? _accelerometerValues;

  double? xInclination;
  double? yInclination;
  double? zInclination;

  int _step = 0;

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
  void dispose() {
    controller?.dispose();
    _step = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final accelerometer =
    //     _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: _step == 0
            ? const Text(
                "ขั้นตอนที่ 1",
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                "ขั้นตอนที่ 2",
                style: TextStyle(color: Colors.black),
              ),
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
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: _step == 0
                              ? const Text(
                                  "ขั้นตอนที่ 1",
                                  style: TextStyle(color: Colors.black),
                                )
                              : const Text(
                                  "ขั้นตอนที่ 2",
                                  style: TextStyle(color: Colors.black),
                                ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              print(yInclination);
                              print(zInclination);
                              print("---------------");
                              if (_step == 1) {
                                topDegree = zInclination! < 0
                                    ? 90 + yInclination!
                                    : yInclination;
                                _step = 2;
                                print("second capture");
                                print(topDegree);
                              } else if (_step == 0) {
                                setState(() {
                                  _step = 1;
                                  bottomText = "ไปขั้นตอนถัดไป";
                                  bottomDegree = zInclination! > 0
                                      ? yInclination
                                      : 90 + yInclination!;
                                  print("first capture");
                                  print(bottomDegree);
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            // decoration: BoxDecoration(
                            //   color: Colors.white,
                            //   borderRadius: BorderRadius.circular(12.0),
                            // ),
                            child: ElevatedButton(
                                onPressed: _step == 2
                                    ? () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CountStepsPage(
                                                      personheight:
                                                          widget.personheight,
                                                      bottomDegree:
                                                          bottomDegree,
                                                      topDegree: topDegree),
                                            ));
                                      }
                                    : null,
                                child: const Text("ถัดไป")),
                            // child: IconButton(
                            //   onPressed: () {
                            //     print(bottomDegree);
                            //     print(topDegree);
                            //     print("********");
                            //     double h = 150;
                            //     double hc = 0;
                            //     int n = 30;
                            //     double L = 0;

                            //     if (h < 150) {
                            //       hc = h - 9.545;
                            //       L = 0.635;
                            //     } else if (h >= 150 && h < 160) {
                            //       hc = h - 11.654;
                            //       L = 0.628;
                            //     } else if (h >= 160 && h < 170) {
                            //       hc = h - 12.047;
                            //       L = 0.641;
                            //     } else if (h >= 170 && h < 180) {
                            //       hc = h - 11.948;
                            //       L = 0.650;
                            //     } else {
                            //       hc = h - 11.833;
                            //       L = 0.705;
                            //     }
                            //     double phi =
                            //         degree2Radians(90 - bottomDegree!.round());
                            //     double theta =
                            //         degree2Radians(90 - topDegree!.round());

                            //     double lambda = math.atan(hc / (n * L)) - phi;

                            //     double h1 = math.tan(theta);
                            //     double h2 = math.tan(phi);
                            //     double d = n * L * math.cos(lambda);

                            //     double hTree = d * (h1 + h2);

                            //     print("phi = $phi");
                            //     print("theta = $theta");
                            //     print("lambda = $lambda");
                            //     print("h1 = $h1");
                            //     print("h2 = $h2");
                            //     print("d = $d");
                            //     print("hTree = $hTree");
                            //   },
                            //   icon: const Icon(Icons.arrow_forward_ios_rounded),
                            // ),
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

  double degree2Radians(int deg) {
    return deg * (math.pi / 180);
  }
}
