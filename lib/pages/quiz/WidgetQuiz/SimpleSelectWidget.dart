import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';

class SimpleSelectPage extends StatelessWidget {

  final int id_pregunta;

  SimpleSelectPage({Key key, @required this.id_pregunta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      id: 'simple',
      init: QuizController(),
      builder:(_)=> Column(
        children: [
          
          ListView.builder(
            padding: EdgeInsets.only(top: 12),
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: _.opcionesPreguntas.length,
            itemBuilder: (context,index){

              if(id_pregunta == _.opcionesPreguntas[index].idPregunta){

                              return Column(
                              children: [
                                Opciones(
                                  id_pregunta: id_pregunta,
                                  index: index,
                                ),

                         
                                  
                              ],
                            );
                            
                          }else{

                            return Container();

                          }

            }
          ),

          for (var i = 0; i < _.opcionesPreguntas.length; i++)...{
                    
              if(id_pregunta == _.opcionesPreguntas[i].idPregunta)...{

                if(_.opcionesPreguntas[i].selected && _.opcionesPreguntas[i].requiereDescripcion == "true")...{

                        Padding(
                        padding:  EdgeInsets.only(left: 20,right: 20),
                        child: Container(
                          
                          child: _.textFormFields(id_pregunta,"select_simple")
                          
                          /*TextFormField(
                            style: TextStyle(
                              fontSize: 14
                            ),
                            //controller:  TextEditingController(text: _.opcionesPreguntas[i].valor), //7_.controllerInput[i].controller,
                            onFieldSubmitted: (value){
                              //print(value);
                              _.saveRequireObservacion( 
                                _.opcionesPreguntas[i].idPregunta.toString(),
                                _.opcionesPreguntas[i].idOpcion.toString() , 
                                value
                              );
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Ingrese observación',
                              hintStyle: TextStyle(
                                fontSize: 14
                              )
                              
                            ),
                          ),*/
                        ),
                      )
                      
                }else...{
                  Container(
                    height: 1,
                  )
                }
              }
            }



        ],
      )
      
      /*Container(
        child: Column(
          children: [
            ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _.opcionesPreguntas.length,
                        itemBuilder: (context,index){

                          if(id_pregunta == _.opcionesPreguntas[index].idPregunta){

                              return Column(
                              children: [
                                Opciones(
                                  id_pregunta: id_pregunta,
                                  index: index,
                                ),

               
                                  
                              ],
                            );
                            
                          }else{

                            return Container();

                          }

                          
                        }
            ),

            

            for (var i = 0; i < _.opcionesPreguntas.length; i++)...{
                    
              if(id_pregunta == _.opcionesPreguntas[i].idPregunta)...{

                if(_.opcionesPreguntas[i].selected && _.opcionesPreguntas[i].requiereDescripcion == "true")...{

                        Padding(
                        padding:  EdgeInsets.only(left: 20,right: 20),
                        child: Container(
                          //height: 1,
                          child: TextFormField(
                            //controller: ,
                            onFieldSubmitted: (value){
                              //print(value);
                              _.saveRequireObservacion( 
                                _.opcionesPreguntas[i].idPregunta.toString(),
                                _.opcionesPreguntas[i].idOpcion.toString() , 
                                value
                              );
                            },
                            decoration: InputDecoration(
                              hintText: 'Ingrese observación'
                              
                            ),
                          ),
                        ),
                      )
                      
                }else...{
                  Container(
                    height: 1,
                  )
                }
              }
            }

              
              
            
            
          ],
        ),
      ),*/
    );
  }
}


class Opciones extends StatelessWidget {
  final int id_pregunta;
  final int index;

  Opciones({Key key, @required this.id_pregunta, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      init: QuizController(),
      id: 'simple',
      builder: (_)=> Padding(
        padding:  EdgeInsets.only(left: 20,right:20,bottom: 8,top: 0),
        child: GestureDetector(
                            onTap: (){
                              _.capturarRespuestaSimple(_.opcionesPreguntas[index]);

                            },
                            child: Container(
                              height:   35,
                              
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:   _.opcionesPreguntas[index].selected == true ? Color.fromRGBO(246, 252, 124,1) : Colors.grey[200] ,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:  EdgeInsets.only(left: 20,right:10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    
                                    Expanded(
                                      child: Text(
                                        _.opcionesPreguntas[index].label,
                                        style: TextStyle(
                                          color: _.opcionesPreguntas[index].selected == true ?  Colors.black : Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300
                                        ),
                                      )
                                    ),

                                    Icon(
                                      Icons.check_circle_outline,
                                      color: _.opcionesPreguntas[index].selected == true ? Colors.black : Colors.black,
                                    )
                                    


                                  ],
                                ),
                              ),
                            ),
        ),
      ),
    );
  }
}