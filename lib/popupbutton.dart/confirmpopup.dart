import 'package:flutter/material.dart';
import 'package:pencatat_uang/popupbutton.dart/actionpopup.dart';
import '../data/spendlog_storage.dart';

class Confirmpopup extends StatelessWidget{
  final ActionList type;
  const Confirmpopup({super.key, required this.type});

  String getExplanation(ActionList type){
    switch (type) {
      case ActionList.fakeData:
        return 'Perintah ini akan membuat data kamu terhapus dan diganti oleh data palsu, yakin ingin melanjutkan?';
      case ActionList.clearHistory:
        return 'Yakin ingin menghapus semua histori kamu?';    
    }
  }

  void getAction(ActionList type){
    switch (type) {
      case ActionList.fakeData:
        SpendlogStorage.generateDummyData();
      case ActionList.clearHistory:
        SpendlogStorage.clearAllTransaction();
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