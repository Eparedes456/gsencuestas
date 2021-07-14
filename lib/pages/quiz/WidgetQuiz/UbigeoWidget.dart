import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';
import 'package:gsencuesta/controller/RetomarController/RetomarController.dart';
import 'package:gsencuesta/controller/VerEncuesta/VerEncuestaController.dart';

class UbigeoWidget extends StatelessWidget {
  final int id_pregunta;
  final String enunciado;
  final String numPregunta;
  final String apariencia;
  final String bloque;
  final String bloque2;
  final int    i;
  final String pagina;
  const UbigeoWidget({ Key  key, this.id_pregunta, this.enunciado, this.numPregunta, this.apariencia, this.bloque, this.bloque2, this.i, this.pagina }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return pagina == "retomar" ?  
    
    GetBuilder<RetommarController>(
      init: RetommarController(),
      id: 'ubigeo',
      builder:(_)=> Padding(
        padding:  EdgeInsets.only(left: 10,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
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
                      SizedBox(height: 15,),

                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          readOnly: true,
                          onTap: (){
                            _.showModalUbigeo(id_pregunta.toString(),apariencia,i);
                          },
                          controller: _.controllerInput[i].controller,
                          decoration: InputDecoration(hintText: 'Presione aqui'),
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
    )
    
    
    : pagina == "quiz"?
    
    GetBuilder<QuizController>(
      init: QuizController(),
      id: 'ubigeo',
      builder:(_)=> Padding(
        padding:  EdgeInsets.only(left: 10,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
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
                      SizedBox(height: 15,),

                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          readOnly: true,
                          onTap: (){
                            _.showModalUbigeo(id_pregunta.toString(),apariencia,i);
                          },
                          controller: _.controllerInput[i].controller,
                          decoration: InputDecoration(hintText: 'Presione aqui'),
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
    ) 
    
    :

    GetBuilder<VerEncuestacontroller>(
      init: VerEncuestacontroller(),
      id: 'ubigeo',
      builder:(_)=> Padding(
        padding:  EdgeInsets.only(left: 10,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
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
                      SizedBox(height: 15,),

                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          readOnly: true,
                          onTap: (){
                            //_.showModalUbigeo(id_pregunta.toString(),apariencia,i);
                          },
                          controller: _.controllerInput[i].controller,
                          decoration: InputDecoration(hintText: 'Presione aqui'),
                        ),
                      ),

                        /*Padding(
                          padding:  EdgeInsets.only(left: 20,right: 20),
                          child:  _.ubigeoCapturado == "" ? Text('Presione aqui') : Text(_.ubigeoCapturado),
                        ),*/
                      
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