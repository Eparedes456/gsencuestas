import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/VerEncuesta/VerEncuestaController.dart';
import 'package:gsencuesta/pages/VerEncuesta/verencuestawidget/simpleSelect.dart';

class VerEncuestaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerEncuestacontroller>(
      init: VerEncuestacontroller(),
      builder: (_) => Scaffold(

        appBar: AppBar(
          title: Text(_.titulo),
          centerTitle: true,
        ),

        body: _.isLoadingData == true?  
        
        Container(
          child: Column(
            children: [

              SizedBox(height: 20,),
                Padding(
                  padding:  EdgeInsets.only(left: 20,right: 20),
                  child: Text(
                    '',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,fontWeight: FontWeight.w700
                    ),
                  ),
                ),

                //SizedBox(height: 30,),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _.preguntas.length,
                    itemBuilder: (BuildContext context, index){

                      var enunciadoPregunta =   _.preguntas[index].enunciado;
                        var numPregunta = index + 1;
                        var id_pregunta = _.preguntas[index].id_pregunta;
                      _.controllerInput.add(
                        InputTextfield( id_pregunta.toString(), TextEditingController() )
                      );

                      if(_.preguntas[index].tipo_pregunta == "IMPUTABLE"){

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
                                        '$numPregunta.- $enunciadoPregunta',
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
                                        readOnly: true,
                                        controller: _.controllerInput[index].controller,
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


                      }else{

                        return SelectSimpleWidget(enunciadoPregunta,id_pregunta,_,context,numPregunta.toString());

                      }

                    },
                  ),
                ),

                
               

                SizedBox(height: 20,),

            ],
          ),
        )
        
        : Center(
            child: CircularProgressIndicator(),
          ),
        
      ),
    );
  }
}

SelectSimpleWidget(String enunciado , int id_pregunta, VerEncuestacontroller _ ,BuildContext context, String numPregunta){

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
            
              child: SimpleSelectVer(

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