import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';

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




  loadData(EncuestaModel encuesta){

    _imagePortada   = encuesta.logo;
    _descripcion    = encuesta.descripcion;
    _titulo         = encuesta.titulo;
    _fechaFin       = encuesta.fechaFin;
    _fechaInicio    = encuesta.fechaInicio;

    update();
  

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