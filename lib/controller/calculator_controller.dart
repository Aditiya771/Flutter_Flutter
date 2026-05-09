import 'package:flutter/material.dart';
import '../popupbutton.dart/savepopupsheet.dart';

List<List<String>> callculateGrid = [
  ['C','SV','⌫','÷'],
  ['1','2','3','x'],
  ['4','5','6','-'],
  ['7','8','9','+'],
  ['//','0','000','='],
];

List<String> operatorSymbol = ['÷','x','-','+'];

List<String> specialSymbol = ['C','⌫','SV','//'];

List<String> flatList =
    callculateGrid.expand((row) => row).toList();

class CalculatorController {

  String display = '';
  String firstNum = '', secondNum = '';
  String? operator;
  bool firstVar = false;

  Color getBUttonColor(String value){
    if(operatorSymbol.contains(value)){
      return const Color.fromARGB(255, 14, 50, 111);}
    else if(specialSymbol.contains(value)){
      return const Color.fromARGB(255, 14, 50, 111);}
    else if(value == '='){
      return const Color.fromARGB(255, 14, 50, 111);}
    else{
      return const Color.fromARGB(255, 147, 205, 253);}
  }

  Color getTextColor(String value){
    if(operatorSymbol.contains(value) ||
        specialSymbol.contains(value)){
      return Colors.white;}
    else if(value == '='){
      return Colors.white;}
    else{
      return Color.fromARGB(255, 3, 30, 67);}
  }

  void showPopUpSave(
    BuildContext context,
    String displayValue,
  ){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadiusGeometry.circular(20)),
          child: SavePopUpSheet(displayValue: display)
        );
      }
    );
  }

  void clearAll(){
    display = '';
  }

  String removeZero(String result){
    double newResult = double.parse(result);

    if(newResult % 1 == 0){
      int intResult = newResult.toInt();
      return intResult.toString();}
    else{
      return newResult.toString();}
  }

  //FUNGSI TOMBOL
  void onPressedButton(
    BuildContext context,
    String value,
  ){

    if(value == '='){
      for(int i = 0; i < display.length ; i++){
        String char = display[i];

        //COLLECT FIRST VARIABEL
        if(!firstVar){
          if(operatorSymbol.contains(char)){
            if(char == '-' && firstNum.isEmpty){
              firstNum += '-';}
            else{
              operator = char;
              firstVar = true;}
          }
          else{firstNum += char;}}

        //COLLECT SECOND VARIABEL
        else{
          if(char == '-' &&
              operatorSymbol.contains(display[i - 1])){
            secondNum += char;}

          else if(operatorSymbol.contains(char)){
            if(operatorSymbol.contains(char)){
              if(operator == '+'){
                firstNum = removeZero(
                  (double.parse(firstNum) +
                  double.parse(secondNum)).toString()
                );}

              else if(operator == '-' &&
                  operatorSymbol.contains(display[i -1])){
                secondNum += "-";}

              else if(operator == '-'){
                firstNum = removeZero(
                  (double.parse(firstNum) -
                  double.parse(secondNum)).toString()
                );}

              else if(operator == '÷'){
                firstNum = removeZero(
                  (double.parse(firstNum) /
                  double.parse(secondNum)).toString()
                );}

              else if(operator == 'x'){
                firstNum = removeZero(
                  (double.parse(firstNum) *
                  double.parse(secondNum)).toString()
                );}

              secondNum = '';
            }

            operator = char;
          }

          else{
            secondNum += char;}
        }
      }//END LOOP

      display = firstNum;

      //HITUNG SISA LOOP
      if(secondNum.isNotEmpty && operator != null){
        if(operator == '+'){
          display = removeZero(
            (double.parse(firstNum) +
            double.parse(secondNum)).toString()
          );}

        else if(operator == '-'){
          display = removeZero(
            (double.parse(firstNum) -
            double.parse(secondNum)).toString()
          );}

        else if(operator == '÷'){
          display = removeZero(
            (double.parse(firstNum) /
            double.parse(secondNum)).toString()
          );}

        else if(operator == 'x'){
          display = removeZero(
            (double.parse(firstNum) *
            double.parse(secondNum)).toString()
          );}
      }
    } //END '='

    //SPESIAL TOMBOL
    else if(specialSymbol.contains(value)){
      if(value == 'C'){
        clearAll();}

      else if(value == '⌫'){
        if(display.isNotEmpty){
          display =
              display.substring(0, display.length - 1);}
      }

      else if(value == 'SV'){
        bool onlyNumber = true;

        if(display != 'Masukkan angka'){
          for(int i = 0; i < display.length; i++){
            if(operatorSymbol.contains(display[i])){
              onlyNumber = false;}
          }

          if(!onlyNumber){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Hanya menyimpan angka saja, hapus simbol operasi atau selesaikan perhitungan.'
                ),
                duration: Duration(seconds: 2),
              )
            );}

          else{
            showPopUpSave(context, display);}
        }
      }

      else if(value == '//'){
        debugPrint('Dummy Button');
      }
    }

    else{
      if(operatorSymbol.contains(value)){
        if(value == '-'){
          if(display.isEmpty){
            display += value;}

          else if(
            operatorSymbol.contains(
              display[display.length - 1]
            ) &&
            !operatorSymbol.contains(
              display[display.length - 2]
            )
          ){
            display += value;}

          else if(
            !operatorSymbol.contains(
              display[display.length - 1]
            )
          ){
            display += value;}
        }

        else{
          if(display.isNotEmpty){

            if(display[display.length - 1] == '-' &&
                operatorSymbol.contains(
                  display[display.length - 2]
                )){
              display = display;
            }

            else if(operatorSymbol.contains(
                display[display.length - 1])){

              display =
                  display.substring(
                    0,
                    display.length - 1
                  ) + value;
            }

            else{
              display += value;}
          }
        }
      }

      else{
        display += value;}
    }

    firstNum = '';
    secondNum = '';
    operator = null;
    firstVar = false;
  }
}