import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
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
import 'package:gsencuesta/services/apiServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';



class QuizController extends GetxController with SingleGetTickerProviderMixin {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var listDataEncuesta = Get.arguments;
    idEncuesta = listDataEncuesta["idEncuesta"];
    _tituloEncuesta = listDataEncuesta["tituloEncuesta"];
    idFicha = listDataEncuesta["idFicha"];
    idEncuestado = listDataEncuesta["idEncuestado"];
    EncuestadoModel datasa = listDataEncuesta["encuestado"];
    print(listDataEncuesta["encuestado"]);
    print(datasa.nombre);

    encuestadoNombreCompleto = datasa.nombre + " " + datasa.apellidoPaterno  + " " + datasa.apellidoMaterno;
    numDOCUMENTO = datasa.documento;
    direccionReniec = datasa.direccion;


    this.getPreguntas(idEncuesta.toString());

    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.high,
            intervalDuration: Duration(minutes: 2))
        .listen((Position posicion) async {
      await DBProvider.db.insertTracking(idFicha, posicion.latitude.toString(),
          posicion.longitude.toString(), 'TRUE');
      List<TrackingModel> respuestaBd =
          await DBProvider.db.getAllTrackingOfOneSurvery(idFicha);
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
  String get tituloEncuesta => _tituloEncuesta;
  var idEncuesta;
  var idEncuestado;
  var idFicha;


  /* Datos del encuestado reiniec */

  String encuestadoNombreCompleto = "";
  String numDOCUMENTO = "";
  String direccionReniec  = "";


  /* */



  String bloque;

  bool _isLoadingData = false;

  bool get isLoadingData => _isLoadingData;

  StreamSubscription<Position> _positionStream;

  getPreguntas(String idEncuesta) async {
    _opcionesPreguntas = [];
    _preguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
    print(_preguntas);

    preguntas.asMap().forEach((index, element) {
      controllerInput.add(InputTextfield(
          element.id_pregunta.toString(),
          element.defecto == "" || element.defecto == null || element.defecto == "-" || element.defecto == "."? TextEditingController() : TextEditingController(text: element.defecto),
          element.bind_name,
          index,
          element.tipo_pregunta,
          element.calculation));
    });

    var allOpciones = await DBProvider.db.getAllOpciones();

    print(allOpciones);

    for (var i = 0; i < _preguntas.length; i++) {
      print(_preguntas[i].id_pregunta);
      var idPregunta = _preguntas[i].id_pregunta;

      //_opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

      var opciones =
          await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

      opciones.forEach((element) {
        _opcionesPreguntas.add(OpcionesModel(
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
            requiereDescripcion: element["requiereDescripcion"]));
      });
    }
    print(_opcionesPreguntas);

    _isLoadingData = true;

    //}

    update();
  }

  /* Image pic to camera */

  File _imagePath;
  File get imagepath => _imagePath;

  List<Imagelist> files = [];

  pickImage(String valor,String idPregunta,int i) async {
    String photoBase64 = "";
    final ImagePicker image = ImagePicker();

    if(valor == "CAMARA"){
      PickedFile imageCapturada = await image.getImage(source: ImageSource.camera,imageQuality: 50,maxHeight: 500,maxWidth: 500,);
      _imagePath = File(imageCapturada.path);

      photoBase64 = base64Encode(_imagePath.readAsBytesSync());

    }else{
      PickedFile imageCapturada = await image.getImage(source: ImageSource.gallery,imageQuality: 50,maxHeight: 500,maxWidth: 500);
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
      files.asMap().forEach((key, value) { 

        if(value.idPregunta == idPregunta){
          files[key].file =  _imagePath;
          return false;
        }

      });

      


    }else{
      print("insertar nuevo valor");

      var resp = await DBProvider.db.insertRespuesta(idPregunta, idFicha, "", photoBase64, "Imagen");
      var data = await DBProvider.db.getAllRespuestas(idFicha);
      files.add(
        Imagelist(
          idPregunta,
          _imagePath
        ),
      );
      print(data);
    }
    print(_imagePath);
    print(files.length);
    update(['image']);
  }

  /* */

  /* Obtener la ubicación del dispositivo */

  String _latitud = "";
  String _longitud = "";

  String get latitud => _latitud;
  String get longitud => _longitud;

  getCurrentLocation() async {
    bool servicioEnabled;

    servicioEnabled = await Geolocator.isLocationServiceEnabled();
    modalLoading('Obteniendo las coordenas, espere por favor...');

    if (servicioEnabled == true) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);

      _latitud = position.latitude.toString();
      _longitud = position.longitude.toString();

      update();
      Get.back();
    } else {
      print('Activa tu gps');
    }
  }

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
        print(timeMostrar);
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
          print(dataMostrar);
          
          _controllerInput[i].controller.text = dataMostrar;

      }

    }
  }
  /* */



  /*  Obtener simple widget respuesta */

  List<OpcionesModel> _pickOpcionSimple = [];
  List<OpcionesModel> get pickOpcion => _pickOpcionSimple;
  var requiereObservacion =false;
  var idRequierepreguntaObserva;

  capturarRespuestaSimple(OpcionesModel opcionEscogida) async {
    print(opcionEscogida.idOpcion);

    opcionesPreguntas.forEach((element) async {
      if (element.idPregunta == opcionEscogida.idPregunta) {
        element.selected = false;
        await DBProvider.db.eliminarRespuestasxFicha(
            opcionEscogida.idPregunta.toString(), idFicha.toString());
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

    List<RespuestaModel> listRespuestaDB =
        await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());
    print(listRespuestaDB);

    if (opcionEscogida.requiereDescripcion == "true") {
      print('dibujar una caja de texto');
      idRequierepreguntaObserva = opcionEscogida.idPregunta;
      requiereObservacion = true;

    }

    update(['simple']);
  }

  saveRequireObservacion(String id_pregunta, String  idOpcion, String valueobservacion)async{

    print(id_pregunta);
    print(idOpcion);
    print(valueobservacion);

    await DBProvider.db.updateRespuesta(id_pregunta,valueobservacion);

  }
  
  List<String> idsOpcion = [];
  /*  Obtener respuesta multiple widget  respuesta */

  capturarRespuestaMultiple(OpcionesModel opcionEscogida) async {
    print(opcionEscogida.idOpcion);
    opcionesPreguntas.forEach((element) async {
      if (element.idPregunta == opcionEscogida.idPregunta) {
        if (element.idOpcion == opcionEscogida.idOpcion &&
            element.idPregunta == opcionEscogida.idPregunta) {
          if (element.selected == true) {
            element.selected = false;
            await DBProvider.db.eliminarRespuestasxFicha(
                opcionEscogida.idPregunta.toString(), idFicha.toString());
          } else {
            element.selected = true;
            idsOpcion.add(element.idOpcion.toString());
            print(idsOpcion);

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
        await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());
    print(listRespuestaDB);
    update(['multiple']);
  }

  modalLoading(String mensaje) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                mensaje,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  /* Obtener el dato de los texteditting controller */

  List<InputTextfield> _controllerInput = [];

  List<InputTextfield> get controllerInput => _controllerInput;

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
    print(dataDepartamento[0].descripcion);
    showDepartamentos.add(dataDepartamento[0]);
    _valueDepartamento = showDepartamentos[0].descripcion;
    var idDepartamento = showDepartamentos[0].codigoDepartamento;

    List<UbigeoModel> dataProvincias =
        await DBProvider.db.getAllProvincias("22");
    print(dataProvincias.length);

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

                  print(_ubigeoCapturado);
                  print(_ubigeoGuardar);


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
    //print(dataDistritos.length);
    //
    _listDistritos = [];
    dataDistritos.forEach((element) {
      _listDistritos.add(element);
    });

    if (_listDistritos.length > 0) {
      print(_listDistritos.length);
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

    //print(dataCentroPoblados.length);

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
    print('Ubigeo' + ubigeoCodigo);
    await DBProvider.db.insertRespuesta(idPregunta, idFicha.toString(), "", ubigeoCodigo,'Ubigeo');
    var respuesta = await DBProvider.db.getAllRespuestas(idFicha.toString());
    print(respuesta);
  }

/* */

  guardarInput(String idPregunta, String valor) async {
    print(idPregunta);
    print(idFicha);
    print(valor);

    List<RespuestaModel> respuesta =
        await DBProvider.db.unaRespuestaFicha(idFicha, idPregunta);

    if (respuesta.length > 0) {
      if (respuesta[0].valor != "") {
        print("si existe la respuesta, modificar en la bd");

        await DBProvider.db
            .actualizarRespuestaxFicha(idPregunta, idFicha, valor);
      }
    } else {
      await DBProvider.db.insertRespuesta(
          idPregunta.toString(), idFicha.toString(), "", valor,'Text');
    }
  }

  /* guardar la ficha */

  guardarFicha() async {
    print(controllerInput.length);

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
            print('La pregunta número $numPregunta es requerida');

            print(controllerInput.length);

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
                  Text('Las preguntas con asteriscos son requeridas'),
                ],
              ),
            ));

            return;
          } else {
            formValidado = true;
          }

      

        }
       
      }
    }

    if (formValidado == true) {
      _positionStream.cancel();
      for (var i = 0; i < controllerInput.length; i++) {
        if (controllerInput[i].controller.text == "" ||
            controllerInput[i].controller.text == null || controllerInput[i].tipo_pregunta == "ubigeo") {
          controllerInput.removeWhere((item) => item.controller.text == "");
          controllerInput.removeWhere((element) => element.tipo_pregunta =="ubigeo");
        }
      }
      for (var x = 0; x < controllerInput.length; x++) {
        List<RespuestaModel> respuesta = await DBProvider.db
            .unaRespuestaFicha(idFicha, controllerInput[x].idPregunta);

        if (respuesta.length > 0) {
          if (respuesta[0].valor != "") {
            print(
                'Ya existe la pregunta en la base de datos, ahora a actulizar con el nuevo valor');
            await DBProvider.db.actualizarRespuestaxFicha(
                controllerInput[x].idPregunta,
                idFicha,
                controllerInput[x].controller.text);
          }
        } else {
          await DBProvider.db.insertRespuesta(controllerInput[x].idPregunta,
              idFicha.toString(), "", controllerInput[x].controller.text,'Text');
        }
      }

      print("Formulario validado , inputables son :" +
          controllerInput.length.toString());

      List<RespuestaModel> listRespuestaDBlocal =
          await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());
      List<TrackingModel> listtRACKING =
          await DBProvider.db.getAllTrackingOfOneSurvery(idFicha);
      Map sendData = {
        'idEncuesta': idEncuesta,
        'idEncuestado': idEncuestado,
        'tracking': listtRACKING,
        'respuestas': listRespuestaDBlocal,
        'idFicha': idFicha
      };

      print(sendData);

      listtRACKING = [];
      _controllerInput = [];
      _pickOpcionSimple = [];

      Get.to(FichaPage(), arguments: sendData);
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
            onPressed: () async {
              _positionStream.cancel();
              Get.back();
              await guardarinputBack();
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
    if (controllerInput.length > 0) {
      for (var i = 0; i < controllerInput.length; i++) {
        if (controllerInput[i].controller.text == "" || controllerInput[i].controller.text == null || controllerInput[i].tipo_pregunta == "ubigeo") {
          controllerInput.removeWhere((item) => item.controller.text == "");
          controllerInput.removeWhere((element) => element.tipo_pregunta =="ubigeo");
        }
      }
    }
    for (var i = 0; i < controllerInput.length; i++) {
      List<RespuestaModel> respuesta = await DBProvider.db
          .unaRespuestaFicha(idFicha, controllerInput[i].idPregunta);

      if (respuesta.length > 0) {
        if (respuesta[0].valor != "") {
          print(
              'Ya existe la pregunta en la base de datos, ahora a actulizar con el nuevo valor');
          await DBProvider.db.actualizarRespuestaxFicha(
              controllerInput[i].idPregunta,
              idFicha,
              controllerInput[i].controller.text);
        }
      } else {
        await DBProvider.db.insertRespuesta(controllerInput[i].idPregunta,
            idFicha.toString(), "", controllerInput[i].controller.text,'Text');
      }
    }
  }

  List<PreguntaModel> tempList = [];

  calcular() {
    tempList = _preguntas
        .where((element) => element.tipo_pregunta.contains("note"))
        .toList();
    print(tempList);
    List<PreguntaModel> filtered2 = _preguntas
        .where((element) =>
            element.tipo_pregunta.contains("integer") ||
            element.tipo_pregunta.contains("decimal"))
        .toList();
    String formula = "";
    Parser p = Parser();
    Expression exp;
    print(filtered2);
    if (tempList.length > 0) {
      tempList.asMap().forEach((index, element) {
        formula = element.calculation;
        _preguntas.asMap().forEach((index, value) {
          if (_preguntas[index].bind_name == controllerInput[index].name) {
            var value1 = controllerInput[index].controller.text;
            print(value1);
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

class Imagelist{
  String idPregunta;
  File file;
 

  Imagelist(this.idPregunta, this.file);
}

class DropDownDepartamento extends StatelessWidget {
  final List<UbigeoModel> showDepartamentos;
  final List<String> dataUbi;
  const DropDownDepartamento({Key key, this.showDepartamentos, this.dataUbi})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String value = showDepartamentos[0].descripcion;

    return GetBuilder<QuizController>(
      init: QuizController(),
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
                //print(value.codigoDepartamento);
                //_.selectedDepartamento(dataUbi, value);
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

    return GetBuilder<QuizController>(
      init: QuizController(),
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

    return GetBuilder<QuizController>(
      init: QuizController(),
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

    return GetBuilder<QuizController>(
      init: QuizController(),
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
