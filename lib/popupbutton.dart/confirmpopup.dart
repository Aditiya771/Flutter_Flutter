import 'package:flutter/material.dart';
import 'package:pencatat_uang/popupbutton.dart/actionpopup.dart';
import '../data/spendlog_storage.dart';

class Confirmpopup extends StatelessWidget{

  final ActionList? type;
  final String? customTitle;
  final String? customExplanation;
  final VoidCallback? customAction;

  const Confirmpopup({
    super.key,
    this.type,
    this.customTitle,
    this.customExplanation,
    this.customAction,
  });

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

    final String title =
        customTitle ?? type!.label;

    final String explanation =
        customExplanation ??
        getExplanation(type!);

    return Container(
      padding: EdgeInsets.all(15),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            '$title?',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          ),

          SizedBox(height: 10),

          Text(
            explanation,
            style: const TextStyle(fontSize: 16)
          ),

          const SizedBox(height: 50),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

            children: [

              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },

                child: Icon(
                  Icons.cancel_outlined,
                  size: 50,
                  color: Colors.red,
                ),
              ),

              const SizedBox(width: 30),

              InkWell(
                onTap: () {

                  if(customAction != null){
                    customAction!();
                  }
                  else{
                    getAction(type!);
                  }

                  Navigator.pop(context);
                },

                child: Icon(
                  Icons.check_circle_outline,
                  size: 50,
                  color: Colors.green,
                ),
              )
            ],
          )
        ]
      )
    );
  }
}