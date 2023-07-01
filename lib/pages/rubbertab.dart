import 'package:flutter/material.dart';
import 'dart:math' as math;

class RubberTab extends StatefulWidget {
  const RubberTab({super.key});

  @override
  State<RubberTab> createState() => _RubberTabState();
}

class _RubberTabState extends State<RubberTab> {
  final _formRubberKey = GlobalKey<FormState>();
  final TextEditingController _heightRubberTree = TextEditingController();
  final TextEditingController _circumferenceRubberTree =
      TextEditingController();

  double rubberCarbonResult = 0;

  double log10(num x) => math.log(x) / math.ln10;
  num takeLog(num x) {
    return math.pow(10, x);
  }

  calRubberCarbon() {
    num stem, branch, leaf, root;
    double H, D;

    H = double.parse(_heightRubberTree.text);
    D = double.parse(_circumferenceRubberTree.text) / math.pi;
    num x = math.pow(D, 2) * H;

    stem = (takeLog((0.866 * log10(x)) - 1.255)) * (48.91 / 100);
    branch = (takeLog((1.140 * log10(x)) - 2.657)) * (49.83 / 100);
    leaf = takeLog((0.741 * log10(x)) - 1.654) * (51.80 / 100);
    root = takeLog((0.709 * log10(x)) - 0.131) * (47.00 / 100);

    setState(() {
      rubberCarbonResult = stem.toDouble() +
          branch.toDouble() +
          leaf.toDouble() +
          root.toDouble();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _heightRubberTree.dispose();
    _circumferenceRubberTree.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formRubberKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("กรุณาใส่ความสูงของต้นไม้ และเส้นรอบวง"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "ความสูงของต้นไม้",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  buildNumberInput(context, _heightRubberTree, "เมตร"),
                ],
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
                      context, _circumferenceRubberTree, "เซนติเมตร"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    calRubberCarbon();
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
                      rubberCarbonResult.toStringAsFixed(2),
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
