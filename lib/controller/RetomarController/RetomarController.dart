import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';
import 'package:gsencuesta/model/Tracking/TrackingModal.dart';

class RetommarController extends GetxController{

  @override
  void onInit()async{
    // TODO: implement onInit
    super.onInit();
    var data = Get.arguments;

    _titulo = data["tituloEncuesta"];
    await onloadData(data);

    /*_positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high,intervalDuration: Duration(minutes:2)).listen((Position posicion) async{ 

      print(posicion.latitude);
      print(posicion.longitude);

      await DBProvider.db.insertTracking(idFicha, posicion.latitude.toString(), posicion.longitude.toString(), 'TRUE');

      List<TrackingModel>  respuestaBd = await DBProvider.db.getAllTrackings();
      
      print(respuestaBd);

      

    });*/
     
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  String _titulo = "";
  String get titulo => _titulo;
  StreamSubscription<Position> _positionStream;

  List<OpcionesModel> _opcionesPreguntas = [];
  List<OpcionesModel> get opcionesPreguntas => _opcionesPreguntas;
  List<PreguntaModel> _preguntas = [];
  List<PreguntaModel> get preguntas => _preguntas;
  bool _isLoadingData = false;

  List<InputTextfield> _controllerInput = [];

  List<InputTextfield> get controllerInput => _controllerInput;

  bool get isLoadingData => _isLoadingData;
  

  onloadData(dynamic datos)async{

    _opcionesPreguntas = [];
    String idEncuesta = datos["idEncuesta"];
    String idFicha = datos["idFicha"];

    List<RespuestaModel> respuestas = await DBProvider.db.getAllRespuestasxEncuesta(idFicha, idEncuesta);

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

        if( int.parse(respuestas[x].idsOpcion) == _opcionesPreguntas[z].idOpcion ){

          print('pintar de verde');

          _opcionesPreguntas[z].selected = true;

        }
        
      }
      
    }

    print(_opcionesPreguntas.length);
    //update('simple');
    _isLoadingData = true;
    update();

  }



  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }


  


}

 class InputTextfield{

    String idPregunta;
    TextEditingController controller;

    InputTextfield(this.idPregunta,this.controller);

  }