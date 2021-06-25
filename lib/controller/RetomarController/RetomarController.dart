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
import 'package:intl/intl.dart';

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
    respuestas = await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());

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
            TextEditingController(),
            preguntas[i].bind_name,
            i,
            preguntas[i].tipo_pregunta,
            preguntas[i].calculation
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
    update(['multiple']);
    
    Future.delayed(Duration(seconds: 1),()async{
      await inptuData();
    });

  }

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

  capturarRespuestaMultipleRetomar(OpcionesModel opcionEscogida)async{
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

    
    print(controllerInput.length);

    bool formValidado = true;

    for (var z = 0; z < _preguntas.length; z++) {

      if(_preguntas[z].requerido == "true" || _preguntas[z].requerido == true){

        var numPregunta = z + 1;
        if(_preguntas[z].tipo_pregunta == "integer" || _preguntas[z].tipo_pregunta == "decimmal" || _preguntas[z].tipo_pregunta == "text"){
          
          for (var x = 0; x <= controllerInput.length ; x++) {
            //Si devuelve -1 es por que no existe el valor que se requier encontrar
            if( controllerInput[z].idPregunta.toString()  == _preguntas[z].id_pregunta.toString() && controllerInput[z].controller.text == ""  ){

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
      DateTime now = DateTime.now();
      var utc = now.toUtc();
      
      String formatDate = DateFormat('yyyy-MM-ddHH:mm:ss').format(now);
      String hourFormat = DateFormat('HH:mm:ss').format(now);
      
      var part = utc.toString().split(" ");
      var fecha = part[0].toString();
      var hora =part[1].toString();
      print(part[1]);
      String formattedDate =fecha + "T" + hora;
      await guardarinputBack();

      List<TrackingModel> listtRACKING = await DBProvider.db.getAllTrackingOfOneSurvery(idFicha);

      respuestas = await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());


      print(respuestas);
      print(listtRACKING);

      Map sendData ={

        'idEncuesta'        : idEncuesta,
        'idEncuestado'      : idEncuestado,
        'tracking'          : listtRACKING,
        'respuestas'        : respuestas,
        'idFicha'           : idFicha,
        'fecha_retorno'     : formattedDate

      };
      print(sendData);

      _positionStream.cancel();
      Get.to(
        FichaPage(),
        arguments: 
        sendData
      );

    }


    

  }

  List<PreguntaModel> tempList = [];

  calcular(){
      tempList =  _preguntas.where((element) => element.tipo_pregunta.contains("note")).toList();
      //print(tempList);
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
                  //operaMultiplicacion(filtered2, item);
                }
              }
            }
          }
          
        });
      }


  }

  operaSum(List<PreguntaModel> filtered3,PreguntaModel item){

    var part = item.calculation.split('+');
    var total  = 0;
    part.forEach((partes) {
      print(partes);
      /*List<PreguntaModel> filtered2 = _preguntas.where((element) => element.bind_name ==  partes).toList();
      print(filtered2);*/
      List<PreguntaModel> filtered1 = _preguntas.where((element) => element.bind_name.contains(partes)).toList();
      //print(filtered2);
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
      }

      for (var x = 0; x < controllerInput.length; x++) {
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