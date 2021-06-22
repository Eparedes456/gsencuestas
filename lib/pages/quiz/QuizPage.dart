import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

                  SizedBox(height: 10,),
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

                  SizedBox(height: 10,),
                  Expanded(
                    //height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        shrinkWrap: true,
                        //physics: ScrollPhysics(),
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: _.preguntas.length,
                        itemBuilder: (BuildContext context, index){

                          var enunciadoPregunta =   _.preguntas[index].enunciado;
                          var numPregunta = index + 1;
                          var id_pregunta = _.preguntas[index].id_pregunta;
                          var placeholder = _.preguntas[index].bind_field_placeholder;
                          var maxLength = _.preguntas[index].bind_field_length;
                          var typeData = _.preguntas[index].bind_type;

                          if(_.preguntas[index].tipo_pregunta == "integer" || _.preguntas[index].tipo_pregunta == "decimal" ){

                            
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
                                          keyboardType: typeData == "number" ? TextInputType.phone  : TextInputType.text,
                                          inputFormatters: typeData == "number"?  <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly
                                          ] : null,
                                          onChanged: (value){
                                            _.calcular();
                                          },
                                        ),
                                      
                                      ),

                                      SizedBox( height: 20,),



                                    ],
                                  ),
                                )
                              ),
                            );

        
                          }else if(_.preguntas[index].tipo_pregunta == "text"){
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
                                          keyboardType:  TextInputType.text,
                                          
                                        ),
                                      
                                      ),

                                      SizedBox( height: 20,),



                                    ],
                                  ),
                                )
                              ),
                            );
                          }else if(_.preguntas[index].tipo_pregunta == "note"){
                            return Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Container(
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20,left: 10,right: 10),
                                        child: Text(
                                          '$numPregunta.- $enunciadoPregunta',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Poppins',
                                            fontSize: 16
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                        child: TextField(
                                          controller: _.controllerInput[index].controller,
                                          readOnly: true,
                                        ),           
                                      ),
                                      //Text(_.total.toString())
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }else if(_.preguntas[index].tipo_pregunta == "select_one list_name"){

                            return SelectSimpleWidget(enunciadoPregunta,id_pregunta,_,context,numPregunta.toString());

                          }else  if( _.preguntas[index].tipo_pregunta == "select_multiple list_name"){
                            return MultiSelectWidget(enunciadoPregunta,id_pregunta,_,context,numPregunta.toString());
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

MultiSelectWidget(String enunciado, int id_pregunta, QuizController _ ,BuildContext context, String numPregunta){

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
            
              child: MultipleSelectPage(
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