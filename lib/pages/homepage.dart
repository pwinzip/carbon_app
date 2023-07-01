import 'package:camera/camera.dart';
import 'package:carbonapp/pages/camerapage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 200.0),
        child: Container(
          height: 150,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF91CA6B), Color(0xFF36BEBE)]),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF9E9E9E),
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                )
              ]),
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, top: 20.0, bottom: 4.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage("assets/images/plant.png")),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Carbon Application',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Text(
                      "Faculty of Science, Thaksin University",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[300]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        print("calulate height");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraPage(cameras: widget.cameras),
                            ));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF8BCFD8), Color(0xFFBADD96)]),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 90,
                                child: Image.asset(
                                  "assets/images/tree.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "คำนวณความสูงของต้นไม้",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("calculate carbon");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF8BCFD8), Color(0xFFBADD96)]),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 90,
                                child: Image.asset(
                                  "assets/images/plant-2.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "คำนวณปริมาณคาร์บอน",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("บันทึกข้อมูลปริมาณคาร์บอน")),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.grey[200],
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "พัฒนาโดย \nโครงการวิจัยการพัฒนาแอพลิเคชันบนมือถือเพื่อประเมินปริมาณการสะสมคาร์บอน\n มหาวิทยาลัยทักษิณ",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
