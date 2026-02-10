import 'package:flutter/material.dart';
import 'package:pencatat_uang/data/spendlog_storage.dart';

enum ActionValue {Settings, CreateDummyData, CelearAll}

List<String> actionList = ['Settings', 'Buat Data Palsu', 'Bersihkan History'];

class PopUpAction extends StatelessWidget{
  
  const PopUpAction ({super.key});

  @override
  Widget build(BuildContext context){
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return actionList.map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      },
    );
  }
}
