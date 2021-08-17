import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        appBar: AppBar(
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
        ),
        body: _.isLoadingData == true
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
                        child: SingleChildScrollView(
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
                    )),
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
              ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 18
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
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18
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
                      fontWeight: FontWeight.bold,
                      fontSize: 18
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
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18
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
                      fontWeight: FontWeight.bold,
                      fontSize: 18
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
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Text(
                        '${_.bloque}',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 102, 84, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 18
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
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18
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
    String apariencia) {
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
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Text(
                  '${_.bloque}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18
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
      ),
    ],
  );
}


