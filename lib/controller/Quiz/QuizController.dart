import 'dart:async';

import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';
import 'package:gsencuesta/model/Tracking/TrackingModal.dart';
import 'package:gsencuesta/pages/Ficha/FichaPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var listDataEncuesta = Get.arguments;
    idEncuesta = listDataEncuesta["idEncuesta"];
    _tituloEncuesta  = listDataEncuesta["tituloEncuesta"];
    idFicha = listDataEncuesta["idFicha"];
    idEncuestado = listDataEncuesta["idEncuestado"];
    this.getPreguntas(idEncuesta.toString());

    
    _positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high,intervalDuration: Duration(minutes:2)).listen((Position posicion) async{ 

      print(posicion.latitude);
      print(posicion.longitude);

      await DBProvider.db.insertTracking(idFicha, posicion.latitude.toString(), posicion.longitude.toString(), 'TRUE');

      List<TrackingModel>  respuestaBd = await DBProvider.db.getAllTrackings();
      
      print(respuestaBd);


    });
    

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
  String _tituloEncuesta = "";
  String get tituloEncuesta =>  _tituloEncuesta; 
  var idEncuesta;
  var idEncuestado;
  var idFicha;

  bool _isLoadingData = false;

  bool get isLoadingData => _isLoadingData;

  StreamSubscription<Position> _positionStream;





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

                idPreguntaGrupoOpcion   : idPreguOpcion.toString(),
                idOpcion               : item2["idOpcion"],
                idPregunta              : idPregunta,
                valor                   : item2["valor"],
                label                   : item2["label"], 
                orden                   : item2["orden"],
                estado                  : item2["estado"].toString(),
                createdAt               : item2["createdAt"],
                updated_at              : item2["updatedAt"],
                selected                : false   

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

      _isLoadingData = true;

    }else{

      _preguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
      print(_preguntas);

      for (var i = 0; i < _preguntas.length; i++) {

        print(_preguntas[i].id_pregunta);
        var idPregunta = _preguntas[i].id_pregunta;

        _opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

        
      }

      //_opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta);

      print(_opcionesPreguntas);

      _isLoadingData = true;

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

  /*  Obtener simple widget respuesta */

  List<OpcionesModel> _pickOpcionSimple = [];
  List<OpcionesModel> get pickOpcion => _pickOpcionSimple;

  capturarRespuestaSimple(OpcionesModel opcionEscogida)async{

    int count = 0;
    _opcionesPreguntas.forEach((element)async { 

    

      if(element.idPregunta == opcionEscogida.idPregunta){

        print(element);

        //_opcionesPreguntas[count].selected = false;

        if(element.idOpcion ==  opcionEscogida.idOpcion ){

          await DBProvider.db.insertRespuesta(opcionEscogida.idPregunta.toString(), idFicha.toString(), opcionEscogida.idOpcion.toString(), opcionEscogida.valor);

          List<RespuestaModel> listRespuestaDB = await DBProvider.db.getAllRespuestas();

          print(listRespuestaDB);

          if(opcionEscogida.selected == true){

            _pickOpcionSimple.removeWhere((element1) => element1.idOpcion == opcionEscogida.idOpcion);
            
            _opcionesPreguntas[count].selected = false; 


          }else{


            _opcionesPreguntas[count].selected = true;

            _pickOpcionSimple.add(

              OpcionesModel(

                idOpcion                  : _opcionesPreguntas[count].idOpcion,
                idPreguntaGrupoOpcion     : _opcionesPreguntas[count].idPreguntaGrupoOpcion,
                idPregunta                : _opcionesPreguntas[count].idPregunta,
                valor                     : _opcionesPreguntas[count].valor,
                label                     : _opcionesPreguntas[count].label,
                orden                     : _opcionesPreguntas[count].orden,
                estado                    : _opcionesPreguntas[count].estado,
                createdAt                 : _opcionesPreguntas[count].createdAt,
                updated_at                : _opcionesPreguntas[count].updated_at,
                selected                  : _opcionesPreguntas[count].selected = true

              )

            );


          }

          


        }


      }

      count++;

    });
    
    print(_pickOpcionSimple);

     

    update(['simple']);

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

  /* Obtener el dato de los texteditting controller */



  List<InputTextfield> _controllerInput = [];

  List<InputTextfield> get controllerInput => _controllerInput;






  /* guardar la ficha */

  guardarFicha()async{

    if( _controllerInput.length > 0 ){

      print('hay la opciones de inserciòn texto, insertar en la base de datos');

      _controllerInput.forEach((element) async{

        await DBProvider.db.insertRespuesta(element.idPregunta, idFicha, '', element.controller.text);


       });

      
      
    }else{

      print('no hay preguntas que sea n tipos inputables');

    }

    //SharedPreferences preferences = await SharedPreferences.getInstance();

    List<RespuestaModel> listRespuestaDBlocal = await DBProvider.db.getAllRespuestas();
    

    List<TrackingModel> listtRACKING = await DBProvider.db.getAllTrackings();

    print(listRespuestaDBlocal);
    print(listtRACKING);

    Map sendData ={
      'idEncuesta'      : idEncuesta,
      'idEncuestado'    : idEncuestado,
      'tracking'        : listtRACKING,
      'respuestas'      : listRespuestaDBlocal,
      'respuestas_input': _controllerInput

    };

    print(sendData);

    /*Get.to(
      FichaPage()
    );*/



  }





}

  class InputTextfield{

    String idPregunta;
    TextEditingController controller;

    InputTextfield(this.idPregunta,this.controller);

  }