import 'package:camera/camera.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "กรุณาใส่ส่วนสูง";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    suffixText: "เซนติเมตร",
                    labelText: "ส่วนสูง",
                  ),
                  keyboardType: TextInputType.number,
                  controller: _heightController,
                ),
              ),
            ),
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
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowCamera(
                              cameras: widget.cameras,
                              personheight: _heightController.text),
                        ));
                  }
                },
                child: const Text("เริ่มต้น CAMERA")),
          ],
        ),
      ),
    );
  }
}
