import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/RetomarController/RetomarController.dart';
import 'package:gsencuesta/pages/Retomar/quizRetomar/MultiSelectWidgetRetomar.dart';
import 'package:gsencuesta/pages/Retomar/quizRetomar/SimpleSelectRetomar.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/SimpleSelectWidget.dart';


class RetomarEncuestaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return GetBuilder<RetommarController>(
      init: RetommarController(),
      builder: (_) => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(_.titulo),
          centerTitle: true,
            leading: IconButton(
              icon:  Platform.isAndroid ? Icon(Icons.arrow_back) : Icon(Icons.arrow_back_ios),
              onPressed: (){

                _.pauseQuiz();

              },
            ),
        ),

        body:  _.isLoadingData == true?  
        
        Container(
          child: Column(
            children: [

              SizedBox(height: 20,),
                Padding(
                  padding:  EdgeInsets.only(left: 20,right: 20),
                  child: Text(
                    'Total de preguntas a responder ${_.preguntas.length}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,fontWeight: FontWeight.w700
                    ),
                  ),
                ),

                SizedBox(height: 30,),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _.preguntas.length,
                    itemBuilder: (BuildContext context, index){

                      var enunciadoPregunta =   _.preguntas[index].enunciado;
                      var numPregunta = index + 1;
                      var id_pregunta = _.preguntas[index].id_pregunta;
                      var maxLength = _.preguntas[index].bind_field_length;
                      var placeholder = _.preguntas[index].bind_field_placeholder;

                      if(_.preguntas[index].tipo_pregunta == "IMPUTABLE"){

                        return Padding(
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '$numPregunta.- $enunciadoPregunta',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Poppins',
                                                fontSize: 16
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _.preguntas[index].requerido == "true"  ? " (*)": "",
                                            style: TextStyle(
                                              color: Colors.red
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox( height: 20,),

                                    Padding(
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      child: TextField(
                                        maxLength:  maxLength == null || int.parse(maxLength) == 0 ? 100 : int.parse(maxLength),
                                        controller: _.controllerInput[index].controller,
                                        decoration: InputDecoration(
                                          hintText: placeholder == "-" || placeholder == null ? 'Ingrese su respuesta' : placeholder
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


                      }else if(_.preguntas[index].tipo_pregunta == "SIMPLE"){

                        return SelectSimpleWidget(enunciadoPregunta,id_pregunta,_,context,numPregunta.toString());

                      }else if(_.preguntas[index].tipo_pregunta == "MULTIPLE"){
                        return MultiSelectWidget(enunciadoPregunta,id_pregunta,_,context,numPregunta.toString());
                      }

                    },
                  ),
                ),

                SizedBox(height: 20,),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(0, 102, 84, 1)
                  ),
                  child: MaterialButton(
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                      ),
                    ),                 
                    onPressed: (){

                      _.guardarFicha();

                    }
                  ),
                ),

                SizedBox(height: 20,),

            ],
          ),
        )
        
        : Center(
            child: CircularProgressIndicator(),
          ),
      ),
    );
  }
}

SelectSimpleWidget(String enunciado , int id_pregunta, RetommarController _ ,BuildContext context, String numPregunta){

  return Padding(
    padding: EdgeInsets.only(left: 10,right: 10),
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

            SizedBox(
              height: 20,
            ),
            Container(
            
              child: SimpleSelectRetomar(

                id_pregunta: id_pregunta,
              )
              
              
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      )
    ),
  );

}


MultiSelectWidget(String enunciado, int id_pregunta, RetommarController _ ,BuildContext context, String numPregunta){

  return Padding(
    padding: EdgeInsets.only(left: 10,right: 10),
    child: Container(
      width: double.infinity,
      child:Card(
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

            SizedBox(
              height: 20,
            ),
            Container(
            
              child: MultipleSelectRetomarPage(
                id_pregunta: id_pregunta,
              )
              
              
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      )
    ),
  );

}