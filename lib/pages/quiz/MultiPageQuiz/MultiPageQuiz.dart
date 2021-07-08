import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/MultiQuiz/MultiQuizController.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/UbigeoWidget.dart';

class MultiPageQuiz extends StatelessWidget {
  const MultiPageQuiz({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MultiQuizController>(
      init: MultiQuizController(),
      builder:(_) => WillPopScope(
        onWillPop: (){},
        child: Scaffold(
          appBar: AppBar(
            title: Text('Titulo de la encuesta'),
            centerTitle: true,
            leading: IconButton(
              icon:  Platform.isAndroid ? Icon(Icons.arrow_back) : Icon(Icons.arrow_back_ios),
              onPressed: (){
                //_.pauseQuiz();
                Get.back();
              },
            ),
          ),
          body: Container(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Padding(
                  padding:  EdgeInsets.only(left: 20,right: 20),
                  child: Text(
                    'Total de preguntas a responder 124',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index){
                      _.onPageChanged(index);
                    },
                    controller: _.pageController,
                    itemCount: _.preguntas.length,
                    itemBuilder: (context, index){
                      var enunciadoPregunta =   _.preguntas[index].enunciado;
                          var numPregunta = index + 1;
                          var id_pregunta = _.preguntas[index].id_pregunta;
                          var placeholder = _.preguntas[index].bind_field_placeholder;
                          var maxLength = _.preguntas[index].bind_field_length;
                          var typeData = _.preguntas[index].bind_type;
                          var bloqueDefinitivo = _.preguntas[index].bloqueDescripcion;
                          var bloque;
                          if(_.bloque == null || _.bloque == ""){
                            _.bloque = bloqueDefinitivo;
                          }else if(_.bloque == bloqueDefinitivo){
                            //_.bloque = "";
                            bloque = bloqueDefinitivo; 
                          }else if(_.bloque != bloqueDefinitivo){
                            _.bloque = bloqueDefinitivo;
                          }

                          if(_.preguntas[index].tipo_pregunta =="ubigeo"){
                            return UbigeoWidget(
                              id_pregunta : id_pregunta,
                              enunciado   : enunciadoPregunta,
                              numPregunta : numPregunta.toString(),
                              apariencia  : _.preguntas[index].apariencia,
                              bloque: bloqueDefinitivo,
                            );
                          }else{
                            return Padding(
                              padding:  EdgeInsets.only(left: 10,right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                    child: Text('bloque',style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1),fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10,right: 10),
                                    child: Container(
                                      width: double.infinity,
                                      child: Card(
                                        elevation: 5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 20,left: 10,right: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '1.- enunciadoPregunta',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 16
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    " (*)",
                                                    style: TextStyle(
                                                      color: Colors.red
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                          }
                      

                    },
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 20,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          print('back');
                          _.backPregunta();
                        },
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(0, 102, 84, 1),
                          child: Center(
                            child: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      ),
                      
                      GestureDetector(
                        onTap: (){
                          print('next');
                          _.nextPregunta();
                        },
                        child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(0, 102, 84, 1),
                          child: Center(
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,)
              ],
            ),
          )
        ),
      ),
    );
  }
}