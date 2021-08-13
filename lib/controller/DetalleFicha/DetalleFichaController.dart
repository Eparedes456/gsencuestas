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
import 'package:gsencuesta/pages/MisEncuestas/ImagenesEncuestapage.dart';
import 'package:gsencuesta/pages/Retomar/RetomarEncuestaPage.dart';
import 'package:gsencuesta/pages/Tabs/Tabs.dart';
import 'package:gsencuesta/pages/VerEncuesta/VerEncuestaPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:intl/intl.dart';

import '../../database/database.dart';
import '../../database/database.dart';
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
  bool retornoEncuesta = false;
  

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
  String ubigeoFicha;
  String fecha_retorno;
  String hora_inicio;
  String hora_fin;
  String hora_retorno;
  String encuestadoIngresoManual;
  int idEncuestaSend = 0;


  getDetailFicha(idFicha)async{

    _listFichasDb = await DBProvider.db.oneFicha(idFicha);
    var dataEncuesta = await DBProvider.db.getOneEncuesta(_listFichasDb[0].idEncuesta.toString());
    print(dataEncuesta);
   
    _idFicha                = _listFichasDb[0].idFicha.toString();
    _estado                 = _listFichasDb[0].estado;
    idEncuestaSend          = _listFichasDb[0].idEncuesta;
    ubigeoFicha             = _listFichasDb[0].ubigeo;
    observacionFicha        = _listFichasDb[0].observacion; 
    encuestadoIngresoManual = dataEncuesta[0].encuestadoIngresoManual;
   
    if(_listFichasDb[0].fecha_retorno == null){
      print('no se hacer nada ');
    }else{
      retornoEncuesta   = true;
      final dateTime = DateTime.parse(_listFichasDb[0].fecha_retorno);
      final format = DateFormat('dd-MM-yyyy').format(dateTime);
      String hourFormat = DateFormat('HH:mm:ss').format(dateTime);

      /* UTC TO DATETIME*/ 
      var strToDateTime = DateTime.parse(_listFichasDb[0].fecha_retorno); //DateTime.parse(utc.toString());
      final convertLocal = strToDateTime.toLocal();
      var newFormat = DateFormat("hh:mm:ss aaa");
      String updatedDt = newFormat.format(convertLocal);
      hora_retorno = updatedDt;
      fecha_retorno     =  format;
    }

    final dateTime = DateTime.parse(_listFichasDb[0].fecha_inicio);
    final format = DateFormat('dd-MM-yyyy');
    String hourFormat = DateFormat('HH:mm:ss').format(dateTime);
    final clockString = format.format(dateTime); 
    //hora_inicio = hourFormat;

    /* UTC TO DATETIME */
    var strToDateTime = DateTime.parse(_listFichasDb[0].fecha_inicio); //DateTime.parse(utc.toString());
    final convertLocal = strToDateTime.toLocal();
    var newFormat = DateFormat("hh:mm:ss aaa");
    String updatedDt = newFormat.format(convertLocal);
    hora_inicio = updatedDt;
    _fechaInicio =  clockString;
    fechaInicioSend = _listFichasDb[0].fecha_inicio;


    dynamic dateTime2;

    if( _listFichasDb[0].fecha_fin == "NO REGISTRA" ){
      DateTime now = DateTime.now();
      var utc = now.toUtc();
      var part = utc.toString().split(" ");
      var fecha = part[0].toString();
      var hora =part[1].toString();
      
      fechaFinSend = fecha + "T" + hora;

    }else{

      dateTime2 = DateTime.parse(_listFichasDb[0].fecha_fin);
      final format3 = DateFormat('yyyy-MM-dd');
      String hourFormat = DateFormat('HH:mm:ss').format(dateTime2);
      final format2 = DateFormat('dd-MM-yyyy');
      final clockString2 = format2.format(dateTime2);
      DateTime now = DateTime.now();
      var utc = now.toUtc();
      var part = utc.toString().split(" ");
      var fecha = part[0].toString();
      var hora =part[1].toString();
      
      fechaFinSend = fecha + "T" + hora;
      _fechaFin = clockString2;

      /* UTC TO DATETIME */
      var strToDateTime = DateTime.parse(_listFichasDb[0].fecha_fin); //DateTime.parse(utc.toString());
      final convertLocal = strToDateTime.toLocal();
      var newFormat = DateFormat("hh:mm:ss aaa");
      String updatedDt = newFormat.format(convertLocal);

      hora_fin = updatedDt;

    }

    observacionFicha = _listFichasDb[0].observacion.toString();

    idUsuario = _listFichasDb[0].idUsuario.toString();
    _latitud = _listFichasDb[0].latitud.toString();
    _longitud = _listFichasDb[0].longitud.toString();
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        title: Text('Notificación'),
        content: Text('¿Esta seguro eliminar esta ficha?'),
        actions: [

          FlatButton.icon(

            color: Color.fromRGBO(0, 102, 84, 1),
            onPressed: (){
              Get.back(result: "SI");
              deleteFicha();
            },
            icon: Icon(FontAwesomeIcons.check,color: Colors.white,),
            label: Text('Si', style: TextStyle(color: Colors.white,))
          ),
          FlatButton.icon(
            color: Colors.redAccent,
            onPressed: (){
              Get.back();
            }, 
            icon: Icon(FontAwesomeIcons.timesCircle,color: Colors.white,),
            label: Text('No', style: TextStyle(color: Colors.white),)
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

  navigateToImage(){
    var data = {
      'idFicha'   : idFicha
    };
    Get.to(
      ImagenesEncuesta(),
      transition: Transition.downToUp,
      arguments: idFicha
    );

  }

  sendDataToServer()async{
    DateTime now = DateTime.now();
    var utc = now.toUtc();    
    var part = utc.toString().split(" ");
    var fecha = part[0].toString();
    var hora =part[1].toString();
    String fecha_envio =fecha + "T" + hora;
    List<FichasModel> listFichas =  await DBProvider.db.updateFechaEnvio( idFicha, fecha_envio);
    List<RespuestaModel> listRespuestaDBlocal   =  await DBProvider.db.getAllRespuestas(_idFicha);
    List<TrackingModel>   listTracking          =  await DBProvider.db.getAllTrackingOfOneSurvery(_idFicha);
    List<MultimediaModel> listMultimedia        =  await DBProvider.db.getAllMultimediaxFicha(_idFicha);

    var sendFicha ={};

    print(fechaInicioSend);
    sendFicha['idficha']        =  int.parse(_idFicha);
    sendFicha['fechaFin']       = fechaFinSend;
    sendFicha['fechaInicio']    = fechaInicioSend;
    sendFicha['idUsuario']      = int.parse(idUsuario);
    sendFicha["latitud"]        = latitud;
    sendFicha["longitud"]       = longitud;
    sendFicha["observacion"]    = observacionFicha;
    sendFicha["ubigeo"]         = ubigeoFicha;
    sendFicha["fechaRetomo"]    = listFichas[0].fecha_retorno == null || listFichas[0].fecha_retorno == "null" ?  "" : listFichas[0].fecha_retorno.toString();
    sendFicha["latitudRetomo"]  = _listFichasDb[0].latitud_retorno;
    sendFicha["longitudRetomo"] = _listFichasDb[0].longitud_retorno;
    sendFicha["fechaEnvio"]    = fecha_envio;
    
    var encuesta = {};
    encuesta["idEncuesta"]      = idEncuestaSend;
    encuesta["encuestadoIngresoManual"] = encuestadoIngresoManual;
    sendFicha['encuesta']       = encuesta;

    var encuestado = {};
    if(encuestadoIngresoManual == "true"){
      List<EncuestadoModel> dataEncuestado = await DBProvider.db.getOneEncuestado(listEncuestadoModel[0].idEncuestado);
      //print(dataEncuestado);
      for (var i = 0; i < dataEncuestado.length; i++) {
        encuestado["idEncuestado"]    = "0";
        encuestado["apellidoMaterno"] = dataEncuestado[i].apellidoMaterno;
        encuestado["apellidoPaterno"] = dataEncuestado[i].apellidoPaterno;
        encuestado["direccion"]       = dataEncuestado[i].direccion;
        encuestado["documento"] = dataEncuestado[i].documento;
        encuestado["email"] = dataEncuestado[i].email;
        encuestado["estado"] = dataEncuestado[i].estado;
        encuestado["estadoCivil"] = dataEncuestado[i].estadoCivil;
        encuestado["foto"] = dataEncuestado[i].foto;
        encuestado["idTecnico"] = dataEncuestado[i].idTecnico;
        encuestado["idUbigeo"] = dataEncuestado[i].idUbigeo;
        encuestado["nombre"] = dataEncuestado[i].nombre;
        encuestado["representanteLegal"] = dataEncuestado[i].representanteLegal;
        encuestado["sexo"] = dataEncuestado[i].sexo;
        encuestado["telefono"] = dataEncuestado[i].telefono;
        encuestado["tipoDocumento"] = "DNI";
        encuestado["tipoPersona"] = "NATURAL";
        encuestado["validadoReniec"] = dataEncuestado[i].validadoReniec;

      }
      sendFicha['encuestado'] = encuestado;

    }else{
      encuestado["idEncuestado"] = listEncuestadoModel[0].idEncuestado;
      sendFicha['encuestado']   = encuestado;
    }

    

    var respuesta ={};
    List<Map> listRespuestaMap = new List();

    var pregunta = {};
    //pregunta["idPregunta"] = "14";
    List<String> idsOpcionMultiple = [];
    var idpregunta ;
    var idRespuesta;
    var b = true;
    var preguntas = "";
    var opciones = "";
    for (var i = 0; i < listRespuestaDBlocal.length; i++) {

      if(listRespuestaDBlocal[i].tipoPregunta == "RespuestaMultiple"){

        idsOpcionMultiple.add(listRespuestaDBlocal[i].idsOpcion);
        
        opciones = listRespuestaDBlocal[i].idsOpcion + ',' + opciones ;
        idpregunta = listRespuestaDBlocal[i].idPregunta.toInt();
        idRespuesta = listRespuestaDBlocal[i].idRespuesta.toInt();

      }else{
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
      }
      
      respuesta ={};
      pregunta = {};
      
    }

    print(opciones);
    /*if(opciones.length > 0){

      pregunta['idPregunta']    = idpregunta;
      respuesta['idRespuesta']  = idRespuesta;
      respuesta['idsOpcion']    = opciones;
      respuesta["valor"]        =   "";
      respuesta["estado"]       = b;
      respuesta["pregunta"]     = pregunta;
      listRespuestaMap.add(
        respuesta
      );

    }*/

    sendFicha['respuesta']  = listRespuestaMap;
    

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
      //print('hola');
    
    }

    var multimedia = {};
    List<Map> listMultimediaMap = new List();
    if(listMultimedia.length == 0 ){
      
      sendFicha['multimedia']  = listMultimediaMap;
      sendFicha['idficha']      =  int.parse(_idFicha);
    }else{

      for (var z = 0; z < listMultimedia.length; z++) {

        multimedia["idMultimedia"]    =   listMultimedia[z].idMultimedia;
        multimedia["latitud"]         =   listMultimedia[z].latitud;
        multimedia["longitud"]        =   listMultimedia[z].longitud;
        multimedia["url"]             =   listMultimedia[z].tipo;
        multimedia["fecha_capturada"] =   listMultimedia[z].fecha_capturada;
        multimedia["nombre"]          =   listMultimedia[z].nombre;
      
      
        
        listMultimediaMap.add(
          multimedia
        );

        sendFicha['multimedia']  = listMultimediaMap;
        multimedia ={};
        //print('hola');
    
      }

    }

    print(sendFicha);

    //String body = jsonEncode(sendFicha);

    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

    if(conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

      showModal("",true,'Sincronizando datos..');

      var response  = await apiConexion.sendFichaToServer(sendFicha);
      print(response);
      if( response == 1){
        print("token");
        showModal("Estimado usuario su token expiro.",false,"Error inesperado");
        Future.delayed(Duration(seconds: 2),(){
          Get.back();
  
        });
      }else if(response == 2){
        showModal("Error de servidor comuniquese con el administrador del sistema.",false,"Error inesperado");
        Future.delayed(Duration(seconds: 2),(){
          Get.back();
          
        });
        print("error server");
      }else if( response == 3){
        print("error 404 o bad request");
        showModal("Error por parte del cliente, apunta a una ruta desconocia o envia mal los datos, comuniquese con el administrador del sistema.",false,"Error inesperado");
        Future.delayed(Duration(seconds: 2),(){
          Get.back();
     
        });
      }else{
        print('Se inserto correctamente');
        _estado = "S";
        await DBProvider.db.updateFicha(idFicha, observacion, fechaFinSend,_estado,fecha_retorno);
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