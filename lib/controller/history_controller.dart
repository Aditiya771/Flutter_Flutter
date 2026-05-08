import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/spendlog_storage.dart';

final formatId = NumberFormat.decimalPattern('id_ID');

enum MoveDirection { forward, backward }
enum FromDate { past, future, nope }

class HistoryController {
  Future<Map<String, dynamic>>? futureTransaction;

  Map<String, dynamic> realDataTransaction = {};

  List<String> month = [];
  List<String> date = [];

  String? selectedMonth;
  String? selectedDate;

  bool isCalenderExpand = false;
  FromDate targetMoving = FromDate.nope;

  Future<void> initData(VoidCallback refresh) async {
    month = await SpendlogStorage.getAllMonth();

    selectedMonth = month.isNotEmpty ? month.last : null;

    if (selectedMonth != null) {
      futureTransaction =
          SpendlogStorage.loadTransaction(selectedMonth);
    }

    refresh();
  }

  String getMonth(String month) {
    String numberMonth = month.split('-')[1];
    String year = month.split('-')[0];

    if (numberMonth[0] == '0') {
      numberMonth = numberMonth.substring(1);
    }

    List<String> monthNameTemp = [
      'wiwokdetok, not onle tok de tok',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    return '${monthNameTemp[int.parse(numberMonth)]} $year';
  }

  void moveMonth(MoveDirection direction, FromDate fromWhat, BuildContext context) {
    if (selectedMonth == null) return;

    int currentIndex = month.indexOf(selectedMonth!);

    if (direction == MoveDirection.forward) {
      if (currentIndex < month.length - 1) {
        selectedMonth = month[currentIndex + 1];
        selectedDate = null;
        targetMoving = fromWhat;

        futureTransaction =
            SpendlogStorage.loadTransaction(selectedMonth);

      } else {
        showSnack(context, 'Ini bulan terbaru');
      }
    }
    else {
      if (currentIndex > 0) {
        selectedMonth = month[currentIndex - 1];
        selectedDate = null;
        targetMoving = fromWhat;

        futureTransaction =
            SpendlogStorage.loadTransaction(selectedMonth);

      } else {
        showSnack(context, 'Ini bulan terlama');
      }
    }
  }

  void moveDate(
    MoveDirection direction,
    BuildContext context,
  ) {
    if (selectedDate == null || date.isEmpty) return;

    int currentIndex = date.indexOf(selectedDate!);

    if (direction == MoveDirection.forward) {
      if (currentIndex < date.length - 1) {
        selectedDate = date[currentIndex + 1];
      }
      else {
        moveMonth(MoveDirection.forward, FromDate.past, context);
      }
    }
    else {
      if (currentIndex > 0) {
        selectedDate = date[currentIndex - 1];
      }
      else {
        moveMonth(MoveDirection.backward, FromDate.future, context);
      }
    }
  }

  void calenderSwitchDate(String dateValue){
    selectedDate = dateValue;
  }

  String getDate(String date) => date.split('-').last;

  void showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text)),
      );
  }
}