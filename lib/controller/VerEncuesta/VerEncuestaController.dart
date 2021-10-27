import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';

class VerEncuestacontroller extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    Map data = Get.arguments;
    print(data["nombreEncuesta"]);
    _titulo = data["nombreEncuesta"];
    await onloadData(data);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  String _titulo = "";
  String get titulo => _titulo;

  List<OpcionesModel> _opcionesPreguntas = [];
  List<OpcionesModel> get opcionesPreguntas => _opcionesPreguntas;
  List<PreguntaModel> _preguntas = [];
  List<PreguntaModel> get preguntas => _preguntas;
  bool _isLoadingData = false;
  List<OpcionesModel> opcionesHijos      = [];


  List<InputTextfield> _controllerInput = [];

  List<InputTextfield> get controllerInput => _controllerInput;

  bool get isLoadingData => _isLoadingData;
  List<RespuestaModel> respuestas = [];
  String idFicha = "";
  String idEncuesta = "";
  String idEncuestado = "";

  String bloque;

  bool conditionalRetomarsi = false;
  bool conditionalRetomarno = false;

  List<Imagelist> imagenes =[];
  
  Uint8List _photoBase64;

  onloadData(Map datos) async {
    _opcionesPreguntas = [];
    opcionesHijos = [];
    idEncuesta = datos["idEncuesta"];
    idFicha = datos["idFicha"];
    List<FichasModel> ficha = await DBProvider.db.oneFicha(idFicha);
    print(ficha);
    idEncuestado = ficha[0].idEncuestado.toString();
    respuestas =
        await DBProvider.db.getAllRespuestasxEncuesta(idFicha, idEncuesta);

    print(respuestas);

    _preguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
    print(_preguntas);

    var allOpciones = await DBProvider.db.getAllOpciones();

    print(allOpciones);

    for (var i = 0; i < _preguntas.length; i++) {
      
      var idPregunta = _preguntas[i].id_pregunta;

        controllerInput.add(
          InputTextfield(
          preguntas[i].id_pregunta.toString(),
          TextEditingController(),
          preguntas[i].bind_name,
          i,
          preguntas[i].tipo_pregunta,
          preguntas[i].calculation)
        );


      //_opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

      var opciones =
          await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

      for (var i = 0; i < opciones.length; i++) {

        //id_opcion
       
        //print( "ID PADRE "  + element["padre"].toString() + "ID OPCION"  + element["id_opcion"].toString());
        if(opciones[i]["padre"] == 0){

          List response = await DBProvider.db.getHijosOpcion(opciones[i]["id_opcion"]);
        
          if(response.length > 0){

            _opcionesPreguntas.add(
          
              OpcionesModel(
                idPreguntaGrupoOpcion: opciones[i]["idPreguntaGrupoOpcion"],
                idOpcion: opciones[i]["id_opcion"],
                idPregunta: idPregunta,
                valor: opciones[i]["valor"],
                label: opciones[i]["label"],
                orden: opciones[i]["orden"],
                estado: opciones[i]["estado"].toString(),
                createdAt: opciones[i]["createdAt"],
                updated_at: opciones[i]["updatedAt"],
                selected: false,
                requiereDescripcion: opciones[i]["requiereDescripcion"],
                padre                 : opciones[i]["padre"],
                hijos                 : true  
              )
            );


          }else{

            _opcionesPreguntas.add(
          
              OpcionesModel(
                idPreguntaGrupoOpcion: opciones[i]["idPreguntaGrupoOpcion"],
                idOpcion: opciones[i]["id_opcion"],
                idPregunta: idPregunta,
                valor: opciones[i]["valor"],
                label: opciones[i]["label"],
                orden: opciones[i]["orden"],
                estado: opciones[i]["estado"].toString(),
                createdAt: opciones[i]["createdAt"],
                updated_at: opciones[i]["updatedAt"],
                selected: false,
                requiereDescripcion: opciones[i]["requiereDescripcion"],
                padre                 : opciones[i]["padre"],
                hijos                 : false  
              )
            );


          }


        }else{

          opcionesHijos.add(
            OpcionesModel(

              idPreguntaGrupoOpcion : opciones[i]["idPreguntaGrupoOpcion"],
              idOpcion              : opciones[i]["id_opcion"],
              idPregunta            : idPregunta,
              valor                 : opciones[i]["valor"],
              label                 : opciones[i]["label"], 
              orden                 : opciones[i]["orden"],
              estado                : opciones[i]["estado"].toString(),
              createdAt             : opciones[i]["createdAt"],
              updated_at            : opciones[i]["updatedAt"],
              selected              : false,
              requiereDescripcion   : opciones[i]["requiereDescripcion"],
              padre                 : opciones[i]["padre"],
              hijos                 : false  

            )
          );


        }

        
      }
    }

    for (var x = 0; x < respuestas.length; x++) {
      for (var z = 0; z < _opcionesPreguntas.length; z++) {

        var data = respuestas[x].idsOpcion.split('(');
        for (var i = 0; i < data.length; i++) {

          if(data[i] == ""){

          }else if( int.parse(data[i].replaceAll(")", ""))  == _opcionesPreguntas[z].idOpcion && respuestas[x].idPregunta == _opcionesPreguntas[z].idPregunta){

            _opcionesPreguntas[z].selected = true;
            _opcionesPreguntas[z].valor = respuestas[x].valor;

          }

          if(data[i] == ""){

          }else{

            var index4 = opcionesHijos.indexWhere((element) => element.idOpcion == int.parse(data[i].replaceAll(")", "")));
            if(index4 == -1){

            }else{

              opcionesHijos[index4].selected = true;
              
            }

          }
          
        }

        
      }
      
      if(respuestas[x].tipoPregunta == "Imagen"){
        
        _photoBase64 = base64Decode(respuestas[x].valor);

        imagenes.add(
          Imagelist(respuestas[x].idPregunta.toString(), _photoBase64)
        );

      }

      if(respuestas[x].tipoPregunta ==  "condicional"){

        await condicionalFirstLoad(respuestas[x].valor);

      }

    }
    
    print(imagenes);
    print(_opcionesPreguntas.length);
    //update('simple');
    _isLoadingData = true;
    update();

    Future.delayed(Duration(seconds: 1), () async {
      await inptuData();
    });
  }

  condicionalFirstLoad(String valor)async {

    if(valor == "SI" || valor == "Si"){
          conditionalRetomarsi = true;
          print("pintar el si");
    }else{
      print("pintar el si");
      conditionalRetomarno = true; 
    }
    update(["Vercondicional"]);
  }


  inptuData() async {
    for (var i = 0; i < respuestas.length; i++) {
      print(respuestas.length);

      for (var j = 0; j < controllerInput.length; j++) {
        if (respuestas[i].idsOpcion == "") {
          if (respuestas[i].idPregunta.toString() ==
              controllerInput[j].idPregunta) {
            controllerInput[j].controller.text = respuestas[i].valor;
          }
        }
      }
    }

    //print( "Cantidad de preguntas tipo input" + controllerInput.length.toString());

    update();
  }
}

class InputTextfield {
  String idPregunta;
  TextEditingController controller;
  String name;
  int index;
  String tipo_pregunta;
  String calculation;

  InputTextfield(this.idPregunta, this.controller, this.name, this.index,
      this.tipo_pregunta, this.calculation);
}


class Imagelist{
  String idPregunta;
  Uint8List file;
 

  Imagelist(this.idPregunta, this.file);
}