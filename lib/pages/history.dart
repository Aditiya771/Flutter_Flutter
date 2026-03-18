import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/spendlog_storage.dart';

final formatId = NumberFormat.decimalPattern('id_ID');

enum MoveDirection { forward, backward }
enum FromDate { past, future, nope }

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<Map<String, dynamic>>? _futureTransaction;

  Map<String, dynamic> realDataTransaction = {};

  List<String> month = [];
  List<String> date = [];

  String? selectedMonth;
  String? selectedDate;

  bool isCalenderExpand = false;
  FromDate _targetMoving = FromDate.nope;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    month = await SpendlogStorage.getAllMonth();

    selectedMonth = month.isNotEmpty ? month.last : null;

    if (selectedMonth != null) {
      _futureTransaction =
          SpendlogStorage.loadTransaction(selectedMonth);
    }

    setState(() {});
  }

  String getMonth(String month) {
    String numberMonth = month.split('-')[1];
    String year = month.split('-')[0];

    if (numberMonth[0] == '0') {
      numberMonth = numberMonth.substring(1);
    }

    List<String> monthNameTemp = [
      '',
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

  void moveMonth(MoveDirection direction, FromDate fromWhat) {
    if (selectedMonth == null) return;

    int currentIndex = month.indexOf(selectedMonth!);

    if (direction == MoveDirection.forward) {
      if (currentIndex < month.length - 1) {
        selectedMonth = month[currentIndex + 1];
        selectedDate = null;
        _targetMoving = fromWhat;

        _futureTransaction =
            SpendlogStorage.loadTransaction(selectedMonth);

      } else {
        showSnack('Ini bulan terbaru');
      }
    }
    else {
      if (currentIndex > 0) {
        selectedMonth = month[currentIndex - 1];
        selectedDate = null;
        _targetMoving = fromWhat;

        _futureTransaction =
            SpendlogStorage.loadTransaction(selectedMonth);

      } else {
        showSnack('Ini bulan terlama');
      }
    }
  }

  void moveDate(MoveDirection direction) {
    if (selectedDate == null || date.isEmpty) return;

    int currentIndex = date.indexOf(selectedDate!);

    if (direction == MoveDirection.forward) {
      if (currentIndex < date.length - 1) {
        selectedDate = date[currentIndex + 1];
      }
      else {
        moveMonth(MoveDirection.forward, FromDate.past);
      }
    }
    else {
      if (currentIndex > 0) {
        selectedDate = date[currentIndex - 1];
      }
      else {
        moveMonth(MoveDirection.backward, FromDate.future);
      }
    }
  }

  void calenderSwitchDate(String dateValue){
    selectedDate = dateValue;
  }

  String getDate(String date) => date.split('-').last;

  void showSnack(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureTransaction,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Terjadi error'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Belum ada data di bulan ini'),
          );
        }

        realDataTransaction = snapshot.data!;

        final monthData = realDataTransaction[selectedMonth];

        if (selectedDate == null) {
          if (monthData != null && monthData is Map<String, dynamic>) {
            date = monthData.keys.toList()..sort();

            if (date.isNotEmpty) {
              selectedDate = (_targetMoving == FromDate.past)
                  ? date.first
                  : date.last;
            }
          } else {
            date = [];
            selectedDate = null;
          }

          _targetMoving = FromDate.nope;
        }

        final transactionList =
            List<Map<String, dynamic>>.from(
          realDataTransaction[selectedMonth]?[selectedDate] ?? [],
        );

        return Column(
          children: [
            // HEADER BULAN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      moveMonth(MoveDirection.backward, FromDate.nope);
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  selectedMonth != null
                      ? getMonth(selectedMonth!)
                      : '-',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      moveMonth(MoveDirection.forward, FromDate.nope);
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),

            // KALENDER
            GestureDetector(
              onVerticalDragEnd: (details) {
                setState(() {
                  isCalenderExpand =
                      details.velocity.pixelsPerSecond.dy > 0;
                });
              },
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: isCalenderExpand
                    ? calenderGrid()
                    : calenderRow(),
              ),
            ),

            // LIST TRANSAKSI
            Expanded(
              child: transactionList.isEmpty
                  ? const Center(child: Text('Tidak ada transaksi'))
                  : ListView.builder(
                      itemCount: transactionList.length,
                      itemBuilder: (context, index) {
                        final item = transactionList[index];
                        return ListTile(
                          title: Text(
                              '${item['category']} - Rp ${formatId.format(item['value'])}'),
                          subtitle: Text(item['note'] ?? ''),
                          trailing: Text(item['time'] ?? ''),
                        );
                      },
                    ),
            )
          ],
        );
      },
    );
  }

  Widget calenderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              moveDate(MoveDirection.backward);
            });
          },
          icon: const Icon(Icons.chevron_left),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isCalenderExpand = true;
            });
          },
          child: Text(
            selectedDate != null
                ? 'Tanggal ${getDate(selectedDate!)}'
                : '-',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              moveDate(MoveDirection.forward);
            });
          },
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget calenderGrid() {
    return SingleChildScrollView(child:  Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color.fromARGB(255, 147, 205, 253),),
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(children: [
        
        SizedBox(height: 7),

        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1 ),
          itemCount: date.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final String value = date[index];
            return InkWell(
              onTap: (){
                setState(() {
                  calenderSwitchDate(value);
                  debugPrint(value);
                });
              },
              child: Card(
                color: Color.fromARGB(255, 3, 30, 67),
                child: Center(
                  child: Text(getDate(value), style: const TextStyle(color: Colors.white),),
                )
              ),
            );
          }
        ),

        SizedBox(
          height: 15),

      ])
    ));
  }
}