import 'package:carbonapp/pages/showsensorvalue.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {}, child: const Text("เริ่มต้น CAMERA")),
          ],
        ),
      ),
    );
  }
}
