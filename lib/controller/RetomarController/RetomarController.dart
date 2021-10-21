import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
import 'package:gsencuesta/model/Ubigeo/UbigeoModel.dart';
import 'package:gsencuesta/pages/Ficha/FichaPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RetommarController extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    Map data = Get.arguments;
    print(data["nombreEncuesta"]);
    _titulo = data["nombreEncuesta"];
    nombreEncuestado = data["nombreEncuestado"];
    dni = data["dni"];
    await onloadData(data);

    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high,
            intervalDuration: Duration(minutes: 2))
        .listen((Position posicion) async {
      print(posicion.latitude);
      print(posicion.longitude);

      await DBProvider.db.insertTracking(idFicha, posicion.latitude.toString(),
          posicion.longitude.toString(), 'TRUE');

      List<TrackingModel> respuestaBd = await DBProvider.db.getAllTrackings();

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

  List<OpcionesModel> opcionesHijos      = [];

  bool get isLoadingData => _isLoadingData;
  List<RespuestaModel> respuestas = [];
  String idFicha = "";
  String idEncuesta = "";
  String idEncuestado = "";

  String bloque;
  String nombreEncuestado = "";
  String dni = "";

  var requiereObservacion =false;
  var idRequierepreguntaObserva;
  var metaData;

  TextEditingController controller = new TextEditingController();

  onloadData(Map datos) async {
    _opcionesPreguntas = [];
     opcionesHijos     = [];
    idEncuesta = datos["idEncuesta"];
    idFicha = datos["idFicha"];
    List<FichasModel> ficha = await DBProvider.db.oneFicha(idFicha);
    idEncuestado = ficha[0].idEncuestado.toString();
    respuestas = await DBProvider.db.getAllRespuestasxFicha( idFicha);
    _preguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
  
    var allOpciones = await DBProvider.db.getAllOpciones();

   SharedPreferences preferences = await SharedPreferences.getInstance();
    //metaData =  json.decode( preferences.getString("metaDataUser"));




    for (var i = 0; i < _preguntas.length; i++) {
      //print(_preguntas[i].id_pregunta);
      var idPregunta = _preguntas[i].id_pregunta;

      var index = respuestas.indexWhere((element) => element.idPregunta == _preguntas[i].id_pregunta);
      print(index);
      
      if( index == -1 ){

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

      }else{

        print(respuestas[index].valor);

        controllerInput.add(
          InputTextfield(
            preguntas[i].id_pregunta.toString(),
            TextEditingController(text: respuestas[index].valor),
            preguntas[i].bind_name,
            i,
            preguntas[i].tipo_pregunta,
            preguntas[i].calculation
          )
        );
        


      }


      //_opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());
      

      var opciones =
          await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

      opciones.forEach((element) {

        if(element["padre"] == 0){

          _opcionesPreguntas.add(
          
            OpcionesModel(
              idPreguntaGrupoOpcion: element["idPreguntaGrupoOpcion"],
              idOpcion: element["id_opcion"],
              idPregunta: idPregunta,
              valor: element["valor"],
              label: element["label"],
              orden: element["orden"],
              estado: element["estado"].toString(),
              createdAt: element["createdAt"],
              updated_at: element["updatedAt"],
              selected: false,
              requiereDescripcion: element["requiereDescripcion"],
              padre                 : element["padre"],
              hijos                 : false  
            )
          );


        }else{

          opcionesHijos.add(
            OpcionesModel(

              idPreguntaGrupoOpcion : element["idPreguntaGrupoOpcion"],
              idOpcion              : element["id_opcion"],
              idPregunta            : idPregunta,
              valor                 : element["valor"],
              label                 : element["label"], 
              orden                 : element["orden"],
              estado                : element["estado"].toString(),
              createdAt             : element["createdAt"],
              updated_at            : element["updatedAt"],
              selected              : false,
              requiereDescripcion   : element["requiereDescripcion"],
              padre                 : element["padre"],
              hijos                 : false  

            )
          );


        }

        
        
      });
    }

    for (var x = 0; x < respuestas.length; x++) {
      for (var z = 0; z < _opcionesPreguntas.length; z++) {
        if (respuestas[x].idsOpcion == "") {
        } else {
          if (int.parse(respuestas[x].idsOpcion) ==
                  _opcionesPreguntas[z].idOpcion &&
              respuestas[x].idPregunta == _opcionesPreguntas[z].idPregunta) {
            print('pintar de verde');

            _opcionesPreguntas[z].selected = true;
            _opcionesPreguntas[z].valor = respuestas[x].valor;
          }
          //widgetSimpleWithOption(respuestas[x].idPregunta);
        }
      }
      
      if(respuestas[x].tipoPregunta == "Imagen"){
        
        _photoBase64 = base64Decode(respuestas[x].valor);

        imagenes.add(
          Imagelist(respuestas[x].idPregunta.toString(), _photoBase64)
        );

      }

    }
    _isLoadingData = true;
    //update();
    update(['multiple']);

    Future.delayed(Duration(seconds: 1), () async {
      await inptuData();
    });
  }

  /* Image pic to camera */  
  File _imagePath;
  List<Imagelist> imagenes = [];
  Uint8List _photoBase64;

  pickImage(String valor,String idPregunta,int i) async {
    String photoBase64 = "";
    final ImagePicker image = ImagePicker();

    if(valor == "CAMARA"){
      PickedFile imageCapturada = await image.getImage(source: ImageSource.camera,imageQuality: 65,maxHeight: 700,maxWidth: 700,);
      _imagePath = File(imageCapturada.path);

      photoBase64 = base64Encode(_imagePath.readAsBytesSync());

    }else{
      PickedFile imageCapturada = await image.getImage(source: ImageSource.gallery,imageQuality: 65,maxHeight: 700,maxWidth: 700);
      _imagePath = File(imageCapturada.path);

      photoBase64 = base64Encode(_imagePath.readAsBytesSync());
      print(photoBase64);
    }

    List<RespuestaModel> existe = await DBProvider.db.unaRespuestaFicha(idFicha, idPregunta); 
    print(existe);
    if(existe.length > 0){
      print("actualizar la respuesta");

      var resp = await DBProvider.db.actualizarRespuestaxFicha(idPregunta, idFicha, photoBase64);
      var data = await DBProvider.db.getAllRespuestas(idFicha);
      print(resp);

      imagenes.asMap().forEach((key, value) { 

        if(value.idPregunta == idPregunta){
          imagenes[key].file =  base64Decode(photoBase64);
          return false;
        }

      });
    }else{
      print("insertar nuevo valor");

      var resp = await DBProvider.db.insertRespuesta(idPregunta, idFicha, "", photoBase64, "Imagen");
      var data = await DBProvider.db.getAllRespuestas(idFicha);
      imagenes.add(
        Imagelist(
          idPregunta,
          base64Decode(photoBase64)
        ),
      );
      print(data);
    }
    print(_imagePath);
    //print(files.length);
    update(['image']);
  }

  /* */


  /*saveRequireObservacion(String id_pregunta, String  idOpcion, String valueobservacion)async{

    print(id_pregunta);
    print(idOpcion);
    print(valueobservacion);

    var data =  _opcionesPreguntas.indexWhere((element) => element.idPregunta == id_pregunta);
   

    await DBProvider.db.updateRespuesta(id_pregunta,valueobservacion);

  }*/

  saveRequireObservacion(String id_pregunta, String  idOpcion, String valueobservacion,String tipoPregunta)async{

    print(id_pregunta);
    print(idOpcion);
    print(valueobservacion);

    List<RespuestaModel> existe = await DBProvider.db.unaRespuestaFicha(idFicha, id_pregunta); 

    print(existe);
    if(existe.length == 0){

      print("insertar valor");
      await DBProvider.db.insertRespuesta(id_pregunta, idFicha, "", valueobservacion, tipoPregunta);

    }else{

      print("actualizar valor");
      await DBProvider.db.updateRespuesta(id_pregunta,valueobservacion);

    }


    //await DBProvider.db.updateRespuesta(id_pregunta,valueobservacion);

  }

  capturarRespuestaSimple(OpcionesModel opcionEscogida) async {
   


    opcionesPreguntas.forEach((element) async {
      if (element.idPregunta == opcionEscogida.idPregunta) {
        element.selected = false;
        await DBProvider.db.eliminarRespuestasxFicha(
            opcionEscogida.idPregunta.toString(), idFicha.toString(),opcionEscogida.valor);
      }

      //element.selected = false;
      //await DBProvider.db.eliminarRespuestasxFicha(opcionEscogida.idPregunta.toString(), idFicha.toString() );

      if (element.idOpcion == opcionEscogida.idOpcion &&
          element.idPregunta == opcionEscogida.idPregunta) {
        element.selected = true;
        await DBProvider.db.insertRespuesta(
            opcionEscogida.idPregunta.toString(),
            idFicha.toString(),
            opcionEscogida.idOpcion.toString(),
            opcionEscogida.valor,
            'RespuestaSimple'
        );
      }
    });

    //widgetSimpleWithOption(opcionEscogida.idPregunta);
    //update(['opciones']);
    update(['opciones']);
    /*List<RespuestaModel> listRespuestaDB =
        await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());*/
  }

  capturarRespuestaMultipleRetomar(OpcionesModel opcionEscogida) async {
  
    opcionesPreguntas.forEach((element) async {
      if (element.idPregunta == opcionEscogida.idPregunta) {
        if (element.idOpcion == opcionEscogida.idOpcion &&
            element.idPregunta == opcionEscogida.idPregunta) {
          if (element.selected == true) {
            element.selected = false;
            await DBProvider.db.eliminarRespuestasxFicha(
                opcionEscogida.idPregunta.toString(), idFicha.toString(),opcionEscogida.valor);
          } else {
            element.selected = true;
            await DBProvider.db.insertRespuesta(
                opcionEscogida.idPregunta.toString(),
                idFicha.toString(),
                opcionEscogida.idOpcion.toString(),
                opcionEscogida.valor,
                'RespuestaMultiple'
            );
          }
        }
      }
    });

    List<RespuestaModel> listRespuestaDB =
        await DBProvider.db.getAllRespuestasxFicha(idFicha);
    print(listRespuestaDB);
    update(['multiple']);
  }

  inptuData() async {
    for (var i = 0; i < respuestas.length; i++) {
      print(respuestas.length);

      for (var j = 0; j < controllerInput.length; j++) {
        if (respuestas[i].idsOpcion == "") {
          if (respuestas[i].idPregunta.toString() ==
              controllerInput[j].idPregunta) {
            controllerInput[j].controller.text = respuestas[i].valor;
          }
        }
      }
    }



    update();
  }


  widgetSimpleWithOption(int idPregunta){

      for (var i = 0; i < _opcionesPreguntas.length; i++){
                  
            if(idPregunta == _opcionesPreguntas[i].idPregunta){

              if(_opcionesPreguntas[i].selected && _opcionesPreguntas[i].requiereDescripcion == "true"){

                      Padding(
                      padding:  EdgeInsets.only(left: 20,right: 20),
                      child: TextFormField(
                        //controller: ,
                        onFieldSubmitted: (value){
                          //print(value);
                          
                        },
                        decoration: InputDecoration(
                          hintText: 'Ingrese observación'
                          
                        ),
                      ),
                    );
                    
              }
            }
          }

    
    
  }


  textFormFields(int id_pregunta){

    for (var i = 0; i < opcionesPreguntas.length; i++) {
      
      if(id_pregunta == opcionesPreguntas[i].idPregunta ){

        var index = controllerInput.indexWhere((element) => element.idPregunta == id_pregunta.toString());
        print(index);

        var index2 = respuestas.indexWhere((element2) => element2.idPregunta == id_pregunta);

        if(index2 != -1){

          return TextField(
          controller:   TextEditingController(text: respuestas[index2].valor), //controllerInput[index].controller,
          onChanged: (value){

            saveRequireObservacion(id_pregunta.toString(),"",value,"");

          },
          style: TextStyle(
          fontSize: 14
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: 'Ingrese observación',
            hintStyle: TextStyle(
              fontSize: 14
            )
                              
          ),
        );

        }else{

          return TextField(
          controller: controllerInput[index].controller,
          onChanged: (value){

            saveRequireObservacion(id_pregunta.toString(),"",value,"");

          },
          style: TextStyle(
          fontSize: 14
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: 'Ingrese observación',
            hintStyle: TextStyle(
              fontSize: 14
            )
                              
          ),
        );

        }
        
        

      }

    }

  }



  guardarFicha() async {
  

    bool formValidado = true;

    for (var z = 0; z < _preguntas.length; z++) {
      if (_preguntas[z].requerido == "true" ||
          _preguntas[z].requerido == true) {
        var numPregunta = z + 1;
        if (_preguntas[z].tipo_pregunta == "integer" ||
            _preguntas[z].tipo_pregunta == "decimmal" ||
            _preguntas[z].tipo_pregunta == "text") {
          //for (var x = 0; x <= controllerInput.length ; x++) {
          //Si devuelve -1 es por que no existe el valor que se requier encontrar
          if (controllerInput[z].idPregunta.toString() ==
                  _preguntas[z].id_pregunta.toString() &&
              controllerInput[z].controller.text == "") {
            formValidado = false;
            

         

            update();

            Get.dialog(AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text('Notificación'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.yellowAccent[700],
                    size: 70,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text('Las preguntas con asterisco son requeridas'),
                ],
              ),
            ));

            return;
          } else {
            formValidado = true;
          }

          //}

        }
        /*else{

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

        }*/

      }
    }

    if (formValidado == true) {
      _positionStream.cancel();

     


      DateTime now = DateTime.now();
      var utc = now.toUtc();

      String formatDate = DateFormat('yyyy-MM-ddHH:mm:ss').format(now);
      String hourFormat = DateFormat('HH:mm:ss').format(now);

      var part = utc.toString().split(" ");
      var fecha = part[0].toString();
      var hora = part[1].toString();

      String formattedDate = fecha + "T" + hora;
      await guardarinputBack();

      List<TrackingModel> listtRACKING =
          await DBProvider.db.getAllTrackingOfOneSurvery(idFicha);

      respuestas =
          await DBProvider.db.getAllRespuestasxFicha(idFicha);

  

      Map sendData = {
        'idEncuesta': idEncuesta,
        'idEncuestado': idEncuestado,
        'tracking': listtRACKING,
        'respuestas': respuestas,
        'idFicha': idFicha,
        'fecha_retorno': formattedDate
      };


      _positionStream.cancel();
      Get.to(FichaPage(), arguments: sendData);
    }
  }

  List<PreguntaModel> tempList = [];

  calcular() {
    tempList = _preguntas
        .where((element) => element.tipo_pregunta.contains("note"))
        .toList();

    List<PreguntaModel> filtered2 = _preguntas
        .where((element) =>
            element.tipo_pregunta.contains("integer") ||
            element.tipo_pregunta.contains("decimal"))
        .toList();
    String formula = "";
    Parser p = Parser();
    Expression exp;
    
    if (tempList.length > 0) {
      tempList.asMap().forEach((index, element) {
        formula = element.calculation;
        _preguntas.asMap().forEach((index, value) {
          if (_preguntas[index].bind_name == controllerInput[index].name) {
            var value1 = controllerInput[index].controller.text;
    
            if (value1 != null || value1 != "" || value1 != "null") {
              formula = formula.replaceAll(_preguntas[index].bind_name, value1);
              exp = p.parse(formula);
            }
          }
        });
        List<InputTextfield> templistController = controllerInput
            .where((element) => element.tipo_pregunta.contains("note"))
            .toList();
        String result = exp
            .evaluate(EvaluationType.REAL, null)
            .toString(); // if context is not available replace it with null.
        controllerInput.asMap().forEach((key, value) {
          if (templistController[index].calculation == value.calculation) {
            value.controller.text = result.toString();
          }
        });
      });
    }
  }

  pauseQuiz() async {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text('Notificación'),
      content: Text('¿Está seguro de abandonar la encuesta?'),
      actions: [
        Container(
          height: 40,
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color.fromRGBO(0, 102, 84, 1),
            onPressed: () {
              _positionStream.cancel();
              Get.back();
              guardarinputBack();
              Get.back(result: "SI");
            },
            child: Text('Si',style: TextStyle(color: Colors.white),),
          ),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(0, 102, 84, 1),
              ),
              borderRadius: BorderRadius.circular(10)),
          child: MaterialButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Continuar',
              style: TextStyle(
                color: Color.fromRGBO(0, 102, 84, 1),
              ),
            ),
          ),
        )
      ],
    ));
  }

  guardarinputBack() async {
    for (var i = 0; i < controllerInput.length; i++) {
      if (controllerInput[i].controller.text == "" || controllerInput[i].controller.text == null || controllerInput[i].tipo_pregunta == "ubigeo") {
        controllerInput.removeWhere((item) => item.controller.text == "");
        controllerInput.removeWhere((element) => element.tipo_pregunta =="ubigeo");
      }
    }

    for (var x = 0; x < controllerInput.length; x++) {
      List<RespuestaModel> respuesta = await DBProvider.db
          .unaRespuestaFicha(idFicha, controllerInput[x].idPregunta);

      if (respuesta.length > 0) {
        if (respuesta[0].valor != "") {
          
          await DBProvider.db.actualizarRespuestaxFicha(
              controllerInput[x].idPregunta,
              idFicha,
              controllerInput[x].controller.text);
        }
      } else {
        await DBProvider.db.insertRespuesta(controllerInput[x].idPregunta,
            idFicha.toString(), "", controllerInput[x].controller.text,
            'Text'
        );
      }
    }
  }


  /* UBIGEO  WIDGET */

  String _ubigeoCapturado = "";
  String _ubigeoGuardar = "";
  String get ubigeoCapturado => _ubigeoCapturado;

  String _valueDistrito;
  String get valueDistrito => _valueDistrito;

  String _valueCentroPoblado;
  String get valueCentroPoblado => _valueCentroPoblado;
  String _valueDepartamento;
  String get valueDepartamento => _valueDepartamento;

  String _valueProvincia;
  String get valueprovincia => _valueProvincia;

  List<UbigeoModel> _listprovincias = [];
  List<UbigeoModel> get listprovincias => _listprovincias;

  List<UbigeoModel> _listDistritos = [];
  List<UbigeoModel> get listDistrito => _listDistritos;

  List<UbigeoModel> _listCentrosPoblados = [];
  List<UbigeoModel> get listCentroPoblados => _listCentrosPoblados;
  List listCodDep = [];
  List listcodProvincia = [];
  List liscodDistrito = [];
  String _selectCodDepartamento = "";
  String _selectCodProvincia = "";
  String _selectCodDistritoUbigeo = "";
  String _selectCodCentroPoblado = "";

  showModalUbigeo(String idPregunta, String apariencia, int i) async {
    listCodDep = [];
    listcodProvincia = [];
    liscodDistrito = [];
    _listprovincias = [];
    _listDistritos = [];

    List<UbigeoModel> showDepartamentos = [];

    List<UbigeoModel> dataDepartamento =
        await DBProvider.db.getDepartamentos1("22");
    
    showDepartamentos.add(dataDepartamento[0]);
    _valueDepartamento = showDepartamentos[0].descripcion;
    var idDepartamento = showDepartamentos[0].codigoDepartamento;

    List<UbigeoModel> dataProvincias =
        await DBProvider.db.getAllProvincias("22");
    

    for (var i = 0; i < dataProvincias.length; i++) {
      _listprovincias.add(dataProvincias[i]);
    }

    Get.dialog(AlertDialog(
      title: Text('Seleccione el ubigeo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DEPARTAMENTO'),
          DropDownDepartamento(
            showDepartamentos: showDepartamentos,
            //dataUbi: dataUbi,
          ),
          SizedBox(
            height: 12,
          ),
          Text('PROVINCIA'),
          DropDownProvincia(
            showProvincia: _listprovincias,
            isManual: true,
            apariencia: apariencia,
            //dataUbi: dataUbi,
          ),
          SizedBox(
            height: 12,
          ),
          Text('DISTRITO'),
          DropDownDistrito(
            showDistrito: _listDistritos,
            isManual: true,
          ),
          SizedBox(
            height: 12,
          ),
          apariencia == "distrito" ? Container() : Text('CENTRO POBLADO'),
          apariencia == "distrito"
              ? Container()
              : CentroPoblado(
                  showCentroPoblado: _listCentrosPoblados,
                  isManual: true,
                ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  borderRadius: BorderRadius.circular(10)),
              height: 45,
              child: MaterialButton(
                onPressed: () async {
                  if (apariencia == "distrito") {
                    _ubigeoCapturado = _valueDepartamento +
                        "/" +
                        _valueProvincia +
                        "/" +
                        _valueDistrito;
                  } else {
                    _ubigeoCapturado = _valueDepartamento +
                        "/" +
                        _valueProvincia +
                        "/" +
                        _valueDistrito;
                  }
                  //_ubigeoCapturado = _valueDepartamento + "/" + _valueProvincia +  "/" + _valueDistrito +"/" + _valueCentroPoblado;
                  _ubigeoGuardar = "22" +
                      _selectCodProvincia +
                      _selectCodDistritoUbigeo +
                      _selectCodCentroPoblado;

                 

                  update(['ubigeo']);
                  Get.back();
                  await guardarUbigeo(idPregunta, _ubigeoGuardar,i,_ubigeoCapturado);
                },
                child: Text(
                  'Seleccionar',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  selectProvinciaManual(UbigeoModel value, String aparienciaValor) async {
    //_listCentrosPoblados = [];
    List<UbigeoModel> dataDistritos =
        await DBProvider.db.getAllDistritos(value.codigoProvincia, "22");
  
    //
    _listDistritos = [];
    dataDistritos.forEach((element) {
      _listDistritos.add(element);
    });

    if (_listDistritos.length > 0) {
      
      _selectCodProvincia = value.codigoProvincia;
      _selectCodDistritoUbigeo = _listDistritos[0].codigoDistrito;
      _valueDistrito = _listDistritos[0].descripcion;
      update(['distrito']);
      if (aparienciaValor == "distrito") {
        //_selectCodCentroPoblado == "0000";
      } else {
        await selectDistritoManual(
            value, _selectCodProvincia, _selectCodDistritoUbigeo, true);
      }
    }
    //update(['distrito']);
  }

  selectDistritoManual(UbigeoModel value, String codProvincia,
      String codDistrito, bool estado) async {
    _listCentrosPoblados = [];
    List<UbigeoModel> dataCentroPoblados = [];
    if (estado == true) {
      dataCentroPoblados = await DBProvider.db
          .getAllCentrosPoblados(codProvincia, "22", codDistrito);
    } else {
      dataCentroPoblados = await DBProvider.db.getAllCentrosPoblados(
          value.codigoProvincia, "22", value.codigoDistrito);
    }

 

    for (var i = 0; i < dataCentroPoblados.length; i++) {
      _listCentrosPoblados.add(dataCentroPoblados[i]);
    }
    //_selectCodDistritoUbigeo = value.codigoDistrito;
    _valueCentroPoblado = _listCentrosPoblados[0].descripcion;
    _selectCodCentroPoblado = _listCentrosPoblados[0].codigoCentroPoblado;
    update(['centroPoblado']);
  }

  changeDistrito(String valor) {
    _valueDistrito = valor;
    update(['distrito']);
  }

  changeProvincia(String valor) {
    _valueProvincia = valor;
    update(['provincia']);
  }

  selectedCentroPoblado(UbigeoModel value) {
    _selectCodCentroPoblado = value.codigoCentroPoblado;
  }

  changeCentroPoblado(String valor) {
    _valueCentroPoblado = valor;
    update(['centroPoblado']);
  }

  guardarUbigeo(String idPregunta, String valor, int index,String ubigeo) async {

    _controllerInput[index].controller.text = ubigeo;
    String ubigeoCodigo = valor;
    
    await DBProvider.db.insertRespuesta(idPregunta, idFicha.toString(), "", ubigeoCodigo,'Ubigeo');
    var respuesta = await DBProvider.db.getAllRespuestas(idFicha.toString());
  
  }

/* */

  /* DatePicker respuesta */

  selectDatePicker(String idpregunta, int i,BuildContext context,String tipo)async{

    if(tipo == "time"){
      final initialTime = TimeOfDay.now();
      var time = await showTimePicker(
        context: context,
        initialTime: initialTime
      );
      if(time == null){
        return null;
      }else{
        var timeMostrar = time.hour.toString()  + ":" + time.minute.toString();
        
        _controllerInput[i].controller.text = timeMostrar;
      }
      

    }else{

      final initialDate = DateTime.now();
      var data = await showDatePicker(
        context: context, 
        initialDate: initialDate, 
        firstDate: DateTime(DateTime.now().year -5), 
        lastDate: DateTime(DateTime.now().year + 5)
      );
     

      if(data == null){
        return null;
      }else {

          var dataMostrar = DateFormat('dd/MM/yyyy').format(data);
        
          
          _controllerInput[i].controller.text = dataMostrar;

      }

    }
  }
  /* */


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}

class InputTextfield {
  String idPregunta;
  TextEditingController controller;
  String name;
  int index;
  String tipo_pregunta;
  String calculation;

  InputTextfield(this.idPregunta, this.controller, this.name, this.index,
      this.tipo_pregunta, this.calculation);
}

class DropDownDepartamento extends StatelessWidget {
  final List<UbigeoModel> showDepartamentos;
  final List<String> dataUbi;
  const DropDownDepartamento({Key key, this.showDepartamentos, this.dataUbi})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String value = showDepartamentos[0].descripcion;

    return GetBuilder<RetommarController>(
      init: RetommarController(),
      id: 'departamento',
      builder: (_) => Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: DropdownButton(
          underline: Container(
            color: Colors.transparent,
          ),
          hint: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text('Seleccione un departamento'),
          ),
          isExpanded: true,
          value: _.valueDepartamento,
          items: showDepartamentos.map((value) {
            return DropdownMenuItem(
              value: value.descripcion,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.descripcion,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              onTap: () async {
                
                
              },
            );
          }).toList(),
          onChanged: (valor) {
            //_.selectdepartamento(valor);
          },
        ),
      ),
    );
  }
}

class DropDownProvincia extends StatelessWidget {
  final List<UbigeoModel> showProvincia;
  final List<String> dataUbi;
  final bool isManual;
  final String apariencia;
  const DropDownProvincia(
      {Key key,
      this.showProvincia,
      this.dataUbi,
      this.isManual,
      this.apariencia})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String value; //showProvincia[0].descripcion;

    return GetBuilder<RetommarController>(
      init: RetommarController(),
      id: 'provincia',
      builder: (_) => Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: DropdownButton(
          underline: Container(
            color: Colors.transparent,
          ),
          hint: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text('Seleccione una provincia'),
          ),
          isExpanded: true,
          value: _.valueprovincia,
          items: _.listprovincias.map((value) {
            return DropdownMenuItem(
              value: value.descripcion,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.descripcion,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              onTap: () async {
                if (isManual == true) {
                  _.selectProvinciaManual(value, apariencia);
                } else {
                  //_.selectedProvincia(dataUbi, value);
                }
              },
            );
          }).toList(),
          onChanged: (valor) {
            _.changeProvincia(valor);
          },
        ),
      ),
    );
  }
}

class DropDownDistrito extends StatelessWidget {
  final List<UbigeoModel> showDistrito;
  final List<String> dataUbi;
  final bool isManual;
  const DropDownDistrito(
      {Key key, this.showDistrito, this.dataUbi, this.isManual})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String value; //showProvincia[0].descripcion;

    return GetBuilder<RetommarController>(
      init: RetommarController(),
      id: 'distrito',
      builder: (_) => Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: DropdownButton(
          underline: Container(
            color: Colors.transparent,
          ),
          hint: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text('Seleccione un distrito'),
          ),
          isExpanded: true,
          value: _.valueDistrito,
          items: _.listDistrito.map((value) {
            return DropdownMenuItem(
              value: value.descripcion,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.descripcion,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              onTap: () async {
                if (isManual == true) {
                  _.selectDistritoManual(value, "", "", false);
                } else {
                  //_.selectedDistrito(value);
                }
              },
            );
          }).toList(),
          onChanged: (valor) {
            _.changeDistrito(valor);
          },
        ),
      ),
    );
  }
}

class CentroPoblado extends StatelessWidget {
  final List<UbigeoModel> showCentroPoblado;
  final List<String> dataUbi;
  final bool isManual;
  const CentroPoblado(
      {Key key, this.showCentroPoblado, this.dataUbi, this.isManual})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String value; //showProvincia[0].descripcion;

    return GetBuilder<RetommarController>(
      init: RetommarController(),
      id: 'centroPoblado',
      builder: (_) => Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: DropdownButton(
          underline: Container(
            color: Colors.transparent,
          ),
          hint: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text('Seleccione un centro poblado'),
          ),
          isExpanded: true,
          value: _.valueCentroPoblado,
          items: _.listCentroPoblados.map((value) {
            return DropdownMenuItem(
              value: value.descripcion,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.descripcion,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              onTap: () async {
                if (isManual == true) {
                  _.selectedCentroPoblado(value);
                } else {
                  //_.selectedDistrito(value);
                }
              },
            );
          }).toList(),
          onChanged: (valor) {
            _.changeCentroPoblado(valor);
          },
        ),
      ),
    );
  }
}


class Imagelist{

  String idPregunta;
  Uint8List file;

  Imagelist(this.idPregunta, this.file);
}