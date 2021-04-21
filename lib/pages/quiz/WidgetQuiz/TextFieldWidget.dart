
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';

class TextFieldPage extends StatelessWidget {
  
  final int id_pregunta;
  final String numPregunta;
  final String enunciado;

  TextFieldPage({Key key, @required this.id_pregunta,this.numPregunta,this.enunciado}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    
    return GetBuilder<QuizController>(
      init: QuizController(),
      id: "textfield",
      builder: (_) {

        for (var i = 0; i < _.controllerInput.length; i++) {
        
          return  Padding(
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
                        '$numPregunta.- $enunciado',
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
                      child: TextField(
                        
                        controller: _.controllerInput[i].controller,
                        onChanged: (value){
                          
                        },
                        decoration: InputDecoration(
                          hintText: 'Ingrese su respuesta'
                        ),
                        onSubmitted: (valor){

                        },
                      ),
                    
                    ),

                    SizedBox( height: 20,),



                  ],
                ),
              )
            ),
          );
        }


      } 
      
      
      
      
    );
    }
  }
