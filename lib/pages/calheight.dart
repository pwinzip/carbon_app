import 'package:camera/camera.dart';
import 'package:carbonapp/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class CalulateHeightPage extends StatefulWidget {
  const CalulateHeightPage(
      {super.key, this.bottomDegree, this.topDegree, required this.cameras});

  final double? bottomDegree;
  final double? topDegree;
  final List<CameraDescription> cameras;

  @override
  State<CalulateHeightPage> createState() => _CalulateHeightPageState();
}

class _CalulateHeightPageState extends State<CalulateHeightPage> {
  double hTree = 0;
  int height = 175;
  int steps = 0;

  calulateTreeHeight() {
    print("bottomDegree: ${widget.bottomDegree}");
    print("topDegree: ${widget.topDegree}");
    double hc = 0;
    int n = steps;
    double L = 0;
    double h = height.toDouble();

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

    setState(() {
      hTree = d * (h1 + h2);
    });

    print("phi = $phi");
    print("theta = $theta");
    print("lambda = $lambda");
    print("h1 = $h1");
    print("h2 = $h2");
    print("d = $d");
    print("hTree = $hTree");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReusableCard(
                colour: const Color(0xFF36BEBE),
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'ส่วนสูง',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFFF3F3F4),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          height.toString(),
                          style: const TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'cm',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFF3F3F4),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbColor: const Color(0xFFEB1555),
                        activeTrackColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 15.0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 30),
                        overlayColor: Color(0x29EB1555),
                      ),
                      child: Slider(
                        value: height.toDouble(),
                        min: 120.0,
                        max: 220.0,
                        inactiveColor: Color(0xFF8D8E98),
                        onChanged: (double newValue) {
                          setState(() {
                            height = newValue.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ReusableCard(
                colour: const Color(0xFF91CA6B),
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'จำนวนก้าว',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFFF3F3F4),
                      ),
                    ),
                    Text(
                      steps.toString(),
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundIconButton(
                            icon: FontAwesomeIcons.minus,
                            onPressed: () {
                              print(steps);
                              setState(() {
                                if (steps > 0) {
                                  steps--;
                                }
                              });
                            }),
                        const SizedBox(width: 10.0),
                        RoundIconButton(
                          icon: FontAwesomeIcons.plus,
                          onPressed: () {
                            setState(() {
                              steps++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BottomButton(
                buttonTitle: 'คำนวณความสูง',
                bgColor: Color.fromARGB(255, 235, 66, 117),
                onTap: () {
                  print("คำนวณ");
                  calulateTreeHeight();
                },
              ),
              ReusableCard(
                colour: Color(0xFFDAD9D9),
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ความสูงของต้นไม้',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFF282828),
                      ),
                    ),
                    Text(
                      hTree.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 50,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'เมตร',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFF282828),
                      ),
                    ),
                  ],
                ),
              ),
              BottomButton(
                buttonTitle: 'กลับหน้าหลัก',
                bgColor: Color.fromARGB(255, 64, 113, 227),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(cameras: widget.cameras),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  double degree2Radians(int deg) {
    return deg * (math.pi / 180);
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    super.key,
    required this.colour,
    required this.cardChild,
  });
  final Color colour;
  final Widget cardChild;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: cardChild,
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton(
      {super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
      shape: const CircleBorder(),
      fillColor: const Color(0xFFF3F3F4),
      child: Icon(icon),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton(
      {super.key,
      required this.onTap,
      required this.buttonTitle,
      required this.bgColor});

  final Function() onTap;
  final String buttonTitle;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: bgColor,
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: 50.0,
        child: Center(
            child: Text(
          buttonTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}
