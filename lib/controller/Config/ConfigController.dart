import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../database/database.dart';
import '../../model/Ficha/FichasModel.dart';
import '../../model/Multimedia/MultimediaModel.dart';
import '../../model/Respuesta/RespuestaModel.dart';
import '../../model/Tracking/TrackingModal.dart';
import '../../services/apiServices.dart';
import '../../services/apiServices.dart';

class ConfigController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadData();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  String _cantidadFinalizadas  = "";
  String get cantidadFinalizadas => _cantidadFinalizadas;

  loadData()async{

    List<FichasModel> listFichas = await DBProvider.db.fichasPendientes('F');

    _cantidadFinalizadas = listFichas.length.toString();
    update();

  }

  sendDataToServer()async{

    Get.back();
    List data = [];
    List<FichasModel> listFichas = await DBProvider.db.fichasPendientes('F');
    ApiServices apiConexion = new ApiServices();
    

     for (var i = 0; i < listFichas.length; i++){
       
      
      List<RespuestaModel> listRespuestaDBlocal   =  await DBProvider.db.getAllRespuestasxFicha(listFichas[i].idFicha.toString());
      List<TrackingModel>   listTracking          =  await DBProvider.db.getAllTrackingOfOneSurvery(listFichas[i].idFicha.toString());
      List<MultimediaModel> listMultimedia        =  await DBProvider.db.getAllMultimediaxFicha(listFichas[i].idFicha.toString());

      DateTime now      = DateTime.now();
      var utc           = now.toUtc();
      var part          = utc.toString().split(" ");
      var fecha         = part[0].toString();
      var hora          = part[1].toString();
      String fechaFin   = fecha + "T" + hora;

      var sendFicha = {};
      sendFicha['idficha']      = listFichas[i].idFicha;
      sendFicha['fechaFin']     = fechaFin;
      sendFicha['fechaInicio']  = listFichas[i].fecha_inicio;
      sendFicha['idUsuario']    = listFichas[i].idUsuario;
      sendFicha["latitud"]      = listFichas[i].latitud;
      sendFicha["longitud"]     = listFichas[i].longitud;
      sendFicha["observacion"]  = listFichas[i].observacion;
      var encuesta = {};
      encuesta["idEncuesta"]   = listFichas[i].idEncuesta;
      sendFicha['encuesta'] = encuesta;

      var encuestado = {};
      encuestado["idEncuestado"] = listFichas[i].idEncuestado;
      sendFicha['encuestado']   = encuestado;

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
      
        listMultimediaMap.add(
          multimedia
        );

        sendFicha['multimedia']  = listMultimediaMap;
        multimedia ={};
        
      }

      data.add(sendFicha);

    };

    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

    if(data.length > 0){

      int contador = 0;
      
      if(conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){
        modal(true,false);

        for (var x = 0; x < data.length; x++) {

          
          var response  = await apiConexion.sendFichaToServer(data[x]);

          if( response != null || response != 1 || response  != 2 || response  !=3 ){

            var _estado = "S";

            
            await DBProvider.db.updateFicha( data[x]['idficha'].toString(), data[x]['observacion'], data[x]['fechaFin'],_estado);
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
                barrierDismissible: false
              );
               Future.delayed(Duration(seconds: 2),(){

                _cantidadFinalizadas = "0";

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
                  content: Text('No se pudo subir los datos, error inesperado.'),
                )
            );

          }

        
        
      }
      //aca el else
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

  }

  modal(bool isLoading,bool hayFinalizadas){
    Get.dialog(
      AlertDialog(
        title:  isLoading ? Text('Sincronizando los datos') : Text('Notificación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading ? CircularProgressIndicator() :  hayFinalizadas ? Text('¿Desea subir las $_cantidadFinalizadas fichas finalizadas?') : Text('No tiene encuestas que sincronizar.')
          ],
        ),
        actions: isLoading ? [] : hayFinalizadas ? [

          Container(
            height: 40,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: Color.fromRGBO(0, 102, 84, 1),
              onPressed: (){
                sendDataToServer();
              },
              child: Text('Subir'),
              ),
          ),

          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(0, 102, 84, 1),
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: MaterialButton(
              onPressed: (){
                Get.back();
              },
              child: Text('Cancelar',style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1), ),),
            ),
          )

        ]: [],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      ),
      
    );
  }

  exit(){
    Get.dialog(
        AlertDialog(  
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          title: Text('Notificación'),
          content: Text('¿Está seguro de cerrar la aplicación?'),
          actions: [

            Container(
              height: 40,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                color: Color.fromRGBO(0, 102, 84, 1),
                onPressed: ()async{
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text('Si'),
              ),
            ),

            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(0, 102, 84, 1),
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              child: MaterialButton(
                onPressed: (){
                  Get.back();
                },
                child: Text('Continuar',style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1), ),),
              ),
            )

          ],

        )

      );
  }

}