import 'package:flutter/material.dart';
import 'dart:math' as math;

class CountStepsPage extends StatefulWidget {
  const CountStepsPage(
      {super.key,
      required this.personheight,
      this.bottomDegree,
      this.topDegree});

  final String personheight;
  final double? bottomDegree;
  final double? topDegree;

  @override
  State<CountStepsPage> createState() => _CountStepsPageState();
}

class _CountStepsPageState extends State<CountStepsPage> {
  final TextEditingController _stepController = TextEditingController();

  double hTree = 0;

  calulateTreeHeight() {
    double hc = 0;
    int n =
        _stepController.text.isNotEmpty ? int.parse(_stepController.text) : 0;
    double L = 0;
    double h = double.parse(widget.personheight);

    if (h < 150) {
      hc = h - 9.545;
      L = 0.635;
    } else if (h >= 150 && h < 160) {
      hc = h - 11.654;
      L = 0.628;
    } else if (h >= 160 && h < 170) {
      hc = h - 12.047;
      L = 0.641;
    } else if (h >= 170 && h < 180) {
      hc = h - 11.948;
      L = 0.650;
    } else {
      hc = h - 11.833;
      L = 0.705;
    }

    double phi = degree2Radians(90 - widget.bottomDegree!.round());
    double theta = degree2Radians(90 - widget.topDegree!.round());

    double lambda = math.atan(hc / (n * L)) - phi;

    double h1 = math.tan(theta);
    double h2 = math.tan(phi);
    double d = n * L * math.cos(lambda);

    double hTree = d * (h1 + h2);

    print("phi = $phi");
    print("theta = $theta");
    print("lambda = $lambda");
    print("h1 = $h1");
    print("h2 = $h2");
    print("d = $d");
    print("hTree = $hTree");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("คำนวณส่วนสูงของต้นไม้"),
      ),
      body: SafeArea(
          child: Center(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Card(
                child: Text("เดินไปยังต้นไม้ และใส่จำนวนก้าว"),
              ),
            ),
            const Text("จำนวนก้าว"),
            TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: _stepController,
            ),
            ElevatedButton(
              onPressed: calulateTreeHeight,
              child: const Text("คำนวณความสูงของต้นไม้"),
            )
          ],
        ),
      )),
    );
  }

  double degree2Radians(int deg) {
    return deg * (math.pi / 180);
  }
}
