import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/RetomarController/RetomarController.dart';

class SimpleSelectRetomar extends StatelessWidget {

  final int id_pregunta;

  SimpleSelectRetomar({Key key, @required this.id_pregunta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetommarController>(
     
      init: RetommarController(),
      //id: 'simpleSelect',
      id: 'opciones',
      builder: (_) => Column(
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

          //_.widgetSimpleWithOption(id_pregunta)

          for (var i = 0; i < _.opcionesPreguntas.length; i++)...{
                  
            if(id_pregunta == _.opcionesPreguntas[i].idPregunta)...{

              if(_.opcionesPreguntas[i].selected && _.opcionesPreguntas[i].requiereDescripcion == "true" )...{

                

                      Padding(
                      padding:  EdgeInsets.only(left: 20,right: 20),
                      child: _.textFormFields(id_pregunta)
                      
                      
                      /*TextFormField(
                        controller: TextEditingController(text: _.opcionesPreguntas[i].valor),
                       //  _.controllerInput[i].controller  _.opcionesPreguntas[i].valor == "" || _.opcionesPreguntas[i].valor ==  null  ? _.controller : _.opcionesPreguntas[i].valor  == "No cumple" || _.opcionesPreguntas[i].valor  == "NO CUMPLE" || _.opcionesPreguntas[i].valor  == "Si cumple" || _.opcionesPreguntas[i].valor  == "SI CUMPLE" ?  _.controller : TextEditingController(text: _.opcionesPreguntas[i].valor),
                        
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
                      ),*/
                    )
                    
              }
            }
          }
          
        ],
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
    return GetBuilder<RetommarController>(
      init: RetommarController(),
      id: 'opciones',
      builder: (_)=> Padding(
        padding:  EdgeInsets.only(left: 20,right:20,bottom: 8),
        child: GestureDetector(
                            onTap: (){

                              

                              _.capturarRespuestaSimple(_.opcionesPreguntas[index]);

                            },
                            child: Container(
                              height:   35,
                              
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
                                          color:  _.opcionesPreguntas[index].selected == true ?  Colors.black : Colors.black
                                        ),
                                      )
                                    ),

                                    Icon(Icons.check_circle_outline,color:  _.opcionesPreguntas[index].selected == true ? Colors.black : Colors.black,)
                                    


                                  ],
                                ),
                              ),
                            ),
        ),
      ),
    );
  }
}