import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pencatat_uang/data/repository.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisController {
  static Map<String, dynamic> get allDataTransaction => Repository.allDataTransaction ?? {};

  List<String> get allMonth => allDataTransaction.keys.toList()..sort();

  String? get selectedMonth => allMonth.isNotEmpty ? allMonth.first : null;

  Map<String, dynamic> get monthNow => selectedMonth != null ? allDataTransaction[selectedMonth] ?? {} : {};

  Map<String, int>? totalSpendByDate;
  int? totalSpendAllMonth;
  double? average;
  List<MapEntry<String,int>> highestDate = [];
  Map<String,int>? totalByCategory;

  final List<Color> categoryColor = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.amberAccent,
    Colors.grey
  ];


  Map<String, int> get getTotalSpendByDate {
    if (totalSpendByDate != null) return totalSpendByDate!;
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
    if(totalSpendAllMonth != null) return totalSpendAllMonth!;
    int result = 0;
    getTotalSpendByDate.forEach((key, value){result += value;});
    totalSpendAllMonth = result;
    debugPrint('gettotalspendallmo $result');
    return totalSpendAllMonth!;
  }

  double get getAverage{
    if(average != null)return average!;
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
    if(totalByCategory != null) return totalByCategory!;
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

  List<PieChartSectionData> get getPieSections {
    final data = getTotalByCategory.entries.toList();
    data.sort((a,b) => b.value.compareTo(a.value));

    return List.generate(data.length, (index){
      final item = data[index];
      return PieChartSectionData(
        value: item.value.toDouble(),
        title: item.key,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        color: categoryColor[index],
      );
    });
  }

  double get getMaxX {
    if (selectedMonth == null) return 0;

    final date = DateTime.parse("${selectedMonth!}-01");
    final lastDay = DateTime(date.year, date.month + 1, 0).day;

    return lastDay.toDouble();
  }

  double get getMaxY {
    final spots = getLineChartSpots;
    if (spots.isEmpty) return 0;

    final maxY = spots
        .map((e) => e.y)
        .reduce((a, b) => a > b ? a : b);

    return maxY * 1.2;
  }

}
