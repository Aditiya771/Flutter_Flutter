import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pencatat_uang/data/spendlog_storage.dart';

final List<String> category = ['Makanan', 'Hiburan','Transport','Tagihan','Pendidkan', 'Politik','Lainnya'];
final formatNumberID = NumberFormat.decimalPattern('id_ID');

class SavePopUpSheet extends StatefulWidget{

  final String displayValue;

  const SavePopUpSheet ({super.key, required this.displayValue});

  @override
  State<SavePopUpSheet> createState() => SavePopUpSheetState();
}

class SavePopUpSheetState extends State<SavePopUpSheet> {
  String selectedCategory ='';
  late final TextEditingController noteControl = TextEditingController();
  
  @override
  void dispose(){
    noteControl.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Simpan Pengeluaran?', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black),
          ),

          SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(color: Colors.grey[400],borderRadius: BorderRadius.circular(5)),
            child: Text('Rp. ${formatNumberID.format(double.tryParse(widget.displayValue) ?? 0)}',style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              )
            )
          ),

          SizedBox(height: 5),

          //NOTE FIELD
          Row(children: [
            Text('Catatan:', style: TextStyle(fontSize: 15),),
            SizedBox(width: 5,),
            Expanded(
              child: TextField(  
                controller: noteControl,              
                textAlignVertical: TextAlignVertical.center,
                maxLength: 30,
                strutStyle: const StrutStyle(
                  fontSize: 14,
                  height: 1,
                  forceStrutHeight: true,),
                style: const TextStyle(
                  fontSize: 14,
                  height: 1,),
                buildCounter: (context, {
                  required int currentLength,
                  required bool isFocused,
                  required int? maxLength,
                }) => null,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: '(Opsional)',
                  contentPadding: EdgeInsets.only(
                    left: 0, right: 0, bottom: 6, top: 6
                  )
                ),
              )
            ),

          ],),

          SizedBox(height: 10,),
        
          //PEMILIHAN KATEGORI
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              color: const Color.fromARGB(255, 236, 246, 255)),
            child: Column(children: [
              Row(children: [
                Text('Kategori:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(width: 5,),
                AutoSizeText(selectedCategory.isEmpty? '' : selectedCategory)
              ])
            ])
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top:5,left: 10,right: 10,bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top:Radius.circular(0),bottom: Radius.circular(10)),
              color: const Color.fromARGB(255, 236, 246, 255)),
            child: Wrap(
              spacing: 12,
              runSpacing: 6,
              children: category.map((cat) {
                return CategoryList(
                  cat,
                  isSelected: selectedCategory == cat,                
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                );
              }).toList(),
            )
          ),

          SizedBox(height: 10,),

          //TOMBOL TAMBAH KATEGORI
          InkWell(
            onTap: () {        
            }, 
            child: Container(
              width: 120,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.indigo[900]),
              child: Row(children: [
                Icon(Icons.add, size: 20,color: Colors.white,),
                Text('Tambah Kategori', style: TextStyle(fontSize: 10, color: Colors.white),),
              ])
            )
          ),

          SizedBox(height: 10,),

          //TOMBOL SIMPAN
          Align(
            alignment: AlignmentGeometry.centerRight,
            child:  InkWell(
              onTap: () {
                if(selectedCategory.isNotEmpty){
                  final transaction = Transaction(
                    amount: int.tryParse(widget.displayValue) ?? 0,
                    category: selectedCategory, 
                    note: noteControl.text.trim(), 
                    timeDate: DateTime.now()
                    );
                  
                  SpendlogStorage.saveTransaction(transaction);
                  Navigator.pop(context);}
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih Kategori Terlebih Dahulu.'), duration: Duration(seconds: 2),)
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(208, 123, 239, 7),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Text('Simpan', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black
                )),
              )
            )
          )

          
        ]//END OF COLLUMN UTAMA
      )
    );
  }

}



//PILIHAN KATEGORI
class CategoryList extends StatelessWidget{

  const CategoryList(this.label,{super.key,this.isSelected = false, this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context){
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ?
            const Color.fromARGB(255, 3, 30, 67) :
            const Color.fromARGB(255, 147, 205, 253),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label, style: TextStyle(fontSize: 15, color: isSelected? Colors.white : Colors.black),
        ),
      ),
    );
  }
}