import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Multimedia/MultimediaModel.dart';
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';
import 'package:gsencuesta/model/Tracking/TrackingModal.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:url_launcher/url_launcher.dart';


class TabsController extends GetxController{

  final _selectIndex = 0.obs;
  get selectIndex => this._selectIndex.value;
  set selectIndex(index) => this._selectIndex.value = index;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //this.checkVersion();
    this.checkConecction();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  ApiServices apiConexion = new ApiServices();



  

  




  checkConecction()async{

    Timer.periodic(Duration(seconds: 180), (timer) async{ 
      print('hola');
      List<FichasModel> listFichas = await DBProvider.db.fichasPendientes('F');
      var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async{
      
      print(result);
      if(result == ConnectivityResult.wifi || result  == ConnectivityResult.mobile){
        
        if(listFichas.length > 0){
          print('hago la sincronización, envio las fichas al servidor');
          print(listFichas.length);
          await uploadData(listFichas);
        }else{
          print('No hay fichas para sincronizar');
        }

        print('estoy  conectado a internet');

      }else{

      }
      
    });

    });

    //List<FichasModel> listFichas = await DBProvider.db.fichasPendientes('F');
    /*var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async{
      
      print(result);
      if(result == ConnectivityResult.wifi || result  == ConnectivityResult.mobile){
        
        if(listFichas.length > 0){
          print('hago la sincronización, envio las fichas al servidor');
          print(listFichas.length);
          await uploadData(listFichas);
        }

        print('estoy  conectado a internet');

      }else{

      }
      
    });*/

  }

  uploadData(List<FichasModel> dataFichas)async{
    List data = [];
    for (var i = 0; i < dataFichas.length; i++) {
      List<RespuestaModel> listRespuestaDBlocal   =  await DBProvider.db.getAllRespuestasxFicha(dataFichas[i].idFicha.toString());
      List<TrackingModel>   listTracking          =  await DBProvider.db.getAllTrackingOfOneSurvery(dataFichas[i].idFicha.toString());
      List<MultimediaModel> listMultimedia        =  await DBProvider.db.getAllMultimediaxFicha(dataFichas[i].idFicha.toString());

      var dataEncuesta = await DBProvider.db.getOneEncuesta(dataFichas[i].idEncuesta.toString());
      print(dataEncuesta);

      DateTime now      = DateTime.now();
      var utc           = now.toUtc();
      var part          = utc.toString().split(" ");
      var fecha         = part[0].toString();
      var hora          = part[1].toString();
      String fechaFin   = fecha + "T" + hora;

      var sendFicha = {};
      sendFicha['idficha']        = dataFichas[i].idFicha;
      sendFicha['fechaFin']       = fechaFin;
      sendFicha['fechaInicio']    = dataFichas[i].fecha_inicio;
      sendFicha['idUsuario']      = dataFichas[i].idUsuario;
      sendFicha["latitud"]        = dataFichas[i].latitud;
      sendFicha["longitud"]       = dataFichas[i].longitud;
      sendFicha["observacion"]    = dataFichas[i].observacion;
      sendFicha["ubigeo"]         = dataFichas[i].ubigeo;
      sendFicha["fechaRetomo"]    = dataFichas[i].fecha_retorno == null || dataFichas[i].fecha_retorno == "null" ?  "" : dataFichas[i].fecha_retorno.toString();
      sendFicha["latitudRetomo"]  = dataFichas[i].latitud_retorno == null ? "" :dataFichas[i].latitud_retorno ;
      sendFicha["longitudRetomo"] = dataFichas[i].longitud_retorno == null ? "" : dataFichas[i].longitud_retorno;
      sendFicha["fechaEnvio"]     = fechaFin;



      var encuesta = {};
      encuesta["idEncuesta"]   = dataFichas[i].idEncuesta;
      encuesta["encuestadoIngresoManual"] = dataEncuesta[0].encuestadoIngresoManual;
      sendFicha['encuesta'] = encuesta;


      var encuestado = {};
      if(dataEncuesta[0].encuestadoIngresoManual == "true"){
        List<EncuestadoModel> dataEncuestado = await DBProvider.db.getOneEncuestado(dataFichas[i].idEncuestado.toString());
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
        sendFicha['encuestado']   = encuestado;
      }else{
        encuestado["idEncuestado"] = dataFichas[i].idEncuestado;
        sendFicha['encuestado']   = encuestado;
      }
      

      var respuesta ={};
      List<Map> listRespuestaMap = new List();

      var pregunta = {};

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
        respuesta ={};
        pregunta = {};
        
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
      }
      var multimedia = {};
      List<Map> listMultimediaMap = new List();

      for (var z = 0; z < listMultimedia.length; z++) {

        multimedia["idMultimedia"]    =   listMultimedia[z].idMultimedia;
        multimedia["latitud"]         =   listMultimedia[z].latitud;
        multimedia["longitud"]        =   listMultimedia[z].longitud;
        multimedia["url"]             =   listMultimedia[z].tipo;
        multimedia["nombre"]          =   listMultimedia[z].nombre;
        listMultimediaMap.add(
          multimedia
        );

        sendFicha['multimedia']  = listMultimediaMap;
        multimedia ={};
        
      }
      data.add(sendFicha);

    }

    if(data.length > 0){
      int contador = 0;
      loadingmodal();
      for (var x = 0; x < data.length; x++) {
        var response  = await apiConexion.sendFichaToServer(data[x]);
        Get.back();
        if(response == 2){
          showModal("Error de servidor comuniquese con el administrador del sistema.",false,"Error inesperado");
          Future.delayed(Duration(seconds: 2),(){
            Get.back();
          });
          print("error server");

        }else if(response == 3){
          print("error 404 o bad request");
          showModal("Error por parte del cliente, apunta a una ruta desconocia o envia mal los datos, comuniquese con el administrador del sistema.",false,"Error inesperado");
          Future.delayed(Duration(seconds: 2),(){
            Get.back();
          });
        }else if(response == 1){
          print("token");
          showModal("Estimado usuario su token expiro.",false,"Error inesperado");
          Future.delayed(Duration(seconds: 2),(){
            Get.back();
          });
        }else{
          var _estado = "S";
          await DBProvider.db.updateFicha( data[x]['idficha'].toString(), data[x]['observacion'], data[x]['fechaFin'],_estado,"");
          contador++;

          if(contador == data.length){
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
              //barrierDismissible: false
            );
            Future.delayed(Duration(seconds: 2),(){
              Get.back();
            });
          }
        }

      }
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

  loadingmodal()async{
    Get.dialog(
      AlertDialog(
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        title: Text('Sincronizando los datos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator()
          ],
        ),
      ),
      barrierDismissible: false
    );
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}