import 'package:flutter/material.dart';
import 'package:pencatat_uang/popupbutton.dart/actionpopup.dart';
import '../data/spendlog_storage.dart';

class Confirmpopup extends StatelessWidget{
  final actionList type;
  const Confirmpopup({super.key, required this.type});

  String getExplanation(actionList type){
    switch (type) {
      case actionList.fakeData:
        return 'Perintah ini akan membuat data kamu terhapus dan diganti oleh data palsu, yakin ingin melanjutkan?';
      case actionList.clearHistory:
        return 'Yakin ingin menghapus semua histori kamu?';    
    }
  }

  void getAction(actionList type){
    switch (type) {
      case actionList.fakeData:
        SpendlogStorage.generateDummyData();
      case actionList.clearHistory:
        SpendlogStorage.clearrAll();
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${type.label}?', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10,),
          Text(getExplanation(type), style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.cancel_outlined, size: 50, color: Colors.red,)),
              const SizedBox(width: 30,),
              InkWell(
                onTap: () {
                  getAction(type);
                  Navigator.pop(context);
                },
                child: Icon(Icons.check_circle_outline, size: 50, color: Colors.green,),)
          ],)
        ]
      )
    );
  }
}