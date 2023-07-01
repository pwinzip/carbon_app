import 'package:flutter/material.dart';
import 'dart:math' as math;

class BambooTab extends StatefulWidget {
  const BambooTab({super.key});

  @override
  State<BambooTab> createState() => _BambooTabState();
}

class _BambooTabState extends State<BambooTab> {
  final _formBambooKey = GlobalKey<FormState>();
  final TextEditingController _circumferenceBambooTree =
      TextEditingController();
  double bamboCarbonResult = 0;

  calBambooCarbon() {
    double D;

    D = double.parse(_circumferenceBambooTree.text) / math.pi;

    setState(() {
      bamboCarbonResult = (0.639 * math.pow(D, 1.6162)) * (47.00 / 100);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _circumferenceBambooTree.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formBambooKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("กรุณาใส่เส้นรอบวงของต้นไม้"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "เส้นรอบวงของต้นไม้",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  buildNumberInput(
                      context, _circumferenceBambooTree, "เซนติเมตร"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    calBambooCarbon();
                  },
                  child: const Text("คำนวณปริมาณคาร์บอน"),
                ),
              ),
              ReusableCard(
                colour: const [Color(0xFF8BCFD8), Color(0xFFBADD96)],
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ปริมาณคาร์บอนกักเก็บ',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Text(
                      bamboCarbonResult.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 50,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'กิโลกรัม',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color.fromRGBO(62, 62, 62, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildNumberInput(
      BuildContext context, TextEditingController controller, String suffix) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              suffixText: suffix,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    super.key,
    required this.colour,
    required this.cardChild,
  });
  final List<Color> colour;
  final Widget cardChild;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      // margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        // color: colour,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colour),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: cardChild,
    );
  }
}
