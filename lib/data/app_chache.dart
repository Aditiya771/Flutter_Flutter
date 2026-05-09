import 'spendlog_storage.dart';
import 'package:flutter/material.dart';

class AppCache {

  static final AppCache _instance = AppCache._internal();

  factory AppCache() => _instance;

  AppCache._internal();

  final List<String> allMonthList = [];

  final Map<String, Map<String,dynamic>>
      monthlyCache = {};

  Future<List<String>> getAllMonth() async {

    if (allMonthList.isNotEmpty) {

      debugPrint('almonth sudah ada');

      return allMonthList;
    }

    debugPrint('SQLITE LOAD MONTH LIST');

    final result =
        await SpendlogStorage.getAllMonth();

    allMonthList.addAll(result);

    return allMonthList;
  }

  Future<Map<String,dynamic>> getMonthTransaction(String month) async {

    // CACHE HIT
    if (monthlyCache.containsKey(month)) {

      debugPrint('data sudah ada di cache (AppCache)');

      return monthlyCache[month]!;
    }

    // CACHE MISS
    debugPrint('SQLITE LOAD: $month (Cache)');

    final result = await SpendlogStorage.loadTransaction(month);

    monthlyCache[month] =  Map<String,dynamic>.from(result);
    debugPrint('Ambil dari database');
    return monthlyCache[month]!;
  }

  void clearCache() {
    allMonthList.clear();

    monthlyCache.clear();
  }
}