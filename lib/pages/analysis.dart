import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'anaysis_controller.dart';


final formatNumberID = NumberFormat.decimalPattern("id_ID");
class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => AnalysisPageState();
}

class AnalysisPageState extends State<AnalysisPage> {
  final controller = AnalysisController();

  @override
  Widget build(BuildContext context){
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color.fromARGB(255, 213, 236, 247),
      child: controller.hasData ?
        hasDataFalse():hasDataTrue());
  }
      
  Widget hasDataTrue(){
    return Column(children: [

        //HEADE HALAMAN
        Text('Ringkasan Analisis Pengeluaran Bulan', style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 3, 30, 67), fontWeight: FontWeight.bold)),
          
    
        //ELEMEN PERTAMA
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        controller.moveMonth(MoveDirection.backward);
                      });
                    },
                    icon: Icon(Icons.keyboard_arrow_left_outlined),
                    iconSize: 20,),
                  Text(controller.getMonth(controller.getSelectedMonth!), style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        controller.moveMonth(MoveDirection.forward);
                      });
                    },
                    icon: Icon(Icons.keyboard_arrow_right_outlined),
                    iconSize: 20),
                ],),

              

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    padding: EdgeInsets.all(5),
                    height: 75,
                    width: 105,
                    decoration: BoxDecoration(color: const Color.fromARGB(255, 147, 205, 253), borderRadius:BorderRadius.circular(10) ),
                    child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [  
                              Icon(Icons.account_balance_wallet_sharp, size: 30,color: Color.fromARGB(255, 3, 30, 67),), 
                              Text('Semua\nPengeluaran',style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 3, 30, 67), fontWeight: FontWeight.bold))]),
                          SizedBox(height: 4,),
                          Text('Total:', style: const TextStyle(fontSize: 10,color: Color.fromARGB(255, 3, 30, 67)),),
                          Text('Rp. ${formatNumberID.format(controller.getTotalSpendAllMonth)}',style: const TextStyle(fontSize: 12,color: Color.fromARGB(255, 3, 30, 67),fontWeight: FontWeight.bold),)
                      ])
                  ),

                  Container(
                    padding: EdgeInsets.all(5),
                    height: 75,
                    width: 105,
                    decoration: BoxDecoration(color: const Color.fromARGB(255, 147, 205, 253), borderRadius:BorderRadius.circular(10)),
                    child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Icon(Icons.show_chart_outlined, size: 30,color: Color.fromARGB(255, 3, 30, 67)), 
                            Text('Rata-rata\nPengeluaran',style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold))]),
                          SizedBox(height: 4),
                          Text('Perhari:',style: const TextStyle(fontSize: 10,color: Color.fromARGB(255, 3, 30, 67)),),
                          Text('Rp. ${formatNumberID.format(controller.getAverage)}',style: const TextStyle(fontSize: 12,color: Color.fromARGB(255, 3, 30, 67),fontWeight: FontWeight.bold),)
                      ],)
                  ),

                  Container(
                    padding: EdgeInsets.all(5),
                    height: 75,
                    width: 105,
                    decoration: BoxDecoration(color: const Color.fromARGB(255, 147, 205, 253), borderRadius:BorderRadius.circular(10)),
                    child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.local_grocery_store_outlined, size: 30,color: Color.fromARGB(255, 3, 30, 67)), 
                              Text('Hari Paling\nBoros/Hemat',style: const TextStyle(fontSize: 10,color: Color.fromARGB(255, 3, 30, 67),fontWeight: FontWeight.bold))
                            ]),
                          SizedBox(height: 4,),
                          Text('Tanggal:', style: const TextStyle(fontSize: 10,color: Color.fromARGB(255, 3, 30, 67)),),
                          Text('19/02', style: const TextStyle(fontSize: 12,color: Color.fromARGB(255, 3, 30, 67),fontWeight: FontWeight.bold),)]
                      )
                  ),
                ]
              ),
              SizedBox(height: 5,)
            ]
          )
        ),


        //ELEMEN KEDUA
        Container(
          margin: EdgeInsets.all(7),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          height: 225,
          decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
          child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text('Proyeksi Pengeluaran Bulan Ini', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                SizedBox(height: 13,),
                SizedBox(
                  height: 150,
                  width: 300,
                  child: Row(children: [
                    Expanded(child:
                    LineChart( //CHART PROYEKSI
                      LineChartData(
                        minX: 0,
                        maxX: controller.getMaxX,
                        minY: 0,
                        maxY: controller.getMaxY,
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            left: BorderSide(color: Color.fromARGB(255, 3, 30, 67)),
                            bottom: BorderSide(color: Color.fromARGB(255, 3, 30, 67))
                          )),
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles:AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles( sideTitles: SideTitles(
                            showTitles : true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() % 5 != 0) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          )),
                          leftTitles: AxisTitles(sideTitles: SideTitles(
                            reservedSize: 40,
                            showTitles: true,
                            getTitlesWidget: (value, meta){
                              if (value < 0) {return const SizedBox.shrink();}
                              if (value % 10 != 0) {return const SizedBox.shrink();}
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Padding(padding: EdgeInsetsGeometry.only(right: 2), child: 
                                  Text(
                                  '${(value/1000).toInt()}K',
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 8),
                                  )
                                )
                              );
                            }
                          )
                          )),
                        lineBarsData: [
                          LineChartBarData(
                            spots: controller.getLineChartSpots,
                            isCurved: true, 
                            barWidth: 1.5,
                            dotData: FlDotData(show: false,)
                          ),
                        ],
                      ),
                    )),
                    SizedBox(width: 20,),
                  ])
                ),
              ]
            )
        ),
      
      


        //ELEMEN KETIGA
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container( //KOTAK KIRI BAWAH
              padding: EdgeInsets.symmetric(vertical: 7),
              height: 200,
              width: 165,
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Persentase\nKategori', textAlign: TextAlign.center, style: const TextStyle(color: Color.fromARGB(255, 3, 30, 67), fontSize: 15, fontWeight: FontWeight.bold, height: 1)),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 100,
                    child: PieChart(
                      PieChartData(
                        sections: controller.getPieSections,
                        sectionsSpace: 3,
                        centerSpaceRadius: 15                
                      )
                    ),
                  )
                ]),
            ),

            Container( //KOTAK KANAN BAWAH
              padding: EdgeInsets.symmetric(vertical: 7),
              height: 200,
              width: 165,
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Rincian Kategori', style: TextStyle(color: const Color.fromARGB(255, 3, 30, 67), fontSize: 15, fontWeight: FontWeight.bold,height: 1),),
                  SizedBox(height: 10,),
                  Expanded(child:
                    ListView.builder(
                      itemCount: controller.getLitViewSection.length,
                      itemBuilder: (context, index){
                        final item = controller.getLitViewSection[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Center(child: Padding(padding: const EdgeInsetsGeometry.only(left: 5),
                            child: SizedBox(
                              height: 30, 
                              width: 190, 
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 27,
                                    height: 27,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: controller.categoryColor[index],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${controller.getPersentage(item['value']).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 3, 30, 67)
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 3),

                                  Container(
                                    height: 27,
                                    width: 128,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 147, 205, 253),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${item['category']}:Rp.${formatNumberID.format(item['value'].toInt())}',
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                        );
                      }
                    )
                  )
                ],
              ),
            )
        ],)
      ]
    ); 
  }

  Widget hasDataFalse(){
    return Center(
      child: Text('Datanya Masih Kosong :)', style: TextStyle(fontSize: 18),)
    );
  }

}

