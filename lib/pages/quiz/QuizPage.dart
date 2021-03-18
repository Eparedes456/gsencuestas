import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/CoordenadasWidget.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/ImageWidget.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/MultipleSelectWidget.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/SimpleSelectWidget.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/TextFieldWidget.dart';



class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      init: QuizController(),
      builder: (_)=> Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Nombre de la encuesta'),
          centerTitle: true,
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

                        if(_.preguntas[index].tipo_pregunta == "INPUTABLE"){

                          return TextFieldWidget(enunciadoPregunta,numPregunta.toString());

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
                    gradient: LinearGradient(
                      colors: [

                        Color.fromRGBO(10, 143, 119, 1),
                        Color.fromRGBO(25, 189, 159, 1),
                        Color.fromRGBO(0, 102, 84, 1)

                      ]
                    )
                  ),
                  child: MaterialButton(
                    child: Text(
                      'Guardar',
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
    );
  }
}


TextFieldWidget(String enunciado, String  numPregunta){

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
                  //controller: ,
                  decoration: InputDecoration(
                    hintText: 'Ingrese su respuesta'
                  ),
                ),
              
              ),

              SizedBox( height: 20,),



            ],
          ),
        )
      ),
    );

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