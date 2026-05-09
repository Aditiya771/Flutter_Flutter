import 'package:flutter/material.dart';
import '../controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  final HistoryController controller = HistoryController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await controller.initData();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: controller.futureTransaction,
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

        controller.realDataTransaction = snapshot.data!;

        final monthData =
            controller.realDataTransaction[controller.selectedMonth];

        if (controller.selectedDate == null) {
          if (monthData != null && monthData is Map<String, dynamic>) {
            controller.date = monthData.keys.toList()..sort();

            if (controller.date.isNotEmpty) {
              controller.selectedDate =
                  (controller.targetMoving == FromDate.past)
                  ? controller.date.first
                  : controller.date.last;
            }
          } else {
            controller.date = [];
            controller.selectedDate = null;
          }

          controller.targetMoving = FromDate.nope;
        }

        final transactionList =
            List<Map<String, dynamic>>.from(
          controller.realDataTransaction[
              controller.selectedMonth]?[controller.selectedDate] ?? [],
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
                      controller.moveMonth(
                        MoveDirection.backward,
                        FromDate.nope,
                        context,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  controller.selectedMonth != null
                      ? controller.getMonth(controller.selectedMonth!)
                      : '-',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      controller.moveMonth(
                        MoveDirection.forward,
                        FromDate.nope,
                        context,
                      );
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
                  controller.isCalenderExpand =
                      details.velocity.pixelsPerSecond.dy > 0;
                });
              },
              child: AnimatedSize(
                duration: const Duration(milliseconds: 100),
                child: controller.isCalenderExpand
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
              controller.moveDate(
                MoveDirection.backward,
                context,
              );
            });
          },
          icon: const Icon(Icons.chevron_left),
        ),
        InkWell(
          onTap: () {
            setState(() {
              controller.isCalenderExpand = true;
            });
          },
          child: Text(
            controller.selectedDate != null
                ? 'Tanggal ${controller.getDate(controller.selectedDate!)}'
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
              controller.moveDate(
                MoveDirection.forward,
                context,
              );
            });
          },
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget calenderGrid() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 147, 205, 253),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [

            SizedBox(height: 7),

            GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: controller.date.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final String value = controller.date[index];

                return InkWell(
                  onTap: (){
                    setState(() {
                      controller.calenderSwitchDate(value);
                      debugPrint(value);
                    });
                  },
                  child: Card(
                    color: Color.fromARGB(255, 3, 30, 67),
                    child: Center(
                      child: Text(
                        controller.getDate(value),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ),
                );
              }
            ),

            SizedBox(height: 15),

          ]
        )
      )
    );
  }
}