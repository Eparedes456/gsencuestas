import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Encuesta/EncuestaController.dart';
import 'package:gsencuesta/pages/quiz/QuizPage.dart';
import 'package:intl/intl.dart';


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
                      child: CachedNetworkImage(
                        imageUrl: "https://test.regionsanmartin.gob.pe:6443/gsencuesta/api/v1/recurso/encuesta/${_.idEncuesta}" , //'${_.imagePortada}',
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Center(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Icon(Icons.error,color: Colors.red,),
                              SizedBox(height: 8,),
                              Text('Lo sentimos no pudimos cargar la imagen')
                            ],
                          )
                        ),
                        fit: BoxFit.cover,
                      )
                      
                      /*Image(
                        image: NetworkImage('${_.imagePortada}'),
                        fit: BoxFit.cover,
                      ),*/
                    ),
                  )
                ),

                Expanded(
                  flex: 4,
                  child: ListView(
                    children: [
                      
                      SizedBox(height: 30,),

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

                              //_.navigateToQuiz();
                              _.showModalSearch();

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
                      ),

                      _.encuestasPendientes == true? Padding(
                        
                        padding: EdgeInsets.only(top: 40,left: 20,right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text('Encuestas pendientes'),

                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.green[800],
                              ),
                              child: Center(
                                child: Text(
                                  "${_.listEncuesta.length}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ):Container(),
                      _.encuestasPendientes == true ? SizedBox(height: 12,) :Container() ,

                      _.encuestasPendientes == true ? ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _.listEncuesta.length,
                        itemBuilder: (context,index){
                          
                          final dateTime = DateTime.parse(_.listEncuesta[index].fechaInicio);
                          final format = DateFormat('dd-MM-yyyy');
                          final clockString = format.format(dateTime); 

                          return Padding(
                            padding:  EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding:  EdgeInsets.only(left: 20,right: 20),
                              child: Card(
                                child: GestureDetector(
                                  child: Column(
                                    
                                    children: [
                                      SizedBox(height: 12,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Container(
                                              height: 80,
                                              child: Image(
                                                image: AssetImage('assets/images/survey-logo.png'),
                                              ),
                                          ),
                                          

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20,right: 20),
                                              child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${_.listEncuesta[index].titulo}'),

                                                  Text('Fecha Inicio : $clockString'),

                                                  MaterialButton(
                                                    height: 25,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12)
                                                    ),
                                                    color: Colors.blue,
                                                    onPressed: (){

                                                    },
                                                    child: Text('Retomar',style: TextStyle(color: Colors.white),),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 12,),
                                    ],
                                  ),
                                )
                              ),
                            ),
                          );

                        },
                      ): Container()

                    ],
                  )
                ),




              ],
            ),

            Padding(
                          padding:  EdgeInsets.only(left: 20,right: 20,top: 10),
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.8),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaY: 19.2,sigmaX: 19.2
                                      ),
                                      child: Text(
                                        
                                        _.titulo + " - " + _.nombreProyecto,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
           
                  

            Positioned(
              top: MediaQuery.of(context).size.height * (4/9) - 150,
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
                                "20 de Marzo",
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
                                'No registra', //_.fechaFin == null ? 'No registra' : _.fechaFin,
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
                              child:  _.listPregunta.length > 0 ? Text(
                                _.listPregunta.length.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins'
                                ),
                              ) :CircularProgressIndicator() ,
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