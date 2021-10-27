import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/controller/VerEncuesta/VerEncuestaController.dart';

class SimpleSelectVer extends StatelessWidget {

  final int id_pregunta;

  SimpleSelectVer({Key key, @required this.id_pregunta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerEncuestacontroller>(
      init: VerEncuestacontroller(),
      builder: (_) => ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _.opcionesPreguntas.length,
                  itemBuilder: (context,index){

                    if(id_pregunta == _.opcionesPreguntas[index].idPregunta){

                      return Opciones(
                        id_pregunta: id_pregunta,
                        index: index,
                      );
                      
                      
                      

                    }else{

                      return Container();

                    }

                    
                  }
      ),
    );
  }
}

class Opciones extends StatelessWidget {
  final int id_pregunta;
  final int index;

  Opciones({Key key, @required this.id_pregunta, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerEncuestacontroller>(
      init: VerEncuestacontroller(),
      id: 'simple',
      builder: (_)=> Padding(
        padding:  EdgeInsets.only(left: 20,right:20,bottom: 8),
        child: Column(
          children: [
            GestureDetector(
                                onTap: null,
                                child: Container(
                                  height:   45,
                                  
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color:   _.opcionesPreguntas[index].selected == true ? Color.fromRGBO(246, 252, 124,1) : Colors.grey[200] ,
                                    borderRadius: BorderRadius.circular(15),
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
                                              color:  _.opcionesPreguntas[index].selected == true ?  Colors.black : Colors.black,
                                            ),
                                          )
                                        ),

                                        Icon(Icons.check_circle_outline,color:  _.opcionesPreguntas[index].selected == true ? Colors.black : Colors.black,)
                                        


                                      ],
                                    ),
                                  ),
                                ),
            ),

             _.opcionesPreguntas[index].hijos == true  && _.opcionesPreguntas[index].selected == true?
              
              OpcionesHijos(index: index,)  : Container()
          ],
        ),
      ),
    );
  }
}

class OpcionesHijos extends StatelessWidget {

  final int index;
  const OpcionesHijos({ Key key, this.index }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerEncuestacontroller>(
      init: VerEncuestacontroller(),
      id: 'simpleHijosRetomar',
      builder: (_)=> Padding(
              padding:  EdgeInsets.only(left: 12,right: 12,top: 0,bottom: 0),
              child: Container(
                
                width: double.infinity,
                //color: Colors.blue,
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      
                      Padding(
                        padding: const EdgeInsets.only(top: 8,left: 12),
                        child: Text(
                          'Seleccione una opción',
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.zero,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _.opcionesHijos.length,
                          itemBuilder: (context,index2){

                            if( _.opcionesHijos[index2].padre == _.opcionesPreguntas[index].idOpcion ){

                              return GestureDetector(
                                onTap: (){

                                  //_.capturarRespuestaSimpleHijos(_.opcionesHijos[index2]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12,right: 12,bottom: 8),
                                  child: Container(
                                    height: 35,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: _.opcionesHijos[index2].selected ==  true ?    Color.fromRGBO(92, 197, 250, 1) : Colors.grey[200]
                                    ),
                                    child: Padding(
                                      padding:  EdgeInsets.only(left: 20,right:10),
                                      child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            
                                            Expanded(
                                              child: Text(
                                                _.opcionesHijos[index2].label,
                                                style: TextStyle(
                                                  color:  Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300
                                                ),
                                              )
                                            ),
                              
                                            Icon(
                                              Icons.check_circle_outline,
                                              color:  Colors.black,
                                            )
                                            
                                          ],
                                        ),
                                    ),
                                  ),
                                ),
                              );

                            }else{

                              return Container();

                            }
                          }
                        ),
                      )

                    ],
                  ),
                ),
              ),
            )
    );
  }
}