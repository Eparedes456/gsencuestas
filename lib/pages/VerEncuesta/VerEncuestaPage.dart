import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/VerEncuesta/VerEncuestaController.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';
import 'package:gsencuesta/pages/Retomar/quizRetomar/MultiSelectWidgetRetomar.dart';
import 'package:gsencuesta/pages/VerEncuesta/verencuestawidget/VerDatePicker.dart';
import 'package:gsencuesta/pages/VerEncuesta/verencuestawidget/VerImage.dart';
import 'package:gsencuesta/pages/VerEncuesta/verencuestawidget/simpleSelect.dart';
import 'package:gsencuesta/pages/quiz/WidgetQuiz/UbigeoWidget.dart';

class VerEncuestaPage extends StatelessWidget {
  var bloque;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerEncuestacontroller>(
      init: VerEncuestacontroller(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(_.titulo),
          centerTitle: true,
        ),
        body: _.isLoadingData == true
            ? Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        '',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),

                    //SizedBox(height: 30,),

                    Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var i = 0; i < _.preguntas.length; i++) ...{
                                if (_.preguntas[i].tipo_pregunta == "integer" ||
                                    _.preguntas[i].tipo_pregunta ==
                                        "decimal") ...{
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
                        )),
                    SizedBox(
                      height: 20,
                    ),
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


ImageWidget(String enunciado,
    int id_pregunta,
    VerEncuestacontroller _,
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
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _.bloque == bloque
            ? Container()
            : Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold),
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
                             "",//requerido == "true" ? " (*)" : "",
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
                      child: VerImage(
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
    VerEncuestacontroller _,
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
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),

              VerDatePicker(
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

IntegerDecimalWidget(
    String enunciado,
    int id_pregunta,
    VerEncuestacontroller _,
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
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Text(
                        '${_.bloque}',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 102, 84, 1),
                            fontWeight: FontWeight.bold),
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
                  readOnly: true,
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
                  /*onChanged: (value) {
                    _.calcular();
                  },*/
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

SelectSimpleWidget(String enunciado, int id_pregunta, VerEncuestacontroller _,
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
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold),
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
                        child: SimpleSelectVer(
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

MultiSelectWidget(String enunciado, int id_pregunta, VerEncuestacontroller _,
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
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold),
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
    VerEncuestacontroller _,
    BuildContext context,
    String numPregunta,
    String bloque,
    String bloque2,
    String maxLength,
    int i,
    String placeholder,
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
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold),
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
                        readOnly: true,
                        maxLength:
                            maxLength == null || int.parse(maxLength) == 0
                                ? 100
                                : int.parse(maxLength),
                        controller: _.controllerInput[i].controller,
                        decoration: InputDecoration(
                            hintText: placeholder == "-" || placeholder == null
                                ? 'Ingrese su respuesta'
                                : placeholder),
                        keyboardType: TextInputType.text,
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

Note(
    String enunciado,
    int id_pregunta,
    VerEncuestacontroller _,
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
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold),
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

Ubigeo(
    String enunciado,
    int id_pregunta,
    VerEncuestacontroller _,
    BuildContext context,
    String numPregunta,
    String bloque,
    String bloque2,
    int i,
    String apariencia) {
  if (_.bloque == null || _.bloque == "") {
    _.bloque = bloque2;
  } else if (_.bloque == bloque2) {
    bloque = bloque2;
  } else if (_.bloque != bloque2) {
    _.bloque = bloque2;
  }
  return UbigeoWidget(
    id_pregunta: _.preguntas[i].id_pregunta,
    enunciado: _.preguntas[i].enunciado,
    numPregunta: (i + 1).toString(),
    apariencia: apariencia,
    bloque: _.preguntas[i].bloqueDescripcion,
    i: i,
    pagina: "verEncuesta",
  );
}
