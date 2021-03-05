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
                  'Pregunta 1 de 200',
                  style: TextStyle(
                    
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),

              Padding(
                padding:  EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Stack(

                  children: [

                    Container(
                        height: 5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20)
                        ),
                    ),

                    Container(
                        height: 5,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 102, 84, 1),
                          borderRadius: BorderRadius.circular(20)
                        ),
                    ),

                  ],

                ),
              ),

              SizedBox(height: 30,),

              _.tipo_pregunta == "Imagen" ? 
              ImagePage() 
              
              : _.tipo_pregunta == "Texto"?
              TextFieldPage()
              
              : _.tipo_pregunta == "Coordenadas" ?
              CoordenadasPage()
              
              : _.tipo_pregunta == "SimpleSelect"?  
              SimpleSelectPage()
              
              : MultipleSelectPage(),

              //TextFieldPage(),
              //CoordenadasPage(),
              //ImagePage(),
              //MultipleSelectPage(),
              //SimpleSelectPage(),

              

              Padding(
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
              )


            ],
          ),
        )
        
      ),
    );
  }
}