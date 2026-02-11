import 'package:flutter/material.dart';
import 'package:pencatat_uang/data/repository.dart';
import 'package:intl/intl.dart';

final formatId = NumberFormat.decimalPattern('id_ID');
enum MoveDirection {forward, backward}
enum FromDate {past, future, nope}


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}


class _HistoryPageState extends State<HistoryPage>{

  late Future<Map<String, dynamic>> _futureTransaction;
  Map<String,dynamic> realDataTransaction = {};
  bool isCalenderExpand = false;


  List<String> month = [];
  List<String> date = [];

  String? selectedDate;
  String? selectedMonth;

  String getMonth(String month){
    String numberMonth = month.split('-')[1];
    String year = month.split('-')[0];
    if(numberMonth[0] == '0'){numberMonth = numberMonth.substring(1);}
    List<String> monthNameTemp = ['hehehe :)','Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni','Juli','Agustus','September','Oktober','November','Desember'];
    String nameMonth = monthNameTemp[int.parse(numberMonth)];
    return '${nameMonth} $year';
  }

  void calenderSwitchDate(String dateValue){
    selectedDate = dateValue;
  }

  void moveMonth(MoveDirection direction, FromDate fromWhat){
    int currentIdex = month.indexOf(selectedMonth!);
    if(direction == MoveDirection.forward){
      if(currentIdex <  month.length - 1){
        selectedMonth = month[currentIdex+1];
        date = (realDataTransaction[selectedMonth!] as Map<String,dynamic>).keys.toList();
        if(fromWhat == FromDate.past){
          selectedDate = date[0];}
        else{selectedDate = date.last;}
      }
      else{
        ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
          const SnackBar(content:
          Text('Ini Adalah Bulan Terlama.'),
          duration: Duration(seconds: 2),)
        );
      }
    }
    else{
      if(currentIdex > 0){
        selectedMonth = month[currentIdex-1];
        date = (realDataTransaction[selectedMonth!] as Map<String,dynamic>).keys.toList();       
        selectedDate = date.last;}
      else{
        ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
          const SnackBar(content:
          Text('Ini Adalah Bulan Terlama.'),
          duration: Duration(seconds: 2),));
      }
    }
  }

  void moveDate(MoveDirection direction){
    int currentIndex = date.indexOf(selectedDate!);

    if(direction == MoveDirection.forward){
      if(currentIndex < date.length - 1){
        selectedDate = date[currentIndex + 1];}
      else{
        moveMonth(MoveDirection.forward, FromDate.past);}
    }

    else{
      if(currentIndex > 0){
        selectedDate = date[currentIndex - 1];}
      else{
        moveMonth(MoveDirection.backward, FromDate.future);}
    }
  }
  
  

  String getDate(String date){
    return date.split('-').last;
  }

  @override
  void initState(){
    super.initState();
    _futureTransaction = Repository.memoryData();
  }


  Widget build(BuildContext context){
    return FutureBuilder<Map<String,dynamic>>(
      future: _futureTransaction, 
      builder: (context, process){
        if(process.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }

        if(!process.hasData || process.data!.isEmpty){
          return Center(child: const Text('Kamu belum punya data, belanja dulu!', style: TextStyle(fontSize: 18),));
        }

        if(process.hasError){
          return Center(
           child: Text('Terjadi kesalahan dalam pemprosesan data, silahkan mulai ulang :)'));
        }

        final dataTransaction = process.data!;

        if(realDataTransaction.isEmpty){
          realDataTransaction = dataTransaction;
        }
        
        if(selectedMonth == null){
          month = realDataTransaction.keys.toList();
          selectedMonth = month.last;
        }

        if(selectedDate == null){
          date = (realDataTransaction[selectedMonth!] as Map<String,dynamic>).keys.toList();
          selectedDate = date.last;
        }

        final transactionList =
          List<Map<String, dynamic>>.from(
            realDataTransaction[selectedMonth]?[selectedDate] ?? [],
          );
        

        //LAYOUT UI
        return Column(
          children: [

          //HEADER BULAN
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed:() {
                    setState(() {
                      moveMonth(MoveDirection.backward, FromDate.nope);
                    });
                  }, 
                  icon: const Icon(Icons.chevron_left)),

                InkWell(
                  onTap: (){debugPrint('pindah bulan');},
                  child: Text('${getMonth(selectedMonth!)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            

                IconButton(
                  onPressed: (){
                    setState(() {
                      moveMonth(MoveDirection.forward, FromDate.nope);
                    });
                  }, 
                  icon: const Icon(Icons.chevron_right)),
              ],),


            //HEADER TANGGAL/KALENDER
            GestureDetector(
              onVerticalDragEnd: (details) {
                final velocity = details.velocity.pixelsPerSecond.dy;

                if(velocity < -100){
                  setState(() {
                    isCalenderExpand = false;
                  });
                } else{setState(() {
                  isCalenderExpand = true;
                });}
              },
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.bounceOut,
                child: isCalenderExpand ? calenderGrid() : calenderRow(),)
            ),  


            //DAFTAR TRANSAKSI
            Expanded(child:
              ListView.builder(
                itemCount: transactionList.length,
                itemBuilder: (context, index){
                  final value = transactionList[index];
                  return ListTile(
                      title: Text('${value['category']}: Rp. ${formatId.format(value['value'])}', style: const TextStyle(fontSize: 15),),
                      subtitle: Text('Keterangan: ${value['note']}',style: const TextStyle(fontSize: 13),),
                      trailing: Text(value['time'],style: const TextStyle(fontSize: 13),),
                  );
                },
              ),
            )
          ]
        );
      }
    );
  }

  Widget calenderRow(){//
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      IconButton(
        onPressed: () {
          setState(() {
            moveDate(MoveDirection.backward);
          });
        }, 
        icon: const Icon(Icons.chevron_left)),

      InkWell(
        onTap: (){setState(() {
          isCalenderExpand = !isCalenderExpand;
        });},
        child: Text('Tanggal ${getDate(selectedDate!)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
  

      IconButton(
        onPressed: (){
          setState(() {
            moveDate(MoveDirection.forward);
          });
        }, 
        icon: const Icon(Icons.chevron_right)),],
      
    );
  }

  Widget calenderGrid(){
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

