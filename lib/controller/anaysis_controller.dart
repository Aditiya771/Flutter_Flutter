import 'package:flutter/material.dart';
import 'package:pencatat_uang/data/repository.dart';
import 'package:fl_chart/fl_chart.dart';

enum MoveDirection {forward, backward}

class AnalysisController {
  static Map<String, dynamic> get allDataTransaction => Repository.allDataTransaction ?? {};
  bool get hasData => Repository.allDataTransaction?.isEmpty ?? false;
  List<String> get allMonth => allDataTransaction.keys.toList()..sort();
  String? selectedMonth;
  
  String? get getSelectedMonth {
    if (selectedMonth == null && allMonth.isNotEmpty) {
      selectedMonth = allMonth.last;
    }
    return selectedMonth;
  }

  Map<String, dynamic> get monthNow => getSelectedMonth != null ? allDataTransaction[getSelectedMonth] ?? {} : {};

  Map<String, int>? totalSpendByDate;
  int? totalSpendAllMonth;
  double? average;
  List<MapEntry<String,int>> highestDate = [];
  Map<String,int>? totalByCategory;

  void resetController(){
    selectedMonth = null;
    totalSpendByDate = null;
    totalSpendAllMonth = null;
    average = null;
    totalByCategory = null;
  }


  String getMonth(String? month){
    if(month == null) {return 'Kamu Belum Punya Catatan :)';}
    String numberMonth = month.split('-')[1];
    String year = month.split('-')[0];
    if(numberMonth[0] == '0'){numberMonth = numberMonth.substring(1);}
    List<String> monthNameTemp = ['WiwokDetok','Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni','Juli','Agustus','September','Oktober','November','Desember'];
    String nameMonth = monthNameTemp[int.parse(numberMonth)];
    return '${nameMonth} $year';
  }


  Map<String, int> get getTotalSpendByDate {
    final result = <String, int>{};
    monthNow.forEach((date, transactions) {
      int totalByDate = 0;
      if (transactions is List) {
        for (var item in transactions) {
          totalByDate += (item['value'] ?? 0) as int;
        }
      }
      result[date] = totalByDate;
    });
    totalSpendByDate = result;
    debugPrint('totalspendbydate $result');
    return result;
  }

  int get getTotalSpendAllMonth {
  
    int result = 0;
    getTotalSpendByDate.forEach((key, value){result += value;});
    totalSpendAllMonth = result;
    return totalSpendAllMonth!;
  }

  double get getAverage{
  
    average = getTotalSpendAllMonth / getTotalSpendByDate.length;
    return average!;
  }

  List<MapEntry<String, int>> get getHighestDate {
    if(getTotalSpendByDate.isEmpty) return highestDate;
    var highestList = getTotalSpendByDate.entries.toList();
    highestList.sort((a, b) => b.value.compareTo(a.value));
    highestDate = highestList;
    return highestDate;
  }

  Map<String,int> get getTotalByCategory {
 
    final result = <String, int>{};
    monthNow.forEach((date, transaction){
      if(transaction is List){
        for(var item in transaction){
          final String category = item['category'];
          final int value = item["value"];
          result[category] = (result[category] ?? 0) + value;
        }
      }
    });
    totalByCategory = result;
    return totalByCategory!;
  }

  List<FlSpot> get getLineChartSpots {
    final data = getTotalSpendByDate;

    final sortedEntries = data.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return List.generate(sortedEntries.length, (index) {
      final entry = sortedEntries[index];
      final day = DateTime.parse(entry.key).day.toDouble();
      return FlSpot(day,entry.value.toDouble());
    });
  }

  double get getMaxX {
    if (getSelectedMonth == null) return 0;
    final date = DateTime.parse("${getSelectedMonth!}-01");
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    return lastDay.toDouble();
  }

  double get getMaxY {
    final spots = getLineChartSpots;
    if (spots.isEmpty) return 0;
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return maxY * 1.2;
  }

//------------------------------------------------------------------------
  //PIECHART & CATEGORY
  final List<Color> categoryColor = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.amberAccent,
    const Color.fromARGB(255, 255, 112, 112),
    const Color.fromARGB(255, 233, 212, 137),
    Colors.cyanAccent,
    Colors.grey,
    Colors.pinkAccent
  ];

  List<PieChartSectionData> get getPieSections {
    final data = getTotalByCategory.entries.toList();
    data.sort((a,b) => b.value.compareTo(a.value));

    return List.generate(data.length, (index){
      final item = data[index];
      return PieChartSectionData(
        value: item.value.toDouble(),    
        title: item.key,
        titleStyle: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold),
        color: categoryColor[index],
        showTitle: false,
        radius: 40
      );
    });
  }

  double getPersentage(int value){
    double persentage = (value / getTotalSpendAllMonth) * 100;
    return persentage;
  }

  List<Map<String,dynamic>> get getLitViewSection{
    final data = getTotalByCategory.entries.toList()
      ..sort((a,b) => b.value.compareTo(a.value));
      

    return data.map((e) {
      return {
        'category' : e.key,
        'value' : e.value,
      };
    }).toList();
  }

  void moveMonth(MoveDirection direction){
    int currentIndex = allMonth.indexOf(getSelectedMonth!);
    if(direction == MoveDirection.forward){
      if(currentIndex <  allMonth.length - 1){
        selectedMonth = allMonth[currentIndex+1];
      }
    }     
    else{
      if(currentIndex > 0){
        selectedMonth = allMonth[currentIndex -1];
      }
    }
  }

}
