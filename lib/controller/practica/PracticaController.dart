import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'dart:convert';

import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';

class PracticaController extends GetxController{

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    this.loadData();
  }

  List<PreguntaModel> _listPregunta = [];
  List<PreguntaModel> get listPregunta => _listPregunta;

  List<InputTextfield> _controllerInput = [];

  List<InputTextfield> get controllerInput => _controllerInput;

  loadData()async{

    var data = [
      {
          "createdAt": "2021-04-20T22:08:12.889+0000",
          "updatedAt": "2021-05-25T20:51:02.125+0000",
          "idPregunta": 32,
          "enunciado": "Ingrese la cantidad de moscas hembra",
          "tipo_pregunta": "IMPUTABLE",
          "apariencia": null,
          "requerido": true,
          "requerido_msj": "-",
          "readonly": false,
          "defecto": "-",
          "calculation": "",
          "restriccion": null,
          "restriccion_msj": null,
          "relevant": null,
          "choice_filter": null,
          "name": "hembra",
          "bindType": "number",
          "bindFieldLength": 3,
          "bindFieldPlaceholder": "-",
          "orden": 1,
          "estado": true,
          "userCreated": null,
          "userUpdated": null,
          "encuesta": null
      },
      {
          "createdAt": "2021-04-20T22:08:12.889+0000",
        "updatedAt": "2021-05-25T20:51:02.125+0000",
        "idPregunta": 32,
        "enunciado": "Ingrese la cantidad de moscas macho",
        "tipo_pregunta": "IMPUTABLE",
        "apariencia": null,
        "requerido": true,
        "requerido_msj": "-",
        "readonly": false,
        "defecto": "-",
        "calculation": "",
        "restriccion": null,
        "restriccion_msj": null,
        "relevant": null,
        "choice_filter": null,
        "name": "macho",
        "bindType": "number",
        "bindFieldLength": 3,
        "bindFieldPlaceholder": "-",
        "orden": 1,
        "estado": true,
        "userCreated": null,
        "userUpdated": null,
        "encuesta": null
      },
      {
          "createdAt": "2021-04-20T22:08:12.889+0000",
        "updatedAt": "2021-05-25T20:51:02.125+0000",
        "idPregunta": 32,
        "enunciado": "Total de moscas",
        "tipo_pregunta": "CALCULO",
        "apariencia": null,
        "requerido": true,
        "requerido_msj": "-",
        "readonly": false,
        "defecto": "-",
        "calculation": "macho+hembra",
        "restriccion": null,
        "restriccion_msj": null,
        "relevant": null,
        "choice_filter": null,
        "name": "totalmoscas",
        "bindType": "number",
        "bindFieldLength": 3,
        "bindFieldPlaceholder": "-",
        "orden": 1,
        "estado": true,
        "userCreated": null,
        "userUpdated": null,
        "encuesta": null
      }
    ];

    //print(data);
    data.forEach((element) { 
      _listPregunta.add(
        PreguntaModel(
          id_pregunta       : element["id_pregunta"],
          id_bloque         : element["id_bloque"],
          idEncuesta        : element["idEncuesta"],
          enunciado         : element["enunciado"],
          tipo_pregunta     : element["tipo_pregunta"],
          apariencia        : element["apariencia"],
          requerido         : element["requerido"].toString(),
          requerido_msj     : element["requerido_msj"],
          readonly          : element["readonly"].toString(),
          defecto           : element["defecto"],
          calculation       : element["calculation"],
          restriccion       : element["restriccion"], 
          restriccion_msj   : element["restriccion_msj"], 
          relevant          : element["relevant"], 
          choice_filter     : element["choice_filter"],
          bind_name         : element["name"], 
          bind_type         : element["bind_type"],
          bind_field_length : element["bind_field_length"],
          bind_field_placeholder  : element["bind_field_placeholder"],
          orden             : element["orden"], 
          estado            : element["estado"].toString(),
          updated_at        : element["updatedAt"],
          created_at        : element["createdAt"],
        )
      );
    });


    print(listPregunta);

    listPregunta.forEach((element) { 

      if(element.tipo_pregunta == "IMPUTABLE"){

        controllerInput.add(
          InputTextfield(
            element.id_pregunta.toString(),
            TextEditingController(),
            element.bind_name
          )

        );
        

      }

    });


    update();
  
  }
  


}

class InputTextfield{

  String idPregunta;
  TextEditingController controller;
  String name;
  InputTextfield(this.idPregunta,this.controller,this.name);

}