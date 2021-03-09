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

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Padding(
                padding: EdgeInsets.only(top: 40,left: 20),
                child: Text(
                  'Total de preguntas a responder ${_.preguntas.length}',
                  style: TextStyle(
                    
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),

              

              SizedBox(height: 30,),
              SizedBox(height: 20,),

              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _.preguntas.length,
                  itemBuilder: (context,index){
                    var enunciadoPregunta = _.preguntas[index].enunciado;
                    var numPregunta = 0;
                    var id_pregunta = _.preguntas[index].id_pregunta;

                    print(_.preguntas[index]);

                    if(_.preguntas[index].tipo_pregunta == "INPUTABLE"){

                      return Column(
                        children: [
                          TextFieldWidget(enunciadoPregunta),
                          SizedBox(height: 50,)
                        ],
                      );

                    }else if(_.preguntas[index].tipo_pregunta == "SIMPLE"){

                      return SelectSimpleWidget(enunciadoPregunta,id_pregunta,_);

                    }

                    

                  }
                ),
              ),
              SizedBox(height: 20,)

              /*Padding(
                padding:  EdgeInsets.only(right: 23,top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    
                    MaterialButton(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      child: Text(
                        'Continuar',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      onPressed: (){

                      }
                    )

                  ],
                ),
              )*/


            ],
          ),
        )
        
      ),
    );
  }
}


TextFieldWidget(String enunciado){

  return Padding(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 5,
          child: Column(
            children: [

              Padding(
                padding:  EdgeInsets.only(top: 20,left: 10,right: 10),
                child: Text(
                  '$enunciado',
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

SelectSimpleWidget(String enunciado , int id_pregunta, QuizController _ ){

  return Padding(
    padding: EdgeInsets.only(left: 20,right: 20),
    child: Container(
      width: double.infinity,
      child: Card(
        elevation: 5,
        child: Column(
          children: [

            Padding(
              padding:  EdgeInsets.only(top: 20,left: 20,right: 20),
              child: Text(
                '$enunciado',
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
              height: 300,
              child: ListView.builder(
                itemCount: _.opcionesPreguntas.length,
                itemBuilder: (context,index){

                  if(id_pregunta == _.opcionesPreguntas[index].id_pregunta){

                    return RadioListTile(
                      value: _.opcionesPreguntas[index].id_opcion,
                      groupValue: _.opcionesPreguntas[index].id_opcion,
                      subtitle: Text('${_.opcionesPreguntas[index].label}'),
                      onChanged: (value){
                        print('Presionado : $value');
                      }
                    );

                  }else{

                    return Container();

                  }

                  
                }
              ),
            ),
          ],
        ),
      )
    ),
  );

}