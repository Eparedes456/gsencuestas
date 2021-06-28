import 'dart:async';

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
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

class QuizController extends GetxController with  SingleGetTickerProviderMixin{

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

     

      await DBProvider.db.insertTracking(idFicha, posicion.latitude.toString(), posicion.longitude.toString(), 'TRUE');

      List<TrackingModel>  respuestaBd = await DBProvider.db.getAllTrackingOfOneSurvery(idFicha);
      
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

    _opcionesPreguntas = [];
    
    //var connectionInternet = await DataConnectionChecker().connectionStatus;
    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

    if( conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

      var response = await apiConexion.getPreguntasxEncuesta(idEncuesta);

      if(response != 1 && response != 2 && response  != 3){

        var data = response["pregunta"];
        

        int idPregunta;

        data.asMap().forEach((index,item){  

          idPregunta = item["idPregunta"];

          _preguntas.add(
            PreguntaModel(

              id_pregunta             : item["idPregunta"],
              id_bloque               : item["id_bloque"],
              idEncuesta              : item["id_encuesta"],
              enunciado               : item["enunciado"],
              tipo_pregunta           : item["tipoPregunta"]["questionType"],
              apariencia              : "",//item["apariencia"],
              requerido               : item["requerido"].toString(),
              requerido_msj           : item["requerido_msj"],
              readonly                : item["readonly"].toString(),
              defecto                 : item["defecto"],
              calculation             : item["calculation"],
              restriccion             : item["restriccion"],
              restriccion_msj         : item["restriccion_msj"],
              relevant                : item["relevant"],
              choice_filter           : item["choice_filter"], 
              bind_name               : item["name"],
              bind_type               : item["bindType"],
              bind_field_length       : item["bindFieldLength"].toString(),
              bind_field_placeholder  : item["bindFieldPlaceholder"],
              orden                   : item["orden"],
              estado                  : item["estado"].toString(),
              updated_at              : item["createdAt"],
              created_at              : item["updatedAt"]

            )
          );

          if(item["tipoPregunta"]["questionType"] == "note"){

            controllerInput.add(
              InputTextfield(
                item["idPregunta"].toString(),
                TextEditingController(text: "0"),
                item["name"].toString(),
                index,
                item["tipoPregunta"]["questionType"],
                item["calculation"]
              )
            );

          }else{
            controllerInput.add(
              InputTextfield(
                item["idPregunta"].toString(),
                TextEditingController(),
                item["name"].toString(),
                index,
                item["tipoPregunta"]["questionType"],
                item["calculation"]
              )
            );
          }
          
          /*if( item["tipo_pregunta"] == "IMPUTABLE" ){

            _controllerInput.add(
              InputTextfield( item["idPregunta"].toString(), TextEditingController() )
            );
            
          }*/

          print(controllerInput);
          
          List preguOpcion = item["preguntaGrupoOpcion"];

          if(preguOpcion.length > 0){

            int idPreguOpcion =  preguOpcion[0]["idPreguntaGrupoOpcion"];
            var idgrupoOpcion = preguOpcion[0]["grupoOpcion"]["idGrupoOpcion"];
            var opciones = preguOpcion[0]["grupoOpcion"]["opcion"];
            print(idgrupoOpcion);

            opciones.forEach((item2){

            _opcionesPreguntas.add(

              OpcionesModel(

                idPreguntaGrupoOpcion   : idPreguOpcion.toString(),
                idOpcion                : item2["idOpcion"],
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



          }


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

      preguntas.asMap().forEach((index,element) { 

        controllerInput.add(
          InputTextfield(
            element.id_pregunta.toString(),
            TextEditingController(),
            element.bind_name,
            index,
            element.tipo_pregunta,
            element.calculation
          )
        );

      });

      var allOpciones = await DBProvider.db.getAllOpciones();

      print(allOpciones);

      for (var i = 0; i < _preguntas.length; i++) {

        print(_preguntas[i].id_pregunta);
        var idPregunta = _preguntas[i].id_pregunta;

        //_opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

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
    
    print(opcionEscogida.idOpcion);

    opcionesPreguntas.forEach((element) async{ 

      if(element.idPregunta == opcionEscogida.idPregunta){

        element.selected = false;
        await DBProvider.db.eliminarRespuestasxFicha(opcionEscogida.idPregunta.toString(), idFicha.toString() );
      }

      //element.selected = false;
      //await DBProvider.db.eliminarRespuestasxFicha(opcionEscogida.idPregunta.toString(), idFicha.toString() );

      
      if(element.idOpcion == opcionEscogida.idOpcion){

        element.selected = true;
        await DBProvider.db.insertRespuesta(opcionEscogida.idPregunta.toString(), idFicha.toString(), opcionEscogida.idOpcion.toString(), opcionEscogida.valor);
      
      }

    });

    List<RespuestaModel> listRespuestaDB = await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());
    print(listRespuestaDB);

    update(['simple']);

  }

  capturarRespuestaMultiple(OpcionesModel opcionEscogida)async{
    print(opcionEscogida.idOpcion);
    opcionesPreguntas.forEach((element) async{
      if(element.idPregunta == opcionEscogida.idPregunta){

        if(element.idOpcion == opcionEscogida.idOpcion){
          
          if(element.selected == true){

            element.selected = false;
            await DBProvider.db.eliminarRespuestasxFicha(opcionEscogida.idPregunta.toString(), idFicha.toString() );

          }else{

            element.selected  = true;
            await DBProvider.db.insertRespuesta(opcionEscogida.idPregunta.toString(), idFicha.toString(), opcionEscogida.idOpcion.toString(), opcionEscogida.valor); 
          }

        }

      }

    });

    List<RespuestaModel> listRespuestaDB = await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());
    print(listRespuestaDB);
    update(['multiple']);
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


  guardarInput(String idPregunta,String valor)async{

    print(idPregunta);
    print(idFicha);
    print(valor);

    List<RespuestaModel> respuesta = await DBProvider.db.unaRespuestaFicha(idFicha,idPregunta);

    if(respuesta.length > 0){

      if(respuesta[0].valor != "" ){

        print("si existe la respuesta, modificar en la bd");

        await DBProvider.db.actualizarRespuestaxFicha(idPregunta,idFicha,valor);

      }

    }

    else{

      await DBProvider.db.insertRespuesta(idPregunta.toString(), idFicha.toString(), "",valor);


    }
   
    //await DBProvider.db.actualizarRespuestaxFicha();


  }



  /* guardar la ficha */

  guardarFicha()async{
    print(controllerInput.length);

    bool formValidado = true;

    for (var z = 0; z < _preguntas.length; z++) {

      if(_preguntas[z].requerido == "true" || _preguntas[z].requerido == true){

        var numPregunta = z + 1;
        if(_preguntas[z].tipo_pregunta == "integer" || _preguntas[z].tipo_pregunta == "decimmal" || _preguntas[z].tipo_pregunta == "text"){
          
          //for (var x = 0; x <= controllerInput.length ; x++) {
            //Si devuelve -1 es por que no existe el valor que se requier encontrar
            if(  controllerInput[z].idPregunta.toString()  == _preguntas[z].id_pregunta.toString()  && controllerInput[z].controller.text == ""  ){

              formValidado = false;
              print('La pregunta número $numPregunta es requerida');

              
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
                      Text('Las preguntas con asteriscos son requeridas'),
                    ],
                  ),
                )
              );

              return;

            }else{

              formValidado  = true;

            }
          
          //}

        }/*else{

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
                    Text('Las preguntas con asteriscos son requeridas'),
                  ],
                ),
              )
            );

            return;

          }else{
            formValidado  = true;
          } 

        }*/
      }
      
    }

    if(formValidado == true){
      _positionStream.cancel();
      for (var i = 0; i < controllerInput.length; i++) {

        if(controllerInput[i].controller.text == "" || controllerInput[i].controller.text == null ){

          controllerInput.removeWhere((item) => item.controller.text == "");

        }
      }
      for(var x = 0; x < controllerInput.length ; x ++){
        List<RespuestaModel> respuesta = await DBProvider.db.unaRespuestaFicha(idFicha,controllerInput[x].idPregunta);

        if(respuesta.length > 0 ){

          if(respuesta[0].valor != ""){

            print('Ya existe la pregunta en la base de datos, ahora a actulizar con el nuevo valor');
            await DBProvider.db.actualizarRespuestaxFicha(controllerInput[x].idPregunta,idFicha,controllerInput[x].controller.text);
          }
        }else{
          await DBProvider.db.insertRespuesta(controllerInput[x].idPregunta, idFicha.toString(), "",controllerInput[x].controller.text);
        }
      }

      print("Formulario validado , inputables son :" + controllerInput.length.toString());

     List<RespuestaModel> listRespuestaDBlocal = await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());
      List<TrackingModel> listtRACKING = await DBProvider.db.getAllTrackingOfOneSurvery(idFicha);
      Map sendData ={
        'idEncuesta'        : idEncuesta,
        'idEncuestado'      : idEncuestado,
        'tracking'          : listtRACKING,
        'respuestas'        : listRespuestaDBlocal,
        'idFicha'           : idFicha
      };

      print(sendData);
      
      listtRACKING = [];
      _controllerInput = [];
      _pickOpcionSimple = [];

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
                onPressed: ()async{
                  _positionStream.cancel();
                  Get.back();
                  await guardarinputBack();
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

      if(controllerInput.length > 0){

        for (var i = 0; i < controllerInput.length; i++) {

          if(controllerInput[i].controller.text == "" || controllerInput[i].controller.text == null ){

            controllerInput.removeWhere((item) => item.controller.text == "");

          }
          
        }

      }
      for (var i = 0; i < controllerInput.length; i++) {

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

    List<PreguntaModel> tempList = [];

    calcular(){
      tempList =  _preguntas.where((element) => element.tipo_pregunta.contains("note")).toList();
      print(tempList);
      List<PreguntaModel> filtered2 =  _preguntas.where((element) => element.tipo_pregunta.contains("integer") || element.tipo_pregunta.contains("decimal")).toList();
      if(tempList.length > 0){
        //print('si hay');
        tempList.forEach((item) {
          var oper1 = item.calculation.indexOf('+');
          if(oper1 != -1){
            operaSum(filtered2,item);
            
          }else if(oper1  == -1){
            var oper2 = item.calculation.indexOf('-');
            if(oper2 != -1){
              operaResta(filtered2,item);
              
            }else if(oper2 == -1){
              var oper3 = item.calculation.indexOf('*');
              if(oper3 != -1){
                operaMultiplicacion(filtered2, item);
              }else if(oper3 == -1){
                var oper4 = item.calculation.indexOf('/');
                if(oper4 != -1){
                  operaMultiplicacion(filtered2, item);
                }
              }
            }
          }
          
        });
      }


    }

  operaSum(List<PreguntaModel> filtered2,PreguntaModel item){

    var part = item.calculation.split('+');
    var total  = 0;
    part.asMap().forEach((index,partes) {
            
      List<PreguntaModel> filtered1 = _preguntas.where((data) => data.bind_name.contains(partes)).toList();
      _preguntas.asMap().forEach((index,element) { 
        if(filtered1[0].bind_name == controllerInput[index].name){
          var value1  = controllerInput[index].controller.text;
          if( value1 == "" || value1 == null){
          }else{
            total = int.parse(value1)  + total;
            print("Resultaod de la suma : $total");

          }
          List<InputTextfield> tempController =  controllerInput.where((element) => element.calculation.contains("+")).toList();
          print(tempController);
          controllerInput.asMap().forEach((index,element) { 
            if(tempController[0].calculation == element.calculation){
              element.controller.text = total.toString();
            }
          });

                
        }else{
          //print('No es ${controllerInput[index].name}');
        }

      }); 
           
            
    });
    //update();
  }

  operaResta(List<PreguntaModel> filtered2,PreguntaModel item){
    var part = item.calculation.split('-');
    var total2 = 0;
    part.asMap().forEach((index,partes) {
            
      List<PreguntaModel> filtered1 = _preguntas.where((data) => data.bind_name.contains(partes)).toList();
      _preguntas.asMap().forEach((index,element) { 
        if(filtered1[0].bind_name == controllerInput[index].name){
          var value1  = controllerInput[index].controller.text;
          if( value1 == "" || value1 == null){
          }else{
            total2 = int.parse(value1)  - total2;
            if(total2 > 0){

            }else{
              total2 = total2 *-1;
            }
            print("Resultaod de la resta : $total2");

          }
           List<InputTextfield> tempController =  controllerInput.where((element) => element.calculation.contains("-")).toList();
          print(tempController);
          controllerInput.asMap().forEach((index,element) { 
            if(tempController[0].calculation == element.calculation){
              element.controller.text = total2.toString();
            }
          });

                
        }else{
          //print('No es ${controllerInput[index].name}');
        }

      }); 
           
            
    });
    //update();


  }

  operaMultiplicacion(List<PreguntaModel> filtered2,PreguntaModel item){
    var part = item.calculation.split('*');
    var total3 = 1;
    part.asMap().forEach((index,partes) {
            
      List<PreguntaModel> filtered1 = _preguntas.where((data) => data.bind_name.contains(partes)).toList();
      _preguntas.asMap().forEach((index,element) { 
        if(filtered1[0].bind_name == controllerInput[index].name){
          var value1  = controllerInput[index].controller.text;
          if( value1 == "" || value1 == null){
          }else{
            total3 = int.parse(value1)  * total3;
            
            print("Resultaod de la multiplicacion : $total3");

          }
           List<InputTextfield> tempController =  controllerInput.where((element) => element.calculation.contains("*")).toList();
          print(tempController);
          controllerInput.asMap().forEach((index,element) { 
            if(tempController[0].calculation == element.calculation){
              element.controller.text = total3.toString();
            }
          });

                
        }else{
          //print('No es ${controllerInput[index].name}');
        }

      }); 
           
            
    });
    //update();
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
    String name;
    int    index;
    String tipo_pregunta;
    String calculation;

    InputTextfield(this.idPregunta,this.controller,this.name,this.index,this.tipo_pregunta,this.calculation);

  }