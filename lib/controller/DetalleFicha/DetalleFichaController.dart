import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:gsencuesta/pages/Maps/GoogleMaps.dart';
import 'package:gsencuesta/pages/Retomar/RetomarEncuestaPage.dart';
import 'package:gsencuesta/pages/Tabs/Tabs.dart';
import 'package:gsencuesta/pages/VerEncuesta/VerEncuestaPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import '../../model/Tracking/TrackingModal.dart';
import '../../model/Tracking/TrackingModal.dart';

class DetalleFichaController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    var data = Get.arguments;
    _idFicha  = data[0];
    _nroPreguntas = data[1];
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
  String _nroPreguntas = "";
  String get nroPreguntas => _nroPreguntas;

  List<TrackingModel> _listTracking = [];
  List<TrackingModel> get listTracking => _listTracking;
  

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
  String _latitud = "";
  String  get latitud => _latitud;
  String _longitud = "";
  String get longitud => _longitud;
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

  String fechaInicioSend;
  String fechaFinSend;
  String observacionFicha;

  int idEncuestaSend = 0;


  getDetailFicha(idFicha)async{

    _listFichasDb = await DBProvider.db.oneFicha(idFicha);
    
    print(_listFichasDb);
    _idFicha = _listFichasDb[0].idFicha.toString();
    _estado = _listFichasDb[0].estado;
    idEncuestaSend = _listFichasDb[0].idEncuesta;

    final dateTime = DateTime.parse(_listFichasDb[0].fecha_inicio);
    final format = DateFormat('dd-MM-yyyy');
    final clockString = format.format(dateTime); 

    _fechaInicio =  clockString;
    fechaInicioSend = _listFichasDb[0].fecha_inicio;

    dynamic dateTime2;

    if( _listFichasDb[0].fecha_fin == "NO REGISTRA" ){

      fechaFinSend = "2021-05-12";

    }else{

      dateTime2 = DateTime.parse(_listFichasDb[0].fecha_fin);
      final format3 = DateFormat('yyyy-MM-dd');
      fechaFinSend = format3.format(dateTime2);
      final format2 = DateFormat('dd-MM-yyyy');
      final clockString2 = format2.format(dateTime2); 

      _fechaFin = clockString2;

    }

    

    
    


    observacionFicha = _listFichasDb[0].observacion.toString();




    idUsuario = _listFichasDb[0].idUsuario.toString();
    _latitud = _listFichasDb[0].latitud.toString();
    _longitud = _listFichasDb[0].longitud.toString();
    var idEncuesta =  _listFichasDb[0].idEncuesta;

    
    

    print(dateTime);

    
    print(clockString);

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

              Get.back(result: "SI");
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

  navigateToMaps()async{

    _listTracking = await DBProvider.db.getAllTrackingOfOneSurvery(idFicha);

    print(_listTracking);

    Get.to(
      GoogleMaps(),
      arguments: _listTracking 
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

  navigateToRetomarEncuesta(){
    
    var data = {
      'idFicha'         : idFicha,
      'nombreEncuesta'  : nombreEncuesta,
      'idEncuesta'      : idEncuestaSend.toString()
    };

    Get.to(RetomarEncuestaPage(),
      arguments: data
    
    );

  }

  navigateToVer(){
    var data = {
      'idFicha'         : idFicha,
      'nombreEncuesta'  : nombreEncuesta,
      'idEncuesta'      : idEncuestaSend.toString()
    };

    Get.to(VerEncuestaPage(),
      arguments: data
    
    );

  }


  sendDataToServer()async{

  

    List<RespuestaModel> listRespuestaDBlocal   =  await DBProvider.db.getAllRespuestasxFicha(_idFicha);
    List<TrackingModel>   listTracking          =  await DBProvider.db.getAllTrackingOfOneSurvery(_idFicha);
    List<MultimediaModel> listMultimedia        =  await DBProvider.db.getAllMultimediaxFicha(_idFicha);



    var sendFicha ={
      

    };

    sendFicha['idficha']      =  int.parse(_idFicha);
    sendFicha['fechaFin']     = fechaFinSend;
    sendFicha['fechaInicio']  = fechaInicioSend;
    sendFicha['idUsuario']    = int.parse(idUsuario);
    sendFicha["latitud"]      = latitud;
    sendFicha["longitud"]     = longitud;
    sendFicha["observacion"]  = observacionFicha;
    var encuesta = {};
    encuesta["idEncuesta"]   = idEncuestaSend;
    sendFicha['encuesta'] = encuesta;

    var encuestado = {};
    encuestado["idEncuestado"] = listEncuestadoModel[0].idEncuestado;
    sendFicha['encuestado']   = encuestado;

    var respuesta ={};
    List<Map> listRespuestaMap = new List();

    var pregunta = {};
    //pregunta["idPregunta"] = "14";

    for (var i = 0; i < listRespuestaDBlocal.length; i++) {

      bool b = listRespuestaDBlocal[i].estado.toLowerCase() == 'true';
      pregunta["idPregunta"] = listRespuestaDBlocal[i].idPregunta.toInt();

      respuesta["idRespuesta"]  =   listRespuestaDBlocal[i].idRespuesta.toInt();
      respuesta["idsOpcion"]    =   listRespuestaDBlocal[i].idsOpcion;
      respuesta["valor"]        =   listRespuestaDBlocal[i].valor;
      respuesta["estado"]       =   b; //listRespuestaDBlocal[i].estado;
      respuesta["pregunta"]     =   pregunta;
        
      listRespuestaMap.add(
        respuesta
      );

      sendFicha['respuesta']  = listRespuestaMap;
      print(sendFicha);
      respuesta ={};
      pregunta = {};
      //print('hola');
    
    }

    var tracking = {};
    List<Map> listTrackingMap = new List();

    for (var i = 0; i < listTracking.length; i++) {
      bool b = listTracking[i].estado.toLowerCase() == 'true';

      tracking["idTracking"]      =   listTracking[i].idTracking;
      tracking["latitud"]         =   listTracking[i].latitud;
      tracking["longitud"]        =   listTracking[i].longitud;
      tracking["estado"]          =   b;   //listTracking[x].estado;
        
      listTrackingMap.add(
        tracking
      );

      sendFicha['tracking']  = listTrackingMap;
      tracking ={};
      print('hola');
    
    }

    var multimedia = {};
    List<Map> listMultimediaMap = new List();

    for (var z = 0; z < listMultimedia.length; z++) {

      multimedia["idMultimedia"]    =   listMultimedia[z].idMultimedia;
      multimedia["latitud"]         =   listMultimedia[z].latitud;
      multimedia["longitud"]        =   listMultimedia[z].longitud;
      multimedia["url"]             =   listMultimedia[z].tipo;
      
      
        
      listMultimediaMap.add(
        multimedia
      );

      sendFicha['multimedia']  = listMultimediaMap;
      multimedia ={};
      print('hola');
    
    }

    print(sendFicha);

    //String body = jsonEncode(sendFicha);

    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

    if(conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

      showModal("",true,'Sincronizando datos..');

      var response  = await apiConexion.sendFichaToServer(sendFicha);

      if( response != null || response != 1 || response  != 2 || response  !=3 ){

        print('se inserto correctamente'); 
        _estado = "S";

        await DBProvider.db.updateFicha(idFicha, observacion, fechaFinSend,_estado);

        Get.back();

        Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  //title: Text('Notificación'),
                  content:  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline,color: Colors.green,size: 60,),
                      SizedBox(height: 8,),
                      Text('Los datos se subieron exitosamente.',textAlign: TextAlign.justify,),
                    ],
                  ),
                ),
                barrierDismissible: false
              );

                Future.delayed(Duration(seconds: 2),(){
                  Get.back();
                  update();
                });
        

      }else{

        print('Algo ocurrio en el server');

        showModal("No se pudo sincronizar los datos.",false,"Error inesperado");

      }


    }else{

      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          title: Text('Notificación'),
          content: Text('Usted no cuenta con conexión a internet, vuelva intentarlo más tarde'),
        )
      );

    }


    



  }

  showModal(String mensaje, bool loading, String titulo){

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        title: Text(titulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            loading == true ? 
            CircularProgressIndicator() : Container(),

            SizedBox(height: 8,),

            mensaje == "" || mensaje == null ? Container(): Text(mensaje)

          ],
        ),
      )
    );


  }





}