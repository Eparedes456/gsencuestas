import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';
import 'package:gsencuesta/model/Tracking/TrackingModal.dart';
import 'package:gsencuesta/pages/Ficha/FichaPage.dart';

class RetommarController extends GetxController{

  @override
  void onInit()async{
    // TODO: implement onInit
    super.onInit();
    Map data = Get.arguments;
    print(data["nombreEncuesta"]);
    _titulo = data["nombreEncuesta"];
    await onloadData(data);

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
  List<RespuestaModel> respuestas = [];
  String idFicha = "";
  String idEncuesta = "";
  String idEncuestado = "";

  onloadData(Map datos)async{

    _opcionesPreguntas = [];
    idEncuesta = datos["idEncuesta"];
    idFicha = datos["idFicha"];
    List <FichasModel> ficha = await DBProvider.db.oneFicha(idFicha);
    print(ficha);
    idEncuestado = ficha[0].idEncuestado.toString();
    respuestas = await DBProvider.db.getAllRespuestasxEncuesta(idFicha, idEncuesta);

    print(respuestas);

    _preguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
    print(_preguntas);

    var allOpciones = await DBProvider.db.getAllOpciones();

    print(allOpciones);

    for (var i = 0; i < _preguntas.length; i++) {

        print(_preguntas[i].id_pregunta);
        var idPregunta = _preguntas[i].id_pregunta;

        //_opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());
        controllerInput.add(
          InputTextfield(
            preguntas[i].id_pregunta.toString(),
            TextEditingController()
          )
        );

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

        if( respuestas[x].idsOpcion == ""){

        }else{

          if( int.parse(respuestas[x].idsOpcion) == _opcionesPreguntas[z].idOpcion ){

            print('pintar de verde');

            _opcionesPreguntas[z].selected = true;

          }

        }
        
      }
      
    }

    
    print(_opcionesPreguntas.length);
    //update('simple');
    _isLoadingData = true;
    update();
    
    Future.delayed(Duration(seconds: 1),()async{
      await inptuData();
    });

  }

  capturarRespuestaSimple(OpcionesModel opcionEscogida)async{
    
    print(opcionEscogida.idOpcion);

    opcionesPreguntas.forEach((element) async{ 

      element.selected = false;
      await DBProvider.db.eliminarRespuestasxFicha(opcionEscogida.idPregunta.toString(), idFicha.toString() );

      
      if(element.idOpcion == opcionEscogida.idOpcion){

        element.selected = true;
        await DBProvider.db.insertRespuesta(opcionEscogida.idPregunta.toString(), idFicha.toString(), opcionEscogida.idOpcion.toString(), opcionEscogida.valor);
      
      }

    });

    List<RespuestaModel> listRespuestaDB = await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());
    print(listRespuestaDB);

    update(['simple']);

  }


  inptuData()async{

    for (var i = 0; i < respuestas.length; i++) {
      print(respuestas.length);

      for (var j = 0; j < controllerInput.length; j++) {

        if( respuestas[i].idsOpcion == "" ){

          if(respuestas[i].idPregunta.toString() == controllerInput[j].idPregunta){

            controllerInput[j].controller.text = respuestas[i].valor;

          }

        }
        
      }

      
      
    }

    //print( "Cantidad de preguntas tipo input" + controllerInput.length.toString());

    update();

  }

  guardarFicha()async{

    //List<RespuestaModel> listRespuestaDBlocal = await DBProvider.db.getAllRespuestas();

    /*if(controllerInput.length > 0){

      for (var i = 0; i < controllerInput.length; i++) {

        if(controllerInput[i].controller.text == "" || controllerInput[i].controller.text == null ){

          controllerInput.removeWhere((item) => item.controller.text == "");

        }
        
      }

    }*/

    print(controllerInput.length);
    bool formValidado = true;

    for (var z = 0; z < _preguntas.length; z++) {

      if(_preguntas[z].requerido == "true" || _preguntas[z].requerido == true){

        var numPregunta = z + 1;
        if(_preguntas[z].tipo_pregunta =="IMPUTABLE"){
          
          for (var x = 0; x <= controllerInput.length ; x++) {
            //Si devuelve -1 es por que no existe el valor que se requier encontrar
            if( /*controllerInput.indexWhere((element) => element.idPregunta == _preguntas[z].id_pregunta.toString()) == -1*/  controllerInput[z].idPregunta.toString()  == _preguntas[z].id_pregunta.toString() && controllerInput[z].controller.text == ""  ){

              formValidado = false;
              print('La pregunta número $numPregunta es requerida');

              //_controllerInput = [];
              /*_preguntas.forEach((element) { 

                _controllerInput.add(
                  InputTextfield(
                    element.id_pregunta.toString(),
                    TextEditingController()
                  )
                );

              });*/
              print(controllerInput.length);

              update();

              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  title: Text('Notificación'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,color: Colors.yellowAccent[700],size: 70,),
                      SizedBox(height: 12,),
                      Text('Las preguntas con asterisco son requeridas'),
                    ],
                  ),
                )
              );

              return;

            }else{

              formValidado  = true;
              
            }
          
          }

        }else{

          List<RespuestaModel> respuesta = await DBProvider.db.unaRespuestaFicha(idFicha,_preguntas[z].id_pregunta.toString());

          if(respuesta.length == 0){
           
            print("La pregunta número $numPregunta es requerido");
            formValidado = false;
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                title: Text('Notificación'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,color: Colors.yellowAccent[700],size: 70,),
                    SizedBox(height: 12,),
                    Text('Las preguntas con asterisco son requeridas'),
                  ],
                ),
              )
            );

            return;

          } 

        }     

      }

      
    }

    if(formValidado == true){

      await guardarinputBack();

      List<TrackingModel> listtRACKING = await DBProvider.db.getAllTrackingOfOneSurvery(idFicha);

      respuestas = await DBProvider.db.getAllRespuestasxEncuesta(idFicha, idEncuesta);


      print(respuestas);
      print(listtRACKING);

      Map sendData ={

        'idEncuesta'        : idEncuesta,
        'idEncuestado'      : idEncuestado,
        'tracking'          : listtRACKING,
        'respuestas'        : respuestas,
        'idFicha'           : idFicha

      };
      //print(sendData);

      _positionStream.cancel();
      Get.to(
        FichaPage(),
        arguments: 
        sendData
      );

    }


    

  }

  pauseQuiz()async{

      Get.dialog(
        AlertDialog(  
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          title: Text('Notificación'),
          content: Text('¿Está seguro de abandonar la encuesta?'),
          actions: [

            Container(
              height: 40,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                color: Color.fromRGBO(0, 102, 84, 1),
                onPressed: (){
                  _positionStream.cancel();
                  Get.back();
                  guardarinputBack();
                  Get.back(
                    result: "SI"
                  );

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

  guardarinputBack()async{

      
      for (var i = 0; i < controllerInput.length; i++) {

        if(controllerInput[i].controller.text == "" || controllerInput[i].controller.text == null ){

          controllerInput.removeWhere((item) => item.controller.text == "");

        }

        List<RespuestaModel> respuesta = await DBProvider.db.unaRespuestaFicha(idFicha,controllerInput[i].idPregunta);

        if(respuesta.length > 0 ){

          if(respuesta[0].valor != ""){

            print('Ya existe la pregunta en la base de datos, ahora a actulizar con el nuevo valor');
            await DBProvider.db.actualizarRespuestaxFicha(controllerInput[i].idPregunta,idFicha,controllerInput[i].controller.text);


          }

        }else{

          await DBProvider.db.insertRespuesta(controllerInput[i].idPregunta, idFicha.toString(), "",controllerInput[i].controller.text);

        }

      }

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