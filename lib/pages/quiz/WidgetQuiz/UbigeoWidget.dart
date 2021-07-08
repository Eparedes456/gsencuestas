import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';

class UbigeoWidget extends StatelessWidget {
  final int id_pregunta;
  final String enunciado;
  final String numPregunta;
  final String apariencia;
  final String bloque;
  const UbigeoWidget({ Key  key, this.id_pregunta, this.enunciado, this.numPregunta, this.apariencia, this.bloque }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      init: QuizController(),
      id: 'ubigeo',
      builder:(_)=> Padding(
        padding:  EdgeInsets.only(left: 10,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _.bloque == bloque? Container(): Padding(
              padding:  EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
              child: Text('${_.bloque}',style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1),fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0,right: 0),
              child: Container(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: 20,left: 20,right: 20),
                        child: Text(
                          '$numPregunta.- $enunciado',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            fontSize: 16
                          ),
                        ),
                      ),
                      SizedBox(height: 8,),
                      GestureDetector(
                        onTap: (){
                          _.showModalUbigeo(id_pregunta.toString(),apariencia);
                        },
                        child: Padding(
                          padding:  EdgeInsets.only(left: 20,right: 20),
                          child:  _.ubigeoCapturado == "" ? Text('Presione aqui') : Text(_.ubigeoCapturado),
                        ),
                      ),
                      SizedBox(height: 12,)
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}