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
        child: GestureDetector(
                            onTap: null,
                            child: Container(
                              height:   45,
                              
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:   _.opcionesPreguntas[index].selected == true ? Colors.green : Colors.grey ,
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
                                          color:  _.opcionesPreguntas[index].selected == true ?  Colors.white :Colors.black
                                        ),
                                      )
                                    ),

                                    Icon(Icons.check_circle_outline,color:  _.opcionesPreguntas[index].selected == true ? Colors.white : Colors.black,)
                                    


                                  ],
                                ),
                              ),
                            ),
        ),
      ),
    );
  }
}