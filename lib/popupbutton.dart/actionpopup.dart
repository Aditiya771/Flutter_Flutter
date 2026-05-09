import 'package:flutter/material.dart';
import 'confirmpopup.dart';

enum ActionList {
  fakeData(label: 'Buat Data Palsu', icon: Icons.storage),
  clearHistory(label: 'Bersihkan History', icon: Icons.delete_sweep);
  
  final String label;
  final IconData icon;
  const ActionList({required this.label, required this.icon});
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

    return PopupMenuButton<ActionList>(
      iconColor: Colors.white,
      onSelected: (value) {
        popUp(value);
      },
      itemBuilder: (BuildContext context) {
        return ActionList.values.map((ActionList item) {
          return PopupMenuItem<ActionList>(
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
