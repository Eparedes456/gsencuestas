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

import 'package:basic_utils/basic_utils.dart';



class QuizController extends GetxController with SingleGetTickerProviderMixin {
  ApiServices apiConexion = new ApiServices();
  String bloque;
  String direccionReniec  = "";
  String encuestadoNombreCompleto = "";
  List<Imagelist> files = [];
  var idEncuesta;
  var idEncuestado;
  var idFicha;
  var idRequierepreguntaObserva;
  List<String> idsOpcion = [];
  
  List liscodDistrito = [];
  List listCodDep = [];
  List listcodProvincia = [];
  var metaData;
  String numDOCUMENTO = "";
  var requiereObservacion =false;
  List<PreguntaModel> tempList = [];

  List<InputTextfield> _controllerInput = [];
  File _imagePath;
  bool _isLoadingData = false;
  String _latitud = "";
  List<UbigeoModel> _listCentrosPoblados = [];
  List<UbigeoModel> _listDistritos = [];
  List<UbigeoModel> _listprovincias = [];
  String _longitud = "";
  List<OpcionesModel> _opcionesPreguntas  = [];
  List<OpcionesModel> opcionesHijos      = [];

  List<OpcionesModel> _pickOpcionSimple = [];
  StreamSubscription<Position> _positionStream;
  List<PreguntaModel> _preguntas = [];
  String _selectCodCentroPoblado = "";
  String _selectCodDepartamento = "";
  String _selectCodDistritoUbigeo = "";
  String _selectCodProvincia = "";
  String _tipo_pregunta = 'Texto';
  String _tituloEncuesta = "";
  String _ubigeoCapturado = "";
  String _ubigeoGuardar = "";
  String _valueCentroPoblado;
  String _valueDepartamento;
  String _valueDistrito;
  String _valueProvincia;

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

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

    //metaData = listDataEncuesta['metaData'];



    var name = StringUtils.capitalize(datasa.nombre);
    var apellido1 = StringUtils.capitalize( datasa.apellidoPaterno);
    var apellido2 = StringUtils.capitalize( datasa.apellidoMaterno);
    encuestadoNombreCompleto = name +" "+ apellido1 +" "+ apellido2;
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
  
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  String get tipo_pregunta => _tipo_pregunta;

  List<PreguntaModel> get preguntas => _preguntas;

  List<OpcionesModel> get opcionesPreguntas => _opcionesPreguntas;

  String get tituloEncuesta => _tituloEncuesta;

  bool get isLoadingData => _isLoadingData;

  getPreguntas(String idEncuesta) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var datee = preferences.getString("metaDataUser");
    if(datee == "" || datee == null){

    }else{
      metaData = json.decode( preferences.getString("metaDataUser"));
    }

    


    _opcionesPreguntas = [];
    opcionesHijos     = [];
    _preguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);

      preguntas.asMap().forEach((index, element) {

        controllerInput.add(
          InputTextfield(
            element.id_pregunta.toString(),
            element.defecto == "" || element.defecto == null || element.defecto == "-" || element.defecto == "."? TextEditingController() : TextEditingController(text: element.defecto),
            element.bind_name,
            index,
            element.tipo_pregunta,
            element.calculation,
            element.requerido,
          ));
      }); 

      print(controllerInput);

    
      if(metaData != null && metaData != ""){
      
        print(metaData);
        metaData.forEach((index,element2){

          List<InputTextfield> index = controllerInput.where((element) => element.idPregunta == element2['idPregunta'].toString()).toList();

          print(index[0].idPregunta);
          index[0].controller = TextEditingController(text:  element2['nombre'].toString().toUpperCase());
          
          //StringUtils.capitalize(element2['nombre']));

          saveRequireObservacion(element2['idPregunta'].toString(), "", element2['nombre'].toString().toUpperCase(), "text");

        });

      }

     
    

    var allOpciones = await DBProvider.db.getAllOpciones();

    for (var i = 0; i < _preguntas.length; i++) {
      
      var idPregunta = _preguntas[i].id_pregunta;

      //_opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

      var opciones =
          await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());
          print(opciones);

      opciones.forEach((element) {

        if(element["padre"] == 0){

          _opcionesPreguntas.add(
            OpcionesModel(
              idPreguntaGrupoOpcion : element["idPreguntaGrupoOpcion"],
              idOpcion              : element["id_opcion"],
              idPregunta            : idPregunta,
              valor                 : element["valor"],
              label                 : StringUtils.capitalize(element["label"],),  
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


        }else{

          opcionesHijos.add(
            OpcionesModel(

              idPreguntaGrupoOpcion : element["idPreguntaGrupoOpcion"],
              idOpcion              : element["id_opcion"],
              idPregunta            : idPregunta,
              valor                 : element["valor"],
              label                 : StringUtils.capitalize(element["label"],),  
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

    //print(_opcionesPreguntas);


    _isLoadingData = true;

    //}

    update();
  }

  File get imagepath => _imagePath;

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
 
    }

    List<RespuestaModel> existe = await DBProvider.db.unaRespuestaFicha(idFicha, idPregunta); 

    if(existe.length > 0){
      

      var resp = await DBProvider.db.actualizarRespuestaxFicha(idPregunta, idFicha, photoBase64);
      var data = await DBProvider.db.getAllRespuestas(idFicha);

      files.asMap().forEach((key, value) { 

        if(value.idPregunta == idPregunta){
          files[key].file =  _imagePath;
          return false;
        }

      });

      


    }else{
   

      var resp = await DBProvider.db.insertRespuesta(idPregunta, idFicha, "", photoBase64, "Imagen");
      var data = await DBProvider.db.getAllRespuestas(idFicha);
      files.add(
        Imagelist(
          idPregunta,
          _imagePath
        ),
      );
   
    }
    
    update(['image']);
  }

  String get latitud => _latitud;

  String get longitud => _longitud;

  getCurrentLocation() async {
    bool servicioEnabled;

    servicioEnabled = await Geolocator.isLocationServiceEnabled();
    modalLoading('Obteniendo las coordenas, espere por favor...');

    if (servicioEnabled == true) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
  

      _latitud = position.latitude.toString();
      _longitud = position.longitude.toString();

      update();
      Get.back();
    } else {
    }
  }

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

  List<OpcionesModel> get pickOpcion => _pickOpcionSimple;


  capturarRespuestaSimple(OpcionesModel opcionEscogida) async {

    List response = await DBProvider.db.getHijosOpcion(opcionEscogida.idOpcion);

    if(response.length > 0){

      var index = opcionesPreguntas.indexWhere((element) => element.idOpcion == opcionEscogida.idOpcion);
      print(index);
      
      opcionesPreguntas[index].hijos = true;
 
      //print("dibujar las otras opciones");

      
    }else{

      //print("nodibujar nada");
    }

    

    opcionesPreguntas.forEach((element) async {

      if (element.idPregunta == opcionEscogida.idPregunta) {

        //element.selected = false;
        
        List<RespuestaModel> hayRespuesta = await DBProvider.db.unaRespuestaFicha(idFicha.toString(),opcionEscogida.idPregunta.toString());
        
        print(hayRespuesta);
        
        if(hayRespuesta.length > 0){

          if(opcionEscogida.idOpcion.toString() == hayRespuesta[0].idsOpcion){

              
          }else{
            if(element.idOpcion.toString() == opcionEscogida.idOpcion.toString()){

              element.selected = true;
              await DBProvider.db.updateResponseByFichaid(hayRespuesta[0].idRespuesta,opcionEscogida.valor,opcionEscogida.idOpcion.toString());

            }else{
              element.selected = false;
            }
            

          }

        }else{

          

          if (element.idOpcion == opcionEscogida.idOpcion && element.idPregunta == opcionEscogida.idPregunta) {

            element.selected = true;
            await DBProvider.db.insertRespuesta(
              opcionEscogida.idPregunta.toString(),
              idFicha.toString(),
              opcionEscogida.idOpcion.toString(),
              opcionEscogida.valor,
              'RespuestaSimple'
            );
          }



        }

    
      
      }

    });

    if (opcionEscogida.requiereDescripcion == "true") {

      idRequierepreguntaObserva = opcionEscogida.idPregunta;
      requiereObservacion = true;
    }

    update(['simple']);

    var index3 = _preguntas.indexWhere((element) => element.tipo_pregunta == "condicional");
    if(index3 != -1){

      await Future.delayed(Duration(milliseconds: 500),(){
        //print("hola");
        conditional(_preguntas[index3].id_pregunta);
      });
    }

  }

  capturarRespuestaSimpleHijos(OpcionesModel opcionEscogidaHijos)async{

    var idPadre = opcionEscogidaHijos.padre;
    print(idPadre);

    List<String> idsOpcionHijos = [];

    var response =  await DBProvider.db.unaRespuestaFicha(idFicha,opcionEscogidaHijos.idPregunta.toString());
    var flag = response[0].valor.split("-");
    print(flag);
    idsOpcionHijos.add(response[0].idsOpcion );
    var editResponse = await DBProvider.db.updateResponseByFicha(response[0].idRespuesta, flag[0]);

    opcionesHijos.forEach((element2)async{

      if(element2.idPregunta == opcionEscogidaHijos.idPregunta){
        element2.selected = false;
        await DBProvider.db.updateResponseByFicha(response[0].idRespuesta, flag[0]);
      }

      if(element2.idOpcion == opcionEscogidaHijos.idOpcion){
        String  ids = "";
        element2.selected  = true;
        var nuevoValor = flag[0] + "-" + opcionEscogidaHijos.valor;
        print(nuevoValor);
        idsOpcionHijos.add(element2.idOpcion.toString());
        print(idsOpcionHijos);
        idsOpcionHijos.forEach((element3) { 
          ids = idPadre.toString() + "("+ element3 + ")";
        });
        print(ids);
        await DBProvider.db.updateResponseHijosByFicha(response[0].idRespuesta, nuevoValor,ids);
        var response2 =  await DBProvider.db.unaRespuestaFicha(idFicha,opcionEscogidaHijos.idPregunta.toString());
        print(response2[0].valor);
      }

    });

    update(['simpleHijos']);

  }

  bool conditionalsi = false;
  bool conditionalno = false;

  conditional(int id_pregunta)async{

    List<int> listNo = [];
    //print("holi condicional  , id_pregunta $id_pregunta");

    List<RespuestaModel> listRespuesta = await DBProvider.db.getAllRespuestasxFicha(idFicha.toString());

    print(listRespuesta);

    List<RespuestaModel> temporalRespuesta  = listRespuesta.where((element) => element.tipoPregunta == "RespuestaSimple" ).toList();
    print(temporalRespuesta);

    var index = temporalRespuesta.indexWhere((element) => element.valor == "NO" || element.valor == "No");
    
    if( index != -1){

      listNo.add(index);
      print(listNo.length);
      print("pintar la opcion no");

    }else{

      listNo = [];

    }

    print(listNo);

    if(listNo.length > 0){

      conditionalno  = true;
      conditionalsi = false;

      var index2 = listRespuesta.indexWhere((element) => element.idPregunta == id_pregunta);
      if(index2 != -1){

        print("actualizar");
       

        await DBProvider.db.updateResponseByFichaid(listRespuesta[index2].idRespuesta,"NO","");

      }else{

        print("insertar");

        await DBProvider.db.insertRespuesta(
            id_pregunta.toString(),
            idFicha.toString(),
            "",
            "NO",
            'condicional'
        );

      }

    }else{

      conditionalno  = false;
      conditionalsi = true;
      var index2 = listRespuesta.indexWhere((element) => element.idPregunta == id_pregunta);
      if(index2 != -1){

        print("actualizar");

        await DBProvider.db.updateResponseByFichaid(listRespuesta[index2].idRespuesta,"SI","");


      }else{

        print("insertar");

        await DBProvider.db.insertRespuesta(
            id_pregunta.toString(),
            idFicha.toString(),
            "",
            "SI",
            'condicional'
        );

      }


    }

    update(['condicional']);

  }


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

  capturarRespuestaMultiple(OpcionesModel opcionEscogida) async {

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
            idsOpcion.add(element.idOpcion.toString());
            

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

  List<InputTextfield> get controllerInput => _controllerInput;

  String get ubigeoCapturado => _ubigeoCapturado;

  String get valueDistrito => _valueDistrito;

  String get valueCentroPoblado => _valueCentroPoblado;

  String get valueDepartamento => _valueDepartamento;

  String get valueprovincia => _valueProvincia;

  List<UbigeoModel> get listprovincias => _listprovincias;

  List<UbigeoModel> get listDistrito => _listDistritos;

  List<UbigeoModel> get listCentroPoblados => _listCentrosPoblados;

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

  textFormFields(int id_pregunta,String tipo_preguntas){

    for (var i = 0; i < opcionesPreguntas.length; i++) {
      
      if(id_pregunta == opcionesPreguntas[i].idPregunta ){

        var index = controllerInput.indexWhere((element) => element.idPregunta == id_pregunta.toString());
        print(index);
        
        return TextField(
          onChanged: (value){

            saveRequireObservacion(id_pregunta.toString(),"",value,tipo_preguntas);

          },
          controller: controllerInput[index].controller,
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

  guardarInput(String idPregunta, String valor) async {

    List<RespuestaModel> respuesta =
        await DBProvider.db.unaRespuestaFicha(idFicha, idPregunta);

    if (respuesta.length > 0) {
      if (respuesta[0].valor != "") {

        await DBProvider.db
            .actualizarRespuestaxFicha(idPregunta, idFicha, valor);
      }
    } else {
      await DBProvider.db.insertRespuesta(
          idPregunta.toString(), idFicha.toString(), "", valor,'Text');
    }
  }

  guardarFicha() async {
  

    bool formValidado = true;

    for (var z = 0; z < _preguntas.length; z++) {
      if (_preguntas[z].requerido == "true" || _preguntas[z].requerido == true) {
        var numPregunta = z + 1;
        if (_preguntas[z].tipo_pregunta == "integer" || _preguntas[z].tipo_pregunta == "decimmal" || _preguntas[z].tipo_pregunta == "text") {
          //for (var x = 0; x <= controllerInput.length ; x++) {
          //Si devuelve -1 es por que no existe el valor que se requier encontrar
          if (controllerInput[z].idPregunta.toString() == _preguntas[z].id_pregunta.toString() && controllerInput[z].controller.text == "") {
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
              idFicha.toString(), "", controllerInput[x].controller.text,'Text');
        }
      }

    

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
      
      List<RespuestaModel> respuesta = await DBProvider.db.unaRespuestaFicha(idFicha, controllerInput[i].idPregunta);

      if (respuesta.length > 0) {

        if (respuesta[0].valor != "") {
     
          await DBProvider.db.actualizarRespuestaxFicha(
              controllerInput[i].idPregunta,
              idFicha,
              controllerInput[i].controller.text);
        }



      } else {

        await DBProvider.db.insertRespuesta(controllerInput[i].idPregunta,idFicha.toString(), "", controllerInput[i].controller.text,'Text');
      }
    }
  }

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

  /* Datos del encuestado reiniec */

  /* */

  /* Image pic to camera */

  /* */

  /* Obtener la ubicación del dispositivo */

  /* DatePicker respuesta */

  /* */

  /*  Obtener simple widget respuesta */

  /*  Obtener respuesta multiple widget  respuesta */

  /* Obtener el dato de los texteditting controller */

  /* UBIGEO  WIDGET */

/* */

  /* guardar la ficha */
}

class InputTextfield {
  InputTextfield(this.idPregunta, this.controller, this.name, this.index,
      this.tipo_pregunta, this.calculation,this.require,);

  String calculation;
  TextEditingController controller;
  String idPregunta;
  int index;
  String name;
  String require;
  String tipo_pregunta;
}

class Imagelist{
  File file;
  String idPregunta;

  Imagelist(this.idPregunta, this.file);
}

class DropDownDepartamento extends StatelessWidget {
  const DropDownDepartamento({Key key, this.showDepartamentos, this.dataUbi})
      : super(key: key);

  final List<String> dataUbi;
  final List<UbigeoModel> showDepartamentos;

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
  const DropDownProvincia(
      {Key key,
      this.showProvincia,
      this.dataUbi,
      this.isManual,
      this.apariencia})
      : super(key: key);

  final String apariencia;
  final List<String> dataUbi;
  final bool isManual;
  final List<UbigeoModel> showProvincia;

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
  const DropDownDistrito(
      {Key key, this.showDistrito, this.dataUbi, this.isManual})
      : super(key: key);

  final List<String> dataUbi;
  final bool isManual;
  final List<UbigeoModel> showDistrito;

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
  const CentroPoblado(
      {Key key, this.showCentroPoblado, this.dataUbi, this.isManual})
      : super(key: key);

  final List<String> dataUbi;
  final bool isManual;
  final List<UbigeoModel> showCentroPoblado;

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
