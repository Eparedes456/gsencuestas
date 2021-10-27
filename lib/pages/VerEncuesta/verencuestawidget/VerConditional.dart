import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';
import 'package:gsencuesta/controller/RetomarController/RetomarController.dart';
import 'package:gsencuesta/controller/VerEncuesta/VerEncuestaController.dart';

class VerConditional extends StatelessWidget {
  const VerConditional({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerEncuestacontroller>(
      init: VerEncuestacontroller(),
      id: 'Vercondicional',
      builder: (_)=> Padding(
        padding:  EdgeInsets.only(left: 20,right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              height: 40,
              width: MediaQuery.of(context).size.width/2.5,
              decoration: BoxDecoration(
                color: _.conditionalRetomarsi == false ?  Colors.white : Color.fromRGBO(92, 197, 250, 1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 2),
                    )
                  ]
              ),
              child: Center(
                child: Text(
                  'SI',
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                )
              ),
            ),

            Container(
              height: 40,
              width: MediaQuery.of(context).size.width/2.5,
              
              decoration: BoxDecoration(
                color: _.conditionalRetomarno == false ?  Colors.white : Color.fromRGBO(92, 197, 250, 1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 2),
                    )
                  ]
              ),
              child: Center(
                child: Text(
                  'NO',
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                )
              ),
            )

          ],
          
        ),
      ),
    );
  }
}