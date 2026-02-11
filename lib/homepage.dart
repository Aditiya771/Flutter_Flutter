import 'package:flutter/material.dart';
import 'package:pencatat_uang/pages/calculatorpanel.dart';
import 'pages/analysis.dart';
import 'pages/history.dart';
import 'package:pencatat_uang/actionbutton_folder/actionpopup.dart';
import 'package:pencatat_uang/data/repository.dart';

final List<Tab> myTab = [
  Tab(icon: Icon(Icons.calculate), text: "Kalkulator"),
  Tab(icon: Icon(Icons.calendar_month), text: "Catatan",),
  Tab(icon: Icon(Icons.insert_chart_outlined_outlined), text: "Analisis",)
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final repository = Repository();
  static final allData = Repository.loadFromZero();
  static final history = HistoryPage();

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      initialIndex: 0,
      length: myTab.length, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("SpendLog",
            style: TextStyle(fontSize: 25, color: Colors.white)),
          actions: [PopUpAction()]   
        ),

        body: TabBarView(
          children: [
            SafeArea(child:  const CalculatorPanel()),
            SafeArea(child:  const HistoryPage()),
            SafeArea(child:  const AnalysisPage())
          ]
        ),
        
        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child:Material(
            color: Colors.blue,
            child: TabBar(
              tabs: myTab,
              indicator: BoxDecoration(
                color: const Color.fromRGBO(244, 249, 253, 1),
                borderRadius: BorderRadius.circular(50)),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              labelColor: const Color.fromARGB(255, 1, 61, 110),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.white,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
        )
      )
    );
  }
}


