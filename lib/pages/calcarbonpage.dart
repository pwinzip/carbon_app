import 'package:carbonapp/pages/bambootab.dart';
import 'package:carbonapp/pages/foresttab.dart';
import 'package:carbonapp/pages/rubbertab.dart';
import 'package:flutter/material.dart';

class CalCarbonPage extends StatefulWidget {
  const CalCarbonPage({super.key});

  @override
  State<CalCarbonPage> createState() => _CalCarbonPageState();
}

class _CalCarbonPageState extends State<CalCarbonPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

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
            padding: EdgeInsets.only(left: 4.0, top: 20.0, bottom: 4.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
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
      body: SafeArea(
        child: Column(
          children: [
            DefaultTabController(
              length: 3,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "ไม้ยางพารา"),
                  Tab(text: "ไม้ป่าดิบชื้น"),
                  Tab(text: "ไม้ไผ่"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  RubberTab(),
                  ForestTab(),
                  BambooTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
