import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class QuizController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var idEncuesta = Get.arguments;
    this.getPreguntas(idEncuesta.toString());   
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  ApiServices apiConexion = new ApiServices();
  String _tipo_pregunta = 'Texto';
  String get tipo_pregunta => _tipo_pregunta;
  List<PreguntaModel> _preguntas = [];
  List<PreguntaModel> get preguntas => _preguntas;
  List<OpcionesModel> _opcionesPreguntas = [];
  List<OpcionesModel> get opcionesPreguntas => _opcionesPreguntas;



  getPreguntas(String idEncuesta)async{

    var connectionInternet = await DataConnectionChecker().connectionStatus;

    if(connectionInternet == DataConnectionStatus.connected ){

      var response = await apiConexion.getPreguntasxEncuesta(idEncuesta);

      if(response != 1 && response != 2 && response  != 3){

        var data = response["pregunta"];
        //print(response["pregunta"]);

        int idPregunta;

        data.forEach((item){

          idPregunta = item["idPregunta"];

          _preguntas.add(
            PreguntaModel(

              id_pregunta       : item["idPregunta"],
              id_bloque         : item["id_bloque"],
              idEncuesta       : item["id_encuesta"],
              enunciado         : item["enunciado"],
              tipo_pregunta     : item["tipo_pregunta"],
              apariencia        : item["apariencia"],
              requerido         : item["requerido"].toString(),
              requerido_msj     : item["requerido_msj"],
              readonly          : item["readonly"].toString(),
              defecto           : item["defecto"],
              calculation       : item["calculation"],
              restriccion       : item["restriccion"],
              restriccion_msj   : item["restriccion_msj"],
              relevant          : item["relevant"],
              choice_filter     : item["choice_filter"], 
              bind_name         : item["bind_name"],
              bind_type         : item["bind_type"],
              bind_field_length : item["bind_field_length"],
              bind_field_placeholder  : item["bind_field_placeholder"],
              orden             : item["orden"],
              estado            : item["estado"].toString(),
              updated_at        : item["createdAt"],
              created_at        : item["updatedAt"]

            )
          );
          print('hola');
          var preguOpcion = item["preguntaGrupoOpcion"];
          int idPreguOpcion =  preguOpcion[0]["idPreguntaGrupoOpcion"];
          var idgrupoOpcion = preguOpcion[0]["grupoOpcion"]["idGrupoOpcion"];
          var opciones = preguOpcion[0]["grupoOpcion"]["opcion"];
          print(idPreguOpcion);
          //print(idgrupoOpcion);
          //print(opciones);

          opciones.forEach((item2){

            _opcionesPreguntas.add(

              OpcionesModel(

                idPreguntaGrupoOpcion   : idPreguOpcion,
                id_opcion               : item2["idOpcion"],
                idPregunta              : idPregunta,
                valor                   : item2["valor"],
                label                   : item2["label"], 
                orden                   : item2["orden"],
                estado                  : item2["estado"].toString(),
                createdAt               : item2["createdAt"],
                updated_at              : item2["updatedAt"],  

              )

            );

          });
        });

        print(_opcionesPreguntas.length);
        //print(_preguntas.length);


      }else if( response == 1){

        print('Error de servidor');

      }else if(response == 2){

        print(' eRROR DE TOKEN');

      }else{

        print('Error, no existe la pagina 404');

      }


    }else{

      _preguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
      print(_preguntas);


    }

    

    

    update();

  }



    /* Image pic to camera */

  File _imagePath;
  File get imagepath => _imagePath;

  pickImage()async{

    final ImagePicker image = ImagePicker();
    PickedFile imageCapturada = await image.getImage(source: ImageSource.camera);
    _imagePath = File(imageCapturada.path);
    print(_imagePath);
    update();  

  }


  /* Obtener la ubicación del dispositivo */
  
  String _latitud = "";
  String _longitud = "";

  String get latitud  => _latitud;
  String get longitud => _longitud;

  getCurrentLocation()async{

    bool servicioEnabled;

    servicioEnabled = await Geolocator.isLocationServiceEnabled();
    modalLoading('Obteniendo las coordenas, espere por favor...');

    if(servicioEnabled == true){

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);

      _latitud = position.latitude.toString();
      _longitud = position.longitude.toString();
      
      update();
      Get.back();

    }else{

      print('Activa tu gps');

    }

  }

  modalLoading(String mensaje){
    Get.dialog(

      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

            CircularProgressIndicator(),

            SizedBox(height: 20,),

            Padding(
              padding:  EdgeInsets.only(left: 10,right: 10),
              child: Text(mensaje,textAlign: TextAlign.center,),
            )

          ],
        ),
      ),
      
    );

  }


}