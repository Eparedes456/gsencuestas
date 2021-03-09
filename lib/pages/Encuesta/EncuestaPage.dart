import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Encuesta/EncuestaController.dart';
import 'package:gsencuesta/pages/quiz/QuizPage.dart';


class EncuestaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EncuestaController>(
      init: EncuestaController(),
      builder:(_) => Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            
            Column(
              children: [

                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                      boxShadow: [

                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0,2.0),
                          blurRadius: 6.0,
                        )

                      ]
                    ),
                    child: ClipRRect(
                      //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                      child: Image(
                        image: NetworkImage('${_.imagePortada}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ),

                Expanded(
                  flex: 5,
                  child: ListView(
                    children: [
                      
                      SizedBox(height: 40,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Text(
                          '${_.descripcion}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w200
                          ),
                          textAlign: TextAlign.justify,
                        
                        ),
                      ),

                      Padding(
                        padding:  EdgeInsets.only(left: 40,right: 40,top: 30),
                        child: Container(

                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 102, 84, 1),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          height: 45,
                          child: MaterialButton(
                            onPressed: (){

                              _.navigateToQuiz();

                            },
                            child: Text(
                              'Empezar',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                        ),
                      )

                    ],
                  )
                )


              ],
            ),

            Padding(
                          padding:  EdgeInsets.only(left: 20,right: 20),
                          child: SafeArea(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                IconButton(
                                  icon:  Platform.isAndroid ?  Icon(Icons.arrow_back) : Icon(Icons.arrow_back_ios),
                                  color: Colors.white,
                                  iconSize: 30,
                                  onPressed: (){

                                    Navigator.of(context).pop();

                                  },
                                ),

                                Expanded(
                                  child: Text(
                                    _.titulo,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
           
                  

            Positioned(
              top: MediaQuery.of(context).size.height * (4/9) - 160,
              left: 16,
              right: 16,
              child: Container(
                height: 90,
                //color: Colors.black,
                child: Row(
                  children: [

                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)
                        ),
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            
                            
                            Center(
                              child: Text(
                                _.fechaInicio,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins'
                                ),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Inicia',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                              ),
                            ),

                          ],
                        ),
                      )
                    ),

                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)
                        ),
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Center(
                              child: Text(
                                _.fechaFin == null ? 'No registra' : _.fechaFin,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins'
                                ),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Finaliza',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                              ),
                            ),

                          ],
                        ),
                      )
                    ),
                    
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)
                        ),
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Center(
                              child: Text(
                                '25',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins'
                                ),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              'Nº preguntas',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                              ),
                            ),

                          ],
                        ),
                      )
                    ),

                  ],
                ),
              )
            )
            

          ],
        )

      ),
    );
  }
}