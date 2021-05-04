import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';

class VerEncuestacontroller extends GetxController{

  @override
  void onInit()async{
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

  List<InputTextfield> _controllerInput = [];

  List<InputTextfield> get controllerInput => _controllerInput;

  bool get isLoadingData => _isLoadingData;
  List<RespuestaModel> respuestas = [];
  String idFicha = "";
  String idEncuesta = "";
  String idEncuestado = "";


  onloadData(Map datos)async{

    _opcionesPreguntas = [];
    idEncuesta = datos["idEncuesta"];
    idFicha = datos["idFicha"];
    List <FichasModel> ficha = await DBProvider.db.oneFicha(idFicha);
    print(ficha);
    idEncuestado = ficha[0].idEncuestado.toString();
    respuestas = await DBProvider.db.getAllRespuestasxEncuesta(idFicha, idEncuesta);

    print(respuestas);

    _preguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
    print(_preguntas);

    var allOpciones = await DBProvider.db.getAllOpciones();

    print(allOpciones);

    for (var i = 0; i < _preguntas.length; i++) {

        print(_preguntas[i].id_pregunta);
        var idPregunta = _preguntas[i].id_pregunta;

        //_opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

        var opciones = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

        opciones.forEach((element){

          _opcionesPreguntas.add(

            OpcionesModel(

                idPreguntaGrupoOpcion   : element["idPreguntaGrupoOpcion"],
                idOpcion                : element["id_opcion"],
                idPregunta              : idPregunta,
                valor                   : element["valor"],
                label                   : element["label"], 
                orden                   : element["orden"],
                estado                  : element["estado"].toString(),
                createdAt               : element["createdAt"],
                updated_at              : element["updatedAt"],
                selected                : false   

              )

          );

        });
    }


    

    for (var x = 0; x < respuestas.length; x++) {

      for (var z = 0; z < _opcionesPreguntas.length; z++) {

        if( respuestas[x].idsOpcion == ""){

        }else{

          if( int.parse(respuestas[x].idsOpcion) == _opcionesPreguntas[z].idOpcion ){

            print('pintar de verde');

            _opcionesPreguntas[z].selected = true;

          }

        }
        
      }
      
    }

    
    print(_opcionesPreguntas.length);
    //update('simple');
    _isLoadingData = true;
    update();
    
    Future.delayed(Duration(seconds: 1),()async{
      await inptuData();
    });

  }

  inptuData()async{

    for (var i = 0; i < respuestas.length; i++) {
      print(respuestas.length);

      for (var j = 0; j < controllerInput.length; j++) {

        if( respuestas[i].idsOpcion == "" ){

          if(respuestas[i].idPregunta.toString() == controllerInput[j].idPregunta){

            controllerInput[j].controller.text = respuestas[i].valor;

          }

        }
        
      }

      
      
    }

    //print( "Cantidad de preguntas tipo input" + controllerInput.length.toString());

    update();

  }

  


}

class InputTextfield{

    String idPregunta;
    TextEditingController controller;

    InputTextfield(this.idPregunta,this.controller);

  }