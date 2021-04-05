import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Multimedia/MultimediaModel.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';
import 'package:gsencuesta/model/Tracking/TrackingModal.dart';
import 'package:gsencuesta/pages/Tabs/Tabs.dart';
import 'package:gsencuesta/services/apiServices.dart';

class DetalleFichaController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    _idFicha = Get.arguments;

    this.getDetailFicha(_idFicha);

  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  ApiServices apiConexion = ApiServices();

  /* Datos de la ficha */

  String _idFicha = "";
  String get idFicha  => _idFicha;
  List<FichasModel> _listFichasDb = [];
  String _estado =  "";
  String get estado => _estado;
  String _fechaInicio = "";
  String get fechaInicio => _fechaInicio;
  String _fechaFin  = "";
  String get fechaFin => _fechaFin;



  

  /* Datos del encuestado */

  List<EncuestadoModel> listEncuestadoModel = [];


  String _nombreCompleto = ""; 
  String get nombreCompleto => _nombreCompleto;

  String _numDocumento = "";
  String get numDocumento => _numDocumento;

  String _sexo = "";
  String get sexo => _sexo;

  String _direccion = "";
  String get direccion => _direccion;

  String idUsuario = "";
  String latitud = "";
  String longitud = "";
  String observacion = "";

  /* Datos de la encuestay nombre del proyecto */
  
  List<EncuestaModel> encuestaList = [];
  String _nombreEncuesta = "";
  String get nombreEncuesta => _nombreEncuesta;
  String _descripcionEncuesta = "";
  String get descripcionEncuesta => _descripcionEncuesta;

  List<ProyectoModel> proyectoList = [];
  String _nombreProyecto = "";
  String get nombreProyecto => _nombreProyecto;


  getDetailFicha(idFicha)async{

    _listFichasDb = await DBProvider.db.oneFicha(idFicha);
    
    print(_listFichasDb);
    _idFicha = _listFichasDb[0].idFicha.toString();
    _estado = _listFichasDb[0].estado;
    _fechaInicio = _listFichasDb[0].fecha_inicio;
    _fechaFin = _listFichasDb[0].fecha_fin;
    idUsuario = _listFichasDb[0].idUsuario.toString();
    latitud = _listFichasDb[0].latitud.toString();
    longitud = _listFichasDb[0].longitud.toString();
    var idEncuesta =  _listFichasDb[0].idEncuesta;


    String idEncuestado = _listFichasDb[0].idEncuestado.toString();
    listEncuestadoModel = await DBProvider.db.getOneEncuestado(idEncuestado);
    _nombreCompleto = listEncuestadoModel[0].nombre + " " + listEncuestadoModel[0].apellidoPaterno + " " + listEncuestadoModel[0].apellidoMaterno;
    _numDocumento = listEncuestadoModel[0].documento;
    _sexo = listEncuestadoModel[0].sexo;
    _direccion = listEncuestadoModel[0].direccion;


    encuestaList = await DBProvider.db.getOneEncuesta(idEncuesta.toString());
    _nombreEncuesta = encuestaList[0].titulo;
    _descripcionEncuesta = encuestaList[0].descripcion;
    String idProyecto = encuestaList[0].idProyecto;
    proyectoList = await DBProvider.db.getOneProyecto(idProyecto);
    _nombreProyecto = proyectoList[0].nombre;

    



    

    update();

  }

  modalDelete(){

    Get.dialog(
      AlertDialog(
        title: Text('Notificación'),
        content: Text('¿Esta seguro de querer eliminar esta ficha?'),
        actions: [

          FlatButton.icon(

            color: Colors.green,
            onPressed: (){

              Get.back();
              deleteFicha();
              

            },
            icon: Icon(FontAwesomeIcons.check),
            label: Text('Si')
          ),

          FlatButton.icon(
            color: Colors.redAccent,
            onPressed: (){

              Get.back();

            }, 
            icon: Icon(FontAwesomeIcons.timesCircle),
            label: Text('No')

          )

        ],
      )
    );

  }


  deleteFicha()async{

    //dialogLoading("");
    var response = await DBProvider.db.deleteOneFicha(_idFicha);

    List<FichasModel> respuesta = await DBProvider.db.oneFicha(idFicha);

    if(respuesta.length ==  0){

      print('se elimino el registro');
      Get.back(result: "SI");
      
    }

    

  }

  dialogLoading(String mensaje){

    Get.dialog(

      AlertDialog(

        title: Text(""),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

            mensaje != "" || mensaje == null ? Container() : CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(top:12),
              child: Text('Eliminando el registro ...'),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
      ),
      

    );

  }


  sendDataToServer()async{

  

    List<RespuestaModel> listRespuestaDBlocal =  await DBProvider.db.getAllRespuestasxFicha(_idFicha);
    List<TrackingModel>   listTracking         =  await DBProvider.db.getAllTrackingOfOneSurvery(_idFicha);
    List<MultimediaModel> listMultimedia       =  await DBProvider.db.getAllMultimediaxFicha(_idFicha);


    Map sendFicha ={
      //'encuestado'        :   listEncuestadoModel,
      'fechaFin'          :   _fechaFin,
      'fechaInicio'       :   _fechaInicio,
      'idFicha'           :   _idFicha,
      'idUsuario'         :   idUsuario,
      'latitud'           :   latitud,
      'longitud'          :   longitud,
      'observacion'       :   observacion,
      'multimedia'        :   listMultimedia,
      'respuesta'         :   listRespuestaDBlocal,  
      //'tracking'          :   listTracking

    };

    print(sendFicha);

    //String body = jsonEncode(sendFicha);



    var respuesta = await apiConexion.sendFichaToServer(sendFicha);



  }





}