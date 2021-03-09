import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/pages/quiz/QuizPage.dart';
import 'package:gsencuesta/services/apiServices.dart';

class EncuestaController extends GetxController{


  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    var data = Get.arguments;
    print(data);
    loadData(data);

  }

  ApiServices apiConexion= new ApiServices();

  String _imagePortada = "";
  String get imagePortada => _imagePortada;

  String _titulo = "";
  String get titulo => _titulo;

  String _descripcion = "";
  String get descripcion =>_descripcion;

  String _fechaInicio = "";
  String get fechaInicio => _fechaInicio;

  String _fechaFin = "";
  String get fechaFin => _fechaFin;

  String _totalPreguntas = "";
  String get totalPreguntas => _totalPreguntas;

  String _idEncuesta = "";
  String get idEncuesta => _idEncuesta;


  loadData(EncuestaModel encuesta){

    _imagePortada   = encuesta.logo;
    _descripcion    = encuesta.descripcion;
    _titulo         = encuesta.titulo;
    _fechaFin       = encuesta.fechaFin;
    _fechaInicio    = encuesta.fechaInicio;
    _idEncuesta     = encuesta.idEncuesta.toString();

    update();
    
    getPreguntas(encuesta.idEncuesta.toString());

  }

  getPreguntas(String idEncuesta)async{

    var resultado = await apiConexion.getPreguntasxEncuesta(idEncuesta);  
    var  preguntas = resultado["pregunta"];
    

  }


  navigateToQuiz(){

    Get.to(

      QuizPage(),
      arguments: _idEncuesta

    );

  }



  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


}