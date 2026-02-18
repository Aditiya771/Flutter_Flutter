import 'package:flutter/material.dart';
import 'confirmpopup.dart';

enum actionList {
  fakeData(label: 'Buat Data Palsu', icon: Icons.storage),
  clearHistory(label: 'Bersihkan History', icon: Icons.delete_sweep);
  
  final String label;
  final IconData icon;
  const actionList({required this.label, required this.icon});
  }


class PopUpAction extends StatelessWidget{
  
  const PopUpAction ({super.key});

  @override
  Widget build(BuildContext context){
 
    void popUp(value){
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){
          return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Confirmpopup(type: value,));
        }
      );    
    }  

    return PopupMenuButton<actionList>(
      onSelected: (value) {
        popUp(value);
      },
      itemBuilder: (BuildContext context) {
        return actionList.values.map((actionList item) {
          return PopupMenuItem<actionList>(
            value: item,
            child: Row(children:[
              Icon(item.icon, size: 20,),
              const SizedBox(width: 10,),
              Text(item.label)]),
          );
        }).toList();
      },
    );
  }
}
