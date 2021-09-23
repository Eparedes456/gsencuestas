import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io' show Platform;

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/RetomarController/RetomarController.dart';
import 'package:gsencuesta/pages/Retomar/quizRetomar/DatePickerRetomar.dart';
import 'package:gsencuesta/pages/Retomar/quizRetomar/ImageRetomar.dart';
import 'package:gsencuesta/pages/Retomar/quizRetomar/MultiSelectWidgetRetomar.dart';
import 'package:gsencuesta/pages/Retomar/quizRetomar/SimpleSelectRetomar.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/SimpleSelectWidget.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/UbigeoWidget.dart';

class RetomarEncuestaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloque;
    return GetBuilder<RetommarController>(
      init: RetommarController(),
      builder: (_) => Scaffold(
        backgroundColor: Colors.grey[200],
        /*appBar: AppBar(
          title: Text(_.titulo),
          centerTitle: true,
          leading: IconButton(
            icon: Platform.isAndroid
                ? Icon(Icons.arrow_back)
                : Icon(Icons.arrow_back_ios),
            onPressed: () {
              _.pauseQuiz();
            },
          ),
        ),*/
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
                  //height: 150,
                  color: Color.fromRGBO(0, 102, 84, 1),
                  child: Column(
                    children: [
                      SafeArea(
                        bottom: false,
                        child: Container()
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 12,),
                            GestureDetector(
                              onTap: (){
                                _.pauseQuiz();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            
                            Expanded(
                              child: Container(
                                //color: Colors.black,
                                child: Center(
                                  child: Text(
                                    _.titulo,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                )
                              )
                            ),
                            Container(width: 12,)

                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                                      
                                      Padding(
                                        padding:  EdgeInsets.only(left: 24,top: 8),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                
                                                Text('${_.nombreEncuestado}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  )
                                                )
                                                  
                                                  

                                              ],
                                            ),
                                            
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(right: 28,top: 0,left: 24),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Row(
                                              children: [
                                                Text(
                                                  'Dni',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                SizedBox(width: 8,),
                                                
                                                Text(
                                                  '${_.dni}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  )
                                                )

                                              ],
                                            ),
                                            Spacer(),
                                              Row(
                                                children: [

                                                  Icon(
                                                    Icons.assignment_outlined,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                  SizedBox(width: 8,),
                                                  Text(
                                                    '${_.preguntas.length} preguntas',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 13,
                                                        //fontWeight: FontWeight.w700,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                                
                                                
                                                //SizedBox(width: 20,),
                                                
                                                
                                                  //fontWeight: FontWeight.w700),),
                                              ],
                                            ),

                                          
                                        
                                      ),
                                      SizedBox(height: 8,),
                                      
                                      
                                        SizedBox(height: 12,),
                                
                        ],
                      ),
                    ],
                  ),
            ),

            _.isLoadingData ==  true 
            ?
            Container(
              child: Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [

                      for (var i = 0; i < _.preguntas.length; i++) ...{
                              if (_.preguntas[i].tipo_pregunta == "integer" ||
                                  _.preguntas[i].tipo_pregunta == "decimal") ...{
                                IntegerDecimalWidget(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion,
                                    _.preguntas[i].bind_field_length,
                                    i,
                                    _.preguntas[i].bind_field_placeholder,
                                    _.preguntas[i].requerido,
                                    _.preguntas[i].bind_type)
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "text") ...{
                                CustomTextField(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion,
                                    _.preguntas[i].bind_field_length,
                                    i,
                                    _.preguntas[i].bind_field_placeholder,
                                    _.preguntas[i].requerido,
                                    _.preguntas[i].tipo_pregunta
                                ),
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "note") ...{
                                Note(
                                  _.preguntas[i].enunciado,
                                  _.preguntas[i].id_pregunta,
                                  _,
                                  context,
                                  (i + 1).toString(),
                                  bloque,
                                  _.preguntas[i].bloqueDescripcion,
                                  i,
                                  _.preguntas[i].requerido,
                                )
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "select_one list_name") ...{
                                SelectSimpleWidget(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion,
                                    _.preguntas[i].requerido
                                ),
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "select_multiple list_name") ...{
                                MultiSelectWidget(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion),
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "ubigeo") ...{
                                Ubigeo(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion,
                                    i,
                                    _.preguntas[i].apariencia,
                                    _.preguntas[i].requerido
                                )
                              }else if(_.preguntas[i].tipo_pregunta =="date")...{

                                    //Text('holi')

                                    DatePickWidget(
                                      _.preguntas[i].enunciado,
                                      _.preguntas[i].id_pregunta,
                                      _,
                                      context,
                                      (i + 1).toString(),
                                      bloque,
                                        _.preguntas[i].bloqueDescripcion,
                                        "",
                                        i,
                                        "",
                                        "",
                                        "",
                                        _.preguntas[i].bind_type
                                    )

                              }else if(_.preguntas[i].tipo_pregunta =="image")...{
                                    
                                    ImageWidget(
                                      _.preguntas[i].enunciado,
                                      _.preguntas[i].id_pregunta,
                                      _,
                                      context,
                                      (i + 1).toString(),
                                      bloque,
                                        _.preguntas[i].bloqueDescripcion,
                                        i.toString(),
                                        1,
                                        "",
                                        _.preguntas[i].requerido
                                    ),
                                  }
                            },

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(0, 102, 84, 1)),
                        child: MaterialButton(
                            child: Text(
                              'Continuar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              _.guardarFicha();
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),
                ),
              ),
            )

            : Expanded(
              child: Container(
                child: Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            )


          ],
        )
        
        
        /*_.isLoadingData == true
            ? Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Total de preguntas a responder ${_.preguntas.length}',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                        child: 
                        
                        SingleChildScrollView(
                       
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          children: [
                            for (var i = 0; i < _.preguntas.length; i++) ...{
                              if (_.preguntas[i].tipo_pregunta == "integer" ||
                                  _.preguntas[i].tipo_pregunta == "decimal") ...{
                                IntegerDecimalWidget(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion,
                                    _.preguntas[i].bind_field_length,
                                    i,
                                    _.preguntas[i].bind_field_placeholder,
                                    _.preguntas[i].requerido,
                                    _.preguntas[i].bind_type)
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "text") ...{
                                CustomTextField(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion,
                                    _.preguntas[i].bind_field_length,
                                    i,
                                    _.preguntas[i].bind_field_placeholder,
                                    _.preguntas[i].requerido),
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "note") ...{
                                Note(
                                  _.preguntas[i].enunciado,
                                  _.preguntas[i].id_pregunta,
                                  _,
                                  context,
                                  (i + 1).toString(),
                                  bloque,
                                  _.preguntas[i].bloqueDescripcion,
                                  i,
                                  _.preguntas[i].requerido,
                                )
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "select_one list_name") ...{
                                SelectSimpleWidget(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion),
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "select_multiple list_name") ...{
                                MultiSelectWidget(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion),
                              } else if (_.preguntas[i].tipo_pregunta ==
                                  "ubigeo") ...{
                                Ubigeo(
                                    _.preguntas[i].enunciado,
                                    _.preguntas[i].id_pregunta,
                                    _,
                                    context,
                                    (i + 1).toString(),
                                    bloque,
                                    _.preguntas[i].bloqueDescripcion,
                                    i,
                                    _.preguntas[i].apariencia)
                              }else if(_.preguntas[i].tipo_pregunta =="date")...{

                                    //Text('holi')

                                    DatePickWidget(
                                      _.preguntas[i].enunciado,
                                      _.preguntas[i].id_pregunta,
                                      _,
                                      context,
                                      (i + 1).toString(),
                                      bloque,
                                        _.preguntas[i].bloqueDescripcion,
                                        "",
                                        i,
                                        "",
                                        "",
                                        "",
                                        _.preguntas[i].bind_type
                                    )

                              }else if(_.preguntas[i].tipo_pregunta =="image")...{
                                    
                                    ImageWidget(
                                      _.preguntas[i].enunciado,
                                      _.preguntas[i].id_pregunta,
                                      _,
                                      context,
                                      (i + 1).toString(),
                                      bloque,
                                        _.preguntas[i].bloqueDescripcion,
                                        i.toString(),
                                        1,
                                        "",
                                        ""
                                    ),
                                  }
                            }
                          ],
                        ),
                      )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(0, 102, 84, 1)),
                      child: MaterialButton(
                          child: Text(
                            'Continuar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            _.guardarFicha();
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),*/

        /*floatingActionButton: FloatingActionButton(
          onPressed: (){
            _.Scrollcontroller.jumpTo(0);
          },
          child: Icon(Icons.arrow_upward),
        ),*/
      ),
    );
  }
}





 ImageWidget(String enunciado,
    int id_pregunta,
    RetommarController _,
    BuildContext context,
    String numPregunta,
    String bloque,
    String bloque2,
    String maxLength,
    int i,
    String placeholder,
    String requerido){

      if (_.bloque == null || _.bloque == "") {
    _.bloque = bloque2;
  } else if (_.bloque == bloque2) {
    bloque = bloque2;
  } else if (_.bloque != bloque2) {
    _.bloque = bloque2;
  }

  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10,bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _.bloque == bloque
            ? Container()
            : Padding(
                padding:
                    EdgeInsets.only( top: 10, bottom: 10),
                child: Container(
                  width: double.infinity,
                  color: Color.fromRGBO(3, 161, 133, 1),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 10,bottom: 10,left: 10),
                    child: Row(
                          children: [
                            Icon(
                              Icons.grid_view,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                '${_.bloque}',
                                style: TextStyle(
                                    color: Colors.white, //Color.fromRGBO(0, 102, 84, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
              ),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Container(
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '$numPregunta. $enunciado',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                          ),
                          Text(
                            requerido == "true" ? " (*)" : "",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: ImageRetonarPage(
                        idPregunta: id_pregunta.toString(),
                        i: i,
                      )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
        ),
      ],
    ),
  );
}


 DatePickWidget(String enunciado,
    int id_pregunta,
    RetommarController _,
    BuildContext context,
    String numPregunta,
    String bloque,
    String bloque2,
    String maxLength,
    int i,
    String placeholder,
    String requerido,
    String apariencia,
    String tipoCampo
    ){

      if (_.bloque == null || _.bloque == "") {
        _.bloque = bloque2;
      } else if (_.bloque == bloque2) {
        bloque = bloque2;
      } else if (_.bloque != bloque2) {
        _.bloque = bloque2;
      }

      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _.bloque == bloque
            ? Container()
            : Padding(
                padding:
                    EdgeInsets.only( top: 10, bottom: 10),
                child: Container(
                  width: double.infinity,
                  color: Color.fromRGBO(3, 161, 133, 1),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 10,bottom: 10,left: 10),
                    child: Row(
                          children: [
                            Icon(
                              Icons.grid_view,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                '${_.bloque}',
                                style: TextStyle(
                                    color: Colors.white, //Color.fromRGBO(0, 102, 84, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
              ),

              DatePickerRetomar(
                idpregunta: id_pregunta.toString(),
                enunciado: enunciado,
                numPregunta: numPregunta,
                tipoCampo: tipoCampo,
                //bloque: _.preguntas[i].bloqueDescripcion,
                i: i,
                pagina: "quiz",
              )            
          ],
        ),
      );


    }

 SelectSimpleWidget(String enunciado, int id_pregunta, RetommarController _,
    BuildContext context, String numPregunta, String bloque, String bloque2,String requerido) {
  if (_.bloque == null || _.bloque == "") {
    _.bloque = bloque2;
  } else if (_.bloque == bloque2) {
    bloque = bloque2;
  } else if (_.bloque != bloque2) {
    _.bloque = bloque2;
  }

  return Padding(
    padding: EdgeInsets.only(left: 0, right: 0,bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _.bloque == bloque
            ? Container()
            : Padding(
                padding:
                    EdgeInsets.only(  top: 10, bottom: 10),
                child: Container(
                  width: double.infinity,
                  color: Color.fromRGBO(3, 161, 133, 1),
                  child: Padding(
                    padding:  EdgeInsets.only(left: 15,top: 8,bottom: 8,right: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.grid_view,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            '${_.bloque}',
                            style: TextStyle(
                                color: Colors.white, //Color.fromRGBO(0, 102, 84, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Container(
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$numPregunta. $enunciado',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                 
                                  fontSize: 14),
                                  textAlign: TextAlign.justify,
                            ),
                          ),
                          Text(
                            requerido == "true" ? " (*)" : "",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    
                    Container(
                        child: SimpleSelectRetomar(
                      id_pregunta: id_pregunta,
                    )),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
        ),
      ],
    ),
  );
}

 MultiSelectWidget(String enunciado, int id_pregunta, RetommarController _,
    BuildContext context, String numPregunta, String bloque, String bloque2) {
  if (_.bloque == null || _.bloque == "") {
    _.bloque = bloque2;
  } else if (_.bloque == bloque2) {
    bloque = bloque2;
  } else if (_.bloque != bloque2) {
    _.bloque = bloque2;
  }

  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _.bloque == bloque
            ? Container()
            : Padding(
                padding:
                    EdgeInsets.only( top: 10, bottom: 10),
                child: Container(
                  width: double.infinity,
                  color: Color.fromRGBO(3, 161, 133, 1),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 10,bottom: 10,left: 10),
                    child: Row(
                          children: [
                            Icon(
                              Icons.grid_view,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                '${_.bloque}',
                                style: TextStyle(
                                    color: Colors.white, //Color.fromRGBO(0, 102, 84, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
              ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Container(
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Text(
                        '$numPregunta.- $enunciado',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: MultipleSelectRetomarPage(
                      id_pregunta: id_pregunta,
                    )),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
        ),
      ],
    ),
  );
}

 CustomTextField(
    String enunciado,
    int id_pregunta,
    RetommarController _,
    BuildContext context,
    String numPregunta,
    String bloque,
    String bloque2,
    String maxLength,
    int i,
    String placeholder,
    String requerido,
    String tipo_pregunta
) {
  if (_.bloque == null || _.bloque == "") {
    _.bloque = bloque2;
  } else if (_.bloque == bloque2) {
    bloque = bloque2;
  } else if (_.bloque != bloque2) {
    _.bloque = bloque2;
  }

  var radOnly = false;

  if(_.metaData == null || _.metaData == ""){

    radOnly = false;

  }else if(_.metaData["unidad_ejecutora"]["idPregunta"] == id_pregunta){
    radOnly = true;
  }

  return Padding(
    padding: EdgeInsets.only(left: 0, right: 0,bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _.bloque == bloque
            ? Container()
            : Padding(
                padding:
                    EdgeInsets.only( top: 10, bottom: 10),
                child: Padding(
                  padding:   EdgeInsets.only( top: 10, bottom: 10),
                  child: Container(
                    width: double.infinity,
                  color: Color.fromRGBO(3, 161, 133, 1),
                    child: Padding(
                      padding:  EdgeInsets.only(top: 10,bottom: 10,left: 10),
                      child: Row(
                                children: [
                                  Icon(
                                    Icons.grid_view,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${_.bloque}',
                                      style: TextStyle(
                                          color: Colors.white, //Color.fromRGBO(0, 102, 84, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                          ),
                    ),
                  ),
                ),
              ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Container(
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '$numPregunta. $enunciado',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                 
                                  fontSize: 14),
                                  textAlign: TextAlign.justify,
                            ),
                          ),
                          Text(
                            requerido == "true" ? " (*)" : "",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        onChanged: (value){

                          _.saveRequireObservacion(id_pregunta.toString(),"",value,tipo_pregunta);

                        },
                        maxLength:
                            maxLength == null || int.parse(maxLength) == 0
                                ? 100
                                : int.parse(maxLength),
                        controller: _.controllerInput[i].controller,
                        readOnly: radOnly,
                        decoration: InputDecoration(
                            hintText: placeholder == "-" || placeholder == null
                                ? 'Ingrese su respuesta'
                                : placeholder,
                                hintStyle: TextStyle(
                                  fontSize: 14
                                )
                        
                        ),
                                
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
        ),
      ],
    ),
  );
}

 IntegerDecimalWidget(
    String enunciado,
    int id_pregunta,
    RetommarController _,
    BuildContext context,
    String numPregunta,
    String bloque,
    String bloque2,
    String maxLength,
    int i,
    String placeholder,
    String requerido,
    String tipoDato) {
  if (_.bloque == null || _.bloque == "") {
    _.bloque = bloque2;
  } else if (_.bloque == bloque2) {
    bloque = bloque2;
  } else if (_.bloque != bloque2) {
    _.bloque = bloque2;
  }

  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Container(
        width: double.infinity,
        child: Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _.bloque == bloque
                  ? Container()
                  : Padding(
                padding:
                    EdgeInsets.only( top: 10, bottom: 10),
                child: Container(
                  width: double.infinity,
                  color: Color.fromRGBO(3, 161, 133, 1),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 10,bottom: 10,left: 10),
                    child: Row(
                          children: [
                            Icon(
                              Icons.grid_view,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                '${_.bloque}',
                                style: TextStyle(
                                    color: Colors.white, //Color.fromRGBO(0, 102, 84, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$numPregunta.- $enunciado',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            fontSize: 16),
                      ),
                    ),
                    Text(
                      requerido == "true" ? " (*)" : "",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  maxLength: maxLength == null || int.parse(maxLength) == 0
                      ? 100
                      : int.parse(maxLength),
                  controller: _.controllerInput[i].controller,
                  decoration: InputDecoration(
                      hintText: placeholder == "-" || placeholder == null
                          ? 'Ingrese su respuesta'
                          : placeholder),
                  keyboardType: tipoDato == "number" || tipoDato == "decimal"
                      ? TextInputType.numberWithOptions(
                          decimal: true,
                        )
                      : TextInputType.text,
                  inputFormatters: tipoDato == "number"
                      ? <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly, //.digitsOnly
                        ]
                      : tipoDato == "decimal"
                          ? <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]")), //.digitsOnly
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                try {
                                  final text = newValue.text;
                                  if (text.isNotEmpty) double.parse(text);
                                  return newValue;
                                } catch (e) {}
                                return oldValue;
                              }),
                            ]
                          : null,
                  onChanged: (value) {
                    _.calcular();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )),
  );
}

 Note(
    String enunciado,
    int id_pregunta,
    RetommarController _,
    BuildContext context,
    String numPregunta,
    String bloque,
    String bloque2,
    int i,
    String requerido) {
  if (_.bloque == null || _.bloque == "") {
    _.bloque = bloque2;
  } else if (_.bloque == bloque2) {
    bloque = bloque2;
  } else if (_.bloque != bloque2) {
    _.bloque = bloque2;
  }

  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _.bloque == bloque
            ? Container()
            : Padding(
                padding:
                    EdgeInsets.only( top: 10, bottom: 10),
                child: Container(
                  width: double.infinity,
                  color: Color.fromRGBO(3, 161, 133, 1),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 10,bottom: 10,left: 10),
                    child: Row(
                          children: [
                            Icon(
                              Icons.grid_view,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                '${_.bloque}',
                                style: TextStyle(
                                    color: Colors.white, //Color.fromRGBO(0, 102, 84, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
              ),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Container(
            width: double.infinity,
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Text(
                      '$numPregunta.- $enunciado',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: _.controllerInput[i].controller,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

 TextFieldWidget1(String enunciado, String numPregunta, RetommarController _,
    int index, int id_pregunta) {
  for (var i = 0; i < _.controllerInput.length; i++) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
          width: double.infinity,
          child: Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Text(
                    '$numPregunta.- $enunciado',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: _.controllerInput[i].controller,
                    decoration:
                        InputDecoration(hintText: 'Ingrese su respuesta'),
                    onSubmitted: (valor) {},
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
    );
  }
}

  Ubigeo(
    String enunciado,
    int id_pregunta,
    RetommarController _,
    BuildContext context,
    String numPregunta,
    String bloque,
    String bloque2,
    int i,
    String apariencia,
    String requerido
  ) {
  if (_.bloque == null || _.bloque == "") {
    _.bloque = bloque2;
  } else if (_.bloque == bloque2) {
    bloque = bloque2;
  } else if (_.bloque != bloque2) {
    _.bloque = bloque2;
  }
  return Column(
    children: [

      _.bloque == bloque
            ? Container()
            : Padding(
                padding:
                    EdgeInsets.only( top: 10, bottom: 10),
                child: Container(
                  width: double.infinity,
                  color: Color.fromRGBO(3, 161, 133, 1),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 10,bottom: 10,left: 10),
                    child: Row(
                          children: [
                            Icon(
                              Icons.grid_view,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                '${_.bloque}',
                                style: TextStyle(
                                    color: Colors.white, //Color.fromRGBO(0, 102, 84, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                    ),
                  ),
                ),
              ),

      UbigeoWidget(
        id_pregunta: _.preguntas[i].id_pregunta,
        enunciado: _.preguntas[i].enunciado,
        numPregunta: (i + 1).toString(),
        apariencia: apariencia,
        bloque: _.preguntas[i].bloqueDescripcion,
        i: i,
        pagina: "retomar",
        requerido: requerido,
      ),
    ],
  );
}


