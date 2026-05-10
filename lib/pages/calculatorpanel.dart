import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../controller/calculator_controller.dart';

class CalculatorPanel extends StatefulWidget {
  const CalculatorPanel({super.key});

  @override
  State<CalculatorPanel> createState() =>
      CalculatorPanelState();
}

class CalculatorPanelState extends State<CalculatorPanel>{

  final CalculatorController controller = CalculatorController();

  @override
  Widget build(BuildContext context){
    return Column(
      children: [

        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            alignment: Alignment.bottomRight,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 147, 205, 253),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
              )
            ),

            child: AutoSizeText(
              controller.display.isEmpty
                  ? "Masukkan angka"
                  : controller.display,

              maxLines: 1,
              textAlign: TextAlign.right,

              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          )
        ),

        const SizedBox(height: 8),

        Expanded(
          flex: 6,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: callculateGrid[0].length,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1
            ),

            itemCount: flatList.length,
            physics:
                const NeverScrollableScrollPhysics(),

            itemBuilder: (context, index) {

              final String value = flatList[index];

              return InkWell(
                onTap: (){
                  setState(() {
                    controller.onPressedButton(
                      context,
                      value,
                    );
                  });
                },

                child: Card(
                  color:
                      controller.getBUttonColor(value),

                  child: Center(
                    child: value == 'SV'
                    ? Icon(
                        Icons.save_alt,
                        size: 30,
                        color:controller.getTextColor(value)
                      )

                    : value == '//'

                    ? Icon(
                      Icons.camera_alt,
                      size: 30,
                      color:controller.getTextColor(value)
                    )

                    : Text(value, style: TextStyle(
                        fontSize: 30,
                        color: controller.getTextColor(value)
                      ))
                  ),
                )
              );
            },
          ),
        )
      ],
    );
  }
}