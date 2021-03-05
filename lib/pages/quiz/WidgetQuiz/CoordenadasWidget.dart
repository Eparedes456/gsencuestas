
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';

class CoordenadasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      init: QuizController(),
      builder: (_)=> Padding(
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Container(
          width: double.infinity,
          child: Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding:  EdgeInsets.only(top: 20,left: 10,right: 10),
                  child: Text(
                    'Ingrese las coordenadas',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      fontSize: 16
                    ),
                  ),
                ),

                SizedBox( height: 20,),

                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Expanded(
                        child: Center(child: Text('Latitud: ${_.latitud} | Longitud: ${_.longitud}'))
                      ),

                       IconButton(
                          icon: Icon(Icons.gps_not_fixed),
                          onPressed: (){
                            _.getCurrentLocation();

                          },

                        )
                      

                    ],
                  )
                
                ),

                SizedBox( height: 20,),



              ],
            ),
          )
        ),
      ),
    );
  }
}