import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'snake.dart';

import 'dart:math' as math;

class ShowSensorValue extends StatefulWidget {
  const ShowSensorValue({super.key});

  @override
  State<ShowSensorValue> createState() => _ShowSensorValueState();
}

class _ShowSensorValueState extends State<ShowSensorValue> {
  static const int _snakeRows = 20;
  static const int _snakeColumns = 20;
  static const double _snakeCellSize = 10.0;

  // List<double>? _userAccelerometerValues;
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;

  String xAngle = "";
  String yAngle = "";
  String zAngle = "";

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    // final userAccelerometer = _userAccelerometerValues
    //     ?.map((double v) => v.toStringAsFixed(1))
    //     .toList();
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Sensors")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
              ),
              child: SizedBox(
                height: _snakeRows * _snakeCellSize,
                width: _snakeColumns * _snakeCellSize,
                child: Snake(
                  rows: _snakeRows,
                  columns: _snakeColumns,
                  cellSize: _snakeCellSize,
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Text('UserAccelerometer: $userAccelerometer'),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Accelerometer: $accelerometer'),
                Column(
                  children: [
                    Text("$xAngle, $yAngle, $zAngle"),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Gyroscope: $gyroscope'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Magetometer: $magnetometer'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    // _streamSubscriptions.add(
    //   userAccelerometerEvents.listen(
    //     (UserAccelerometerEvent event) {
    //       setState(() {
    //         _userAccelerometerValues = <double>[event.x, event.y, event.z];
    //         // print("userACC: $_userAccelerometerValues");
    //       });
    //     },
    //     onError: (e) {
    //       showDialog(
    //           context: context,
    //           builder: (context) {
    //             return const AlertDialog(
    //               title: Text("Sensor Not Found"),
    //               content: Text(
    //                   "It seems that your device doesn't support Accelerometer Sensor"),
    //             );
    //           });
    //     },
    //     cancelOnError: true,
    //   ),
    // );
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

            double xInclination = -(math.asin(x) * (180 / math.pi));
            double yInclination = (math.acos(y) * (180 / math.pi));
            double zInclination = (math.atan(z) * (180 / math.pi));

            xAngle = "${xInclination.round()}°";
            yAngle = "${yInclination.round()}°";
            zAngle = "${zInclination.round()}°";
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
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
            // print("gyro: $_gyroscopeValues");
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Gyroscope Sensor ${e.toString()}"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
            // print("gyro: $_magnetometerValues");
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Manetometer Sensor ${e.toString()}"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }
}
