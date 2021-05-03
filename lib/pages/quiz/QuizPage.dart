import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/CoordenadasWidget.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/ImageWidget.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/MultipleSelectWidget.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/SimpleSelectWidget.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/TextFieldWidget.dart';
import 'dart:io' show Platform;



class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //List<InputTextfield> _controllerInput = [];

    return GetBuilder<QuizController>(
      init: QuizController(),
      builder: (_)=> WillPopScope(
        onWillPop: (){

          _.pauseQuiz();

        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(_.tituloEncuesta),
            centerTitle: true,
            leading: IconButton(
              icon:  Platform.isAndroid ? Icon(Icons.arrow_back) : Icon(Icons.arrow_back_ios),
              onPressed: (){

                _.pauseQuiz();

              },
            ),
          ),

          body:  _.isLoadingData == true?  Container(
            child: Column(
                children: [

                  SizedBox(height: 40,),
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

                  /*Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          for (var i = 0; i < _.preguntas.length; i++)...{

                            //var enunciadoPregunta =   _.preguntas[index].enunciado;
                            //var numPregunta = index + 1;
                            //var id_pregunta = _.preguntas[index].id_pregunta;

                            if( _.preguntas[i].tipo_pregunta == "IMPUTABLE" )...{

                                _.controllerInput.add(
                                  InputTextfield( item["idPregunta"].toString(), TextEditingController() )
                                ),

                              /*TextFieldPage(id_pregunta: _.preguntas[i].id_pregunta,numPregunta: (i+1).toString(),enunciado: _.preguntas[i].enunciado,)*/

                                

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
                                              padding:  EdgeInsets.only(top: 20,left: 10,right: 10),
                                              child: Text(
                                                '${(i+1).toString()}.- ${_.preguntas[i].enunciado}',
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
                                                
                                                //controller: _.controllerInput[x].controller,
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
                                  )
                                  
                              

                              







                            }else if( _.preguntas[i].tipo_pregunta == "SIMPLE" )...{

                              SelectSimpleWidget(_.preguntas[i].enunciado,_.preguntas[i].id_pregunta,_,context,(i+1).toString()),

                            }



                          }
                            
                          

                        ],
                      ),
                    )
                  ),*/
                  
                  Expanded(
                    //height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        shrinkWrap: true,
                        //physics: ScrollPhysics(),
                        itemCount: _.preguntas.length,
                        itemBuilder: (BuildContext context, index){

                          var enunciadoPregunta =   _.preguntas[index].enunciado;
                          var numPregunta = index + 1;
                          var id_pregunta = _.preguntas[index].id_pregunta;
                          _.controllerInput.add(
                                InputTextfield( id_pregunta.toString(), TextEditingController() )
                          );

                          //print(index); 

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
                                        child: Text(
                                          '$numPregunta.- $enunciadoPregunta',
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
                                          
                                          controller: _.controllerInput[index].controller,
                                          decoration: InputDecoration(
                                            hintText: 'Ingrese su respuesta'
                                          ),
                                          /*onSubmitted: (valor){
                                            
                                            _.guardarInput (_.preguntas[index].id_pregunta.toString() ,valor);

                                          },*/
                                          /*onChanged: (valor){
                                            _.guardarInput (_.preguntas[index].id_pregunta.toString() ,valor);
                                          },*/
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

                          }



                        }
                      ),
                    
                  ),

                  SizedBox(height: 20,),

                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(0, 102, 84, 1),
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
            
          ):

          Center(
            child: CircularProgressIndicator(),
          )
          
          
          
          
        ),
      ),
    );
  }
}


TextFieldWidget1(String enunciado, String  numPregunta,QuizController _ ,int index, int id_pregunta){

    //List<InputTextfield> _controllerInput = [];

    
    /*_controllerInput.add(
      InputTextfield( id_pregunta.toString(), TextEditingController() )
    );*/

    print(_.controllerInput.length);

    for (var i = 0; i < _.controllerInput.length; i++) {

      //_.guardarIput(_controllerInput);

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

  /*return Padding(
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
                  
                  controller: _controllerInput,
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
    );*/

}

SelectSimpleWidget(String enunciado , int id_pregunta, QuizController _ ,BuildContext context, String numPregunta){

  return Padding(
    padding: EdgeInsets.only(left: 20,right: 20),
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
            
              child: SimpleSelectPage(

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