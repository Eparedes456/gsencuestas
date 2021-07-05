import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Departamento/DepartamentoModel.dart';
import 'package:gsencuesta/model/Distritos/DistritosModel.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/MisEncuestas/MisEncuestasModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Provincia/ProvinciaModel.dart';
import 'package:gsencuesta/model/Ubigeo/UbigeoModel.dart';
import 'package:gsencuesta/pages/MisEncuestas/DetailMiEncuestaPage.dart';
import 'package:gsencuesta/pages/Practica/Practica.dart';
import 'package:gsencuesta/pages/Retomar/RetomarEncuestaPage.dart';
import 'package:gsencuesta/pages/quiz/QuizPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';

class EncuestaController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    var data = Get.arguments;
    _nombreProyecto = data[1];
    ingresoNuevo = data[0].encuestadoIngresoManual;
    print(data[0]);

    loadData(data[0]);
  }

  ApiServices apiConexion = new ApiServices();
  String ingresoNuevo = "";

  String _imagePortada = "";
  String get imagePortada => _imagePortada;

  String _titulo = "";
  String get titulo => _titulo;

  String _nombreProyecto = "";
  String get nombreProyecto => _nombreProyecto;

  String _descripcion = "";
  String get descripcion => _descripcion;

  String _fechaInicio = "";
  String get fechaInicio => _fechaInicio;

  String _fechaFin = "";
  String get fechaFin => _fechaFin;

  String _totalPreguntas = "";
  String get totalPreguntas => _totalPreguntas;

  String _idEncuesta = "";
  String get idEncuesta => _idEncuesta;

  String _nroTotalPreguntas = "";
  String get nroTotalPreguntas => _nroTotalPreguntas;

  Uint8List _photoBase64;
  Uint8List get photoBase64 => _photoBase64;

  List<PreguntaModel> _listPregunta = [];
  List<PreguntaModel> get listPregunta => _listPregunta;

  bool haypreguntas = false;

  List<FichasModel> _listFichas = [];
  List<FichasModel> get listFichas => _listFichas;

  List<MisEncuestasModel> _listEncuesta = [];
  List<MisEncuestasModel> get listEncuesta => _listEncuesta;

  TextEditingController insertEncuestadoController =
      new TextEditingController();

  TextEditingController searchReniecController = new TextEditingController();

  String idEncuestado;

  String _nombreEncuesta = "";
  String get nombreEncuesta => _nombreEncuesta;
  String _fechaEncuestaInicio = "";
  String get fechaEncuestaInicio => _fechaEncuestaInicio;

  bool _encuestasPendientes = false;
  bool get encuestasPendientes => _encuestasPendientes;

  String encuestaSourceMultimedia = "";

  /**  ubigeo */

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

  List<EncuestadoModel> encuestado = [];

  String _valueDistrito;
  String get valueDistrito => _valueDistrito;

  String _selectCodDepartamento = "";
  String _selectCodProvincia = "";
  String _selectCodDistrito = "";

  /** */

  loadData(EncuestaModel encuesta) async {
    _listFichas = [];
    _imagePortada = encuesta.logo;
    _descripcion = encuesta.descripcion;
    _titulo = encuesta.titulo;
    _fechaFin = encuesta.fechaFin;
    _fechaInicio = encuesta.fechaInicio;
    _idEncuesta = encuesta.idEncuesta.toString();
    encuestaSourceMultimedia = encuesta.sourceMultimedia;
    var encuestaRequeObservacion = encuesta.requeridoObservacion;
    var encuestaRequeMultimedia = encuesta.requeridoMultimedia;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('multimedia', encuestaSourceMultimedia);
    await preferences.setString(
        'requeridoObservacion', encuestaRequeObservacion);
    await preferences.setString('requeridoMultimedia', encuestaRequeMultimedia);

    _listFichas = await DBProvider.db.fichasPendientes("P");

    print(_listFichas.length);

    if (_listFichas.length > 0) {
      for (var element in _listFichas) {
        var listdata =
            await DBProvider.db.getOnesEncuesta(element.idEncuesta.toString());
        var idEncuestado3 = element.idEncuestado.toString();
        List<EncuestadoModel> _listEncuestado =
            await DBProvider.db.getOneEncuestado(idEncuestado3);
        var nombreEncuestado = _listEncuestado[0].nombre.toString() +
            " " +
            _listEncuestado[0].apellidoPaterno.toString();
        listdata.forEach((item) {
          _listEncuesta.add(MisEncuestasModel(
              idEncuesta: item["idEncuesta"].toString(),
              idProyecto: item["idProyecto"].toString(),
              nombreEncuestado: nombreEncuestado,
              nombreEncuesta: item["titulo"],
              fechaInicio: item["fechaInicio"],
              idFicha: element.idFicha.toString(),
              esRetomado: item["esRetomado"].toString()));
        });
      }

      _encuestasPendientes = true;
      print(_listEncuesta.length);
    } else {
      _encuestasPendientes = false;
    }

    await getPreguntas(encuesta.idEncuesta.toString());

    update();
  }

  getPreguntas(String idEncuesta) async {
    ConnectivityResult conectivityResult =
        await Connectivity().checkConnectivity();

    if (conectivityResult == ConnectivityResult.wifi ||
        conectivityResult == ConnectivityResult.mobile) {
      var resultado = await apiConexion.getPreguntasxEncuesta(idEncuesta);
      var preguntas = resultado["pregunta"];

      preguntas.forEach((item) {
        _listPregunta.add(PreguntaModel(
            id_pregunta: item["idPregunta"],
            id_bloque: item["id_bloque"],
            idEncuesta: item["id_encuesta"],
            enunciado: item["enunciado"],
            tipo_pregunta: item["tipo_pregunta"],
            apariencia: "", //item["apariencia"],
            requerido: item["requerido"].toString(),
            requerido_msj: item["requerido_msj"],
            readonly: item["readonly"].toString(),
            defecto: item["defecto"],
            calculation: item["calculation"],
            restriccion: item["restriccion"],
            restriccion_msj: item["restriccion_msj"],
            relevant: item["relevant"],
            choice_filter: item["choice_filter"],
            bind_name: item["bind_name"],
            bind_type: item["bind_type"],
            bind_field_length: item["bind_field_length"],
            bind_field_placeholder: item["bind_field_placeholder"],
            orden: item["orden"],
            estado: item["estado"].toString(),
            updated_at: item["createdAt"],
            created_at: item["updatedAt"]));
      });

      _totalPreguntas = _listPregunta.length.toString();
    } else {
      print("consulto bd local");

      _listPregunta = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);

      print(_listPregunta.length);
      _totalPreguntas = _listPregunta.length.toString();
    }

    //print(_listPregunta.length);
  }

  loadingModal() {
    Get.dialog(AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 12,
          ),
          Text('Cargando....')
        ],
      ),
    ));
  }

  showModalSearch() {
    Get.dialog(
      AlertDialog(
        title: Text('Buscar encuestado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: insertEncuestadoController,
              decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),
                  hintText: 'Ingrese el dni o el nombre del encuestado'),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton.icon(
                    color: Color.fromRGBO(0, 102, 84, 1),
                    onPressed: () {
                      searchEncuestado();
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Buscar',
                      style: TextStyle(color: Colors.white),
                    )),
                FlatButton.icon(
                    color: Color.fromRGBO(0, 102, 84, 1),
                    onPressed: () {
                      //searchEncuestado();
                      getAllEncuestados();
                    },
                    icon: Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Todos',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  searchEncuestado() async {
    Get.back();

    loadMessage('Buscando...', true);

    if (insertEncuestadoController.text == "") {
      print('El campo es requerido para hacer la busqueda');
      Get.back();
      messageInfo('El campo es requerido para hacer la busqueda');
    } else {
      //ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

      /*if(conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

        var response = await apiConexion.findEncuestado(insertEncuestadoController.text);
        if(response == 2){

          Get.back();

          messageInfo('Error 500, error de servidor comuniquese con el encargado del sistema');

        }else if( response != 2 && response != 1 && response != 3){

          print(response);
          
          if( response.length > 0 ){

            Get.back();
            encuestado = [];
            
            response.forEach((element){
              encuestado.add(
                EncuestadoModel(
                  idEncuestado    : element["idEncuestado"].toString(),
                  nombre          : element["nombre"],
                  apellidoPaterno : element["apellidoPaterno"], 
                  apellidoMaterno : element["apellidoMaterno"],
                  tipoDocumento   : element["tipoDocumento"],
                  foto            : element["foto"],
                  idUbigeo        : element["idUbigeo"]   
                )
              );
            });

            showEncuestadoModal(encuestado);

          }else{
          
          Get.back();
          messageInfo('El encuestado no se encuentra registrado');

          }
          

        }*/

      //}else{

      print("Busco al encuestado en la bd local");

      List<EncuestadoModel> respuesta =
          await DBProvider.db.searchEncuestado(insertEncuestadoController.text);
      if (respuesta.length > 0) {
        Get.back();
        showEncuestadoModal(respuesta);
      } else {
        Get.back();
        messageInfo('No se encontro ninguna coincidencia ');
      }

      //}

    }
  }

  getAllEncuestados() async {
    List<EncuestadoModel> response = await DBProvider.db.getAllEncuestado();
    if (response.length > 0) {
      print(response);
      Get.back();
      showTodosEncuestados(response);
    } else {
      Get.back();
      messageInfo('Usted no tiene ningún encuestado asignado');
    }
  }

  showTodosEncuestados(List<EncuestadoModel> response) async {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text('Encuestados encontrados'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 500,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: response.length,
                itemBuilder: (context, i) {
                  var nombreCompleto = response[i].nombre +
                      " " +
                      response[i].apellidoPaterno +
                      " " +
                      response[i].apellidoMaterno;
                  var foto = response[i].foto;
                  if (foto != null) {
                    _photoBase64 = base64Decode(foto);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: foto == "" || foto == null
                              ? AssetImage('assets/images/nouserimage.jpg')
                              : MemoryImage(_photoBase64)),
                      title: Text(
                        nombreCompleto,
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        Get.back();
                        showEncuestadoModalFinal(response[i]);
                      },
                    ),
                  );
                }),
          )
        ],
      ),
    ));
  }

  showEncuestadoModal(List<EncuestadoModel> response) async {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text('Encuestados encontrados'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /*ListView.builder(
                  //scrollDirection: Axis.vertical,
                  itemCount: response.length,
                  itemBuilder: (context,i){
                    var nombreCompleto  = response[i].nombre + " " + response[i].apellidoPaterno + " " + response[i].apellidoMaterno;
                    var foto            = response[i].foto;
                    if(foto != null){
                      _photoBase64        = base64Decode(foto);
                    }
                    

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:  foto == "" || foto == null ?  AssetImage('assets/images/nouserimage.jpg') :  MemoryImage(_photoBase64)
                        ),
                        title: Text( nombreCompleto ,style: TextStyle(fontSize: 14),),
                        onTap: (){
                          Get.back();
                          showEncuestadoModalFinal(response[i]);

                        },
                      ),
                    );
                  }
                ),*/

          Container(
            height: 500,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: response.length,
                itemBuilder: (context, i) {
                  var nombreCompleto = response[i].nombre +
                      " " +
                      response[i].apellidoPaterno +
                      " " +
                      response[i].apellidoMaterno;
                  var foto = response[i].foto;
                  if (foto != null) {
                    _photoBase64 = base64Decode(foto);
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: foto == "" || foto == null
                              ? AssetImage('assets/images/nouserimage.jpg')
                              : MemoryImage(_photoBase64)),
                      title: Text(
                        nombreCompleto,
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        Get.back();
                        showEncuestadoModalFinal(response[i]);
                      },
                    ),
                  );
                }),
          )
        ],
      ),
    ));
  }

  List listCodDep = [];
  List listcodProvincia = [];
  List liscodDistrito = [];

  showEncuestadoModalFinal(EncuestadoModel data) async {
    print(data);
    listCodDep = [];
    listcodProvincia = [];
    liscodDistrito = [];
    _listprovincias = [];
    _listDistritos = [];

    print(data.idEncuestado);
    var idEncuestado2 = data.idEncuestado.toString();
    var nombreCompleto =
        data.nombre + " " + data.apellidoPaterno + " " + data.apellidoMaterno;
    var foto = data.foto;
    if (foto != null) {
      _photoBase64 = base64Decode(foto);
    }

    var idUbigeo = data.idUbigeo; // "220101,220203,210402,220103";
    var dataUbi = idUbigeo.split(",");
    List temporalDepartamento = [];
    List temporalProvincia = [];
    List temporalDistrito = [];

    List<UbigeoModel> showDepartamentos = [];
    List<ProvinciaModel> showProvincias = [];
    List<DistritoModel> showDistritos = [];

    dataUbi.forEach((element) {
      var flat = element.substring(0, 2);
      temporalDepartamento.add(flat);
    });

    dataUbi.forEach((element) {
      var flat = element.substring(0, 4);
      temporalProvincia.add(flat);
    });

    listCodDep = temporalDepartamento.toSet().toList();
    listcodProvincia = temporalProvincia.toSet().toList();

    for (var i = 0; i < listCodDep.length; i++) {
      List<UbigeoModel> dataDepartamento =
          await DBProvider.db.getDepartamentos1(listCodDep[i].toString());
      print(dataDepartamento[0].descripcion);
      showDepartamentos.add(dataDepartamento[0]);
    }
    _valueDepartamento = showDepartamentos[0].descripcion;
    var idDepartamento = showDepartamentos[0].codigoDepartamento;
    listcodProvincia.removeWhere(
        (element) => element.toString().substring(0, 2) != idDepartamento);

    print(listcodProvincia);
    temporalProvincia = [];
    listcodProvincia.forEach((element) {
      var flat = element.substring(2, 4);
      temporalProvincia.add(flat);
    });
    List codProvincia = temporalProvincia.toSet().toList();

    for (var x = 0; x < codProvincia.length; x++) {
      List<UbigeoModel> dataProvincias = await DBProvider.db
          .getProvincia1(codProvincia[x].toString(), idDepartamento);
      _listprovincias.add(dataProvincias[0]);
    }
    print(dataUbi[0].substring(2, 4));
    print(idDepartamento);

    _valueProvincia = _listprovincias[0].descripcion;

    var result = dataUbi.where((element) =>
        element.contains(_listprovincias[0].codigoDepartamento) &&
        element.contains(_listprovincias[0].codigoProvincia));
    result.forEach((element) {
      temporalDistrito.add(element);
    });
    for (var d = 0; d < temporalDistrito.length; d++) {
      List<UbigeoModel> dataDistritos = await DBProvider.db.getDistrito1(
          temporalDistrito[d].toString().substring(2, 4),
          temporalDistrito[d].toString().substring(0, 2),
          temporalDistrito[d].toString().substring(4, 6));
      _listDistritos.add(dataDistritos[0]);
    }
    print(_listDistritos);

    _valueDistrito = _listDistritos[0].descripcion;
    _selectCodDistrito = _listDistritos[0].codigoDistrito;
    _selectCodDepartamento = idDepartamento;
    _selectCodProvincia = _listprovincias[0].codigoProvincia;

    Get.dialog(AlertDialog(
      title: Text('Encuestado encontrado'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            //leading: Icon(Icons.people,size: 16,),
            leading: CircleAvatar(
                radius: 30,
                backgroundImage: foto == null || foto == "null"
                    ? AssetImage('assets/images/nouserimage.jpg')
                    : MemoryImage(_photoBase64)),
            //trailing: Icon(Icons.arrow_forward,size: 16,),
            title: Text(
              '$nombreCompleto',
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Ambito  de intervención',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Text('DEPARTAMENTO'),
          DropDownDepartamento(
            showDepartamentos: showDepartamentos,
            dataUbi: dataUbi,
          ),
          SizedBox(
            height: 8,
          ),
          Text('PROVINCIA'),
          DropDownProvincia(
            showProvincia: _listprovincias,
            dataUbi: dataUbi,
          ),
          SizedBox(
            height: 8,
          ),
          Text('DISTRITO'),
          DropDownDistrito(),
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
                onPressed: () {
                  String ubigeo = _selectCodDepartamento +
                      _selectCodProvincia +
                      _selectCodDistrito;
                  idEncuestado = idEncuestado2.toString();
                  print(idEncuestado);
                  print(ubigeo);

                  confirmationModal(idEncuestado, ubigeo);

                  //Get.to(Practica());
                },
                child: Text(
                  'Empezar',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ));
  }

  confirmationModal(String id, String ubigeo) {
    Get.dialog(AlertDialog(
      title: Text('Notificación'),
      content: Text('¿Esta seguro que desea continuar?'),
      actions: [
        Container(
          height: 40,
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color.fromRGBO(0, 102, 84, 1),
            onPressed: () {
              navigateToQuiz(id, ubigeo);
            },
            child: Text('Empezar'),
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
              'Cancelar',
              style: TextStyle(
                color: Color.fromRGBO(0, 102, 84, 1),
              ),
            ),
          ),
        )
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ));
  }

  messageInfo(String mensaje) {
    Get.dialog(AlertDialog(
      title: Text('Notificación'),
      content: Text('$mensaje'),
    ));
  }

  loadMessage(String message, bool isLoading) {
    Get.dialog(AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isLoading == true ? CircularProgressIndicator() : Container(),
          SizedBox(
            height: 20,
          ),
          Text(message)
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  //  creamos la ficha en la bse de datos y si logras insertar exitosamente entonces navegamos a la pagina de las preguntas y  opciones.

  navigateToQuiz(String idEncuestado, String ubigeo) async {
    DateTime now = DateTime.now();
    var utc = now.toUtc();

    String formatDate = DateFormat('yyyy-MM-ddHH:mm:ss').format(now);
    String hourFormat = DateFormat('HH:mm:ss').format(now);

    var part = utc.toString().split(" ");
    var fecha = part[0].toString();
    var hora = part[1].toString();
    print(part[1]);
    String formattedDate = fecha + "T" + hora;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String latitud = position.latitude.toString();
    String longitud = position.longitude.toString();
    var ficha = await DBProvider.db.insertNewFicha(int.parse(idEncuesta),
        int.parse(idEncuestado), formattedDate, latitud, longitud, ubigeo);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUsuario = await preferences.getString('idUsuario');
    List<FichasModel> listDbLocal =
        await DBProvider.db.getAllFichas(int.parse(idUsuario));
    var getLastFichaid = await DBProvider.db.getLastFicha();

    int idFicha = getLastFichaid[0]["idFicha"];

    print("Ultima ficha insertada " + idFicha.toString());

    var result = await Get.to(QuizPage(), arguments: {
      'idEncuesta': idEncuesta,
      'tituloEncuesta': titulo,
      'idEncuestado': idEncuestado,
      'idFicha': idFicha.toString()
    });

    if (result == "SI") {
      print('Actualizar la vista mostrando las encuestas pendientes');
      Get.back();
      Get.back();
      _listEncuesta = [];
      _encuestasPendientes = false;
      update();
      await pendientesEncuestas();
    }
  }

  pendientesEncuestas() async {
    _listFichas = [];
    _listFichas = await DBProvider.db.fichasPendientes("P");
    print(_listFichas.length);
    if (_listFichas.length > 0) {
      for (var element in _listFichas) {
        var listdata =
            await DBProvider.db.getOnesEncuesta(element.idEncuesta.toString());
        var idEncuestado3 = element.idEncuestado.toString();
        List<EncuestadoModel> _listEncuestado =
            await DBProvider.db.getOneEncuestado(idEncuestado3);
        var nombreEncuestado = _listEncuestado[0].nombre.toString() +
            " " +
            _listEncuestado[0].apellidoPaterno.toString();

        listdata.forEach((item) {
          _listEncuesta.add(MisEncuestasModel(
              idEncuesta: item["idEncuesta"].toString(),
              idProyecto: item["idProyecto"].toString(),
              nombreEncuestado: nombreEncuestado,
              nombreEncuesta: item["titulo"],
              fechaInicio: item["fechaInicio"],
              idFicha: element.idFicha.toString(),
              esRetomado: item["esRetomado"].toString()));
        });
      }

      _encuestasPendientes = true;
    } else {
      _encuestasPendientes = false;
    }

    update();
  }

  navigateToRetomarEncuesta(
      String idFicha, String idEncuesta, String encuestaName) async {
    DateTime now = DateTime.now();
    var utc = now.toUtc();
    var part = utc.toString().split(" ");
    var fecha = part[0].toString();
    var hora = part[1].toString();
    String fecha_retorno = fecha + "T" + hora;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String latitud = position.latitude.toString();
    String longitud = position.longitude.toString();

    List<FichasModel> listFichas = await DBProvider.db
        .updateFechaRetorno(idFicha, fecha_retorno, latitud, longitud);
    print(listFichas);

    var data = {
      'idFicha': idFicha,
      'nombreEncuesta': encuestaName,
      'idEncuesta': idEncuesta
    };

    print(data);
    Get.to(RetomarEncuestaPage(), arguments: data);
  }

  modalDelete(String idFicha) {
    Get.dialog(
      AlertDialog(
        title: Text('Notificación'),
        content: Text('¿Está seguro de eliminar esta ficha?'),
        actions: [
          Container(
            height: 40,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color.fromRGBO(0, 102, 84, 1),
              onPressed: () {
                deleteFicha(idFicha);
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
                borderRadius: BorderRadius.circular(10)),
            child: MaterialButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Color.fromRGBO(0, 102, 84, 1),
                ),
              ),
            ),
          )
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  reniec() async {
    ConnectivityResult conectivityResult =
        await Connectivity().checkConnectivity();

    if (conectivityResult == ConnectivityResult.wifi ||
        conectivityResult == ConnectivityResult.mobile) {
      searchModalReniec();
    }
  }

  searchModalReniec() {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Reniec busqueda'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: searchReniecController,
          decoration: InputDecoration(hintText: 'Ingrese el dni'),
        ),
        MaterialButton(
            color: Color.fromRGBO(0, 102, 84, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: Colors.white),
                SizedBox(
                  width: 12,
                ),
                Text('Buscar', style: TextStyle(color: Colors.white))
              ],
            ),
            onPressed: () async {
              Get.back();
              loadingModal();
              var result =
                  await apiConexion.buscarReniec(searchReniecController.text);
              print(result["datosPersona"]);
              Get.back();
              showInfoReniecModal(result["datosPersona"]);
            })
      ]),
    ));
  }

  Map encuestadoData = {};

  showInfoReniecModal(var dataReniec) async {
    var nombreCompletoReniec = dataReniec["prenombres"];
    var apellidoPaterno = dataReniec["apPrimer"];
    var apellidoMaterno = dataReniec["apSegundo"];

    var direccion = dataReniec["direccion"];
    var imagenReniec = dataReniec["foto"];
    var estado_civil = dataReniec["estadoCivil"];

    Uint8List _fotoBase64 = base64Decode(imagenReniec);

    Get.dialog(AlertDialog(
        title: Center(child: Text('Ciudadano encontrado')),
        content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                //leading: Icon(Icons.people,size: 16,),
                leading: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        imagenReniec == null || imagenReniec == "null"
                            ? AssetImage('assets/images/nouserimage.jpg')
                            : MemoryImage(_fotoBase64)),

                title: Text(
                  '$nombreCompletoReniec $apellidoPaterno $apellidoMaterno',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Dirección: $direccion',
                          style: TextStyle(fontSize: 14))),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Estado civil : $estado_civil',
                          style: TextStyle(fontSize: 14))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 35,
                    color: Color.fromRGBO(0, 102, 84, 1),
                    child: MaterialButton(
                        child: Text('Siguiente',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          encuestadoData["apellidoMaterno"] = apellidoMaterno;
                          encuestadoData["apellidoPaterno"] = apellidoPaterno;
                          encuestadoData["nombre"] = nombreCompletoReniec;
                          encuestadoData["documento"] =
                              searchReniecController.text;
                          encuestadoData["email"] = "";
                          encuestadoData["direccion"] = direccion;
                          encuestadoData["estadoCivil"] = estado_civil;
                          encuestadoData["foto"] = imagenReniec;
                          encuestadoData["representanteLegal"] = "";
                          encuestadoData["sexo"] = "";
                          encuestadoData["telefono"] = "";
                          encuestadoData["tipoDocumento"] = "";
                          encuestadoData["tipoPersona"] = "";
                          encuestadoData["idTecnico"] =
                              preferences.getString('idUsuario');
                          Get.back();
                          modalAmbitodeIntervencion();
                        }),
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Color.fromRGBO(0, 102, 84, 1),
                    )),
                    child: MaterialButton(
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 102, 84, 1),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        }),
                  ),
                ],
              )
            ])));
  }

  modalAmbitodeIntervencion() async {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Ambito de intervención'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DropDownDepartamento(
            showDepartamentos: showDepartamentos,
            //dataUbi: dataUbi,
          ),
          SizedBox(
            height: 8,
          ),
          Text('PROVINCIA'),
          DropDownProvincia(
            showProvincia: _listprovincias,
            isManual: true,
            //dataUbi: dataUbi,
          ),
          Text('DISTRITO'),
          DropDownDistrito(
            showDistrito: _listDistritos,
            isManual: true,
          ),
          SizedBox(
            height: 8,
          ),
          Text('CENTRO POBLADO'),
          CentroPoblado(),
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
                onPressed: () {
                  String ubigeo =
                      "22" + _selectCodProvincia + _selectCodDistrito;
                  //idEncuestado = idEncuestado2.toString();
                  print(idEncuestado);
                  print(ubigeo);

                  //confirmationModal(idEncuestado, ubigeo);

                  //Get.to(Practica());
                },
                child: Text(
                  'Empezar',
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

  /* SI es manual el ingreso */

  selectProvinciaManual(UbigeoModel value) async {
    _listDistritos = [];
    List<UbigeoModel> dataDistritos =
        await DBProvider.db.getAllDistritos(value.codigoProvincia, "22");
    print(dataDistritos.length);

    for (var i = 0; i < dataDistritos.length; i++) {
      _listDistritos.add(dataDistritos[i]);
    }
    if (_listDistritos.length > 0) {
      print(_listDistritos.length);
      _selectCodProvincia = value.codigoProvincia;
      update(['distrito']);
    }
  }

  selectDistritoManual(UbigeoModel value) async {
    _listCentrosPoblados = [];
    List<UbigeoModel> dataCentroPoblados = await DBProvider.db
        .getAllCentrosPoblados(
            value.codigoProvincia, "22", value.codigoDistrito);
    print(dataCentroPoblados.length);

    for (var i = 0; i < dataCentroPoblados.length; i++) {
      _listCentrosPoblados.add(dataCentroPoblados[i]);
    }
    _selectCodDistrito = value.codigoDistrito;
  }

  /* */

  deleteFicha(String id) async {
    var response = await DBProvider.db.deleteOneFicha(id);
    List<FichasModel> respuesta = await DBProvider.db.oneFicha(id);
    if (respuesta.length == 0) {
      print('se elimino el registro');
      Get.back();

      await refreshPage();
    }
  }

  refreshPage() async {
    _listEncuesta = [];
    _encuestasPendientes = false;

    await pendientesEncuestas();

    update();
  }

  selectdepartamento(String valor) {
    _valueDepartamento = valor;
    update(['departamento']);
  }

  selectedDepartamento(List<String> dataUbi, UbigeoModel value) async {
    _listprovincias = [];
    _listDistritos = [];
    List temporalProvincia = [];
    List temporalDistrito = [];
    _valueDistrito = "";
    var result =
        dataUbi.where((element) => element.contains(value.codigoDepartamento));

    dataUbi.forEach((element) {
      var flat = element.substring(0, 4);
      temporalProvincia.add(flat);
    });

    listcodProvincia = temporalProvincia.toSet().toList();
    print(listcodProvincia);
    listcodProvincia.removeWhere((element) =>
        element.toString().substring(0, 2) != value.codigoDepartamento);
    print(listcodProvincia);

    temporalProvincia = [];
    listcodProvincia.forEach((element) {
      var flat = element.substring(2, 4);
      temporalProvincia.add(flat);
    });

    List codProvincia = temporalProvincia.toSet().toList();
    for (var x = 0; x < codProvincia.length; x++) {
      List<UbigeoModel> dataProvincias = await DBProvider.db.getOneProvincia(
          codProvincia[x].toString(), value.codigoDepartamento);
      _listprovincias.add(dataProvincias[0]);
    }

    print(_listprovincias);
    _valueProvincia = _listprovincias[0].descripcion;
    _selectCodDepartamento = value.codigoDepartamento;
    _selectCodProvincia = _listprovincias[0].codigoProvincia;
    update(['provincia']);
    await selectedProvincia(dataUbi, _listprovincias[0]);
  }

  changeProvincia(String valor) {
    _valueProvincia = valor;
    update(['provincia']);
  }

  selectedProvincia(List<String> dataUbi, UbigeoModel value) async {
    _listDistritos = [];
    List temporalDistrito = [];

    List result = dataUbi
        .where((element) => element.contains(value.codigoDepartamento +
            value
                .codigoProvincia) /*&& element.contains(value.codigoProvincia)*/)
        .toList();
    print(result.length);
    result.forEach((element) {
      temporalDistrito.add(element);
    });
    print(temporalDistrito);
    for (var d = 0; d < temporalDistrito.length; d++) {
      List<UbigeoModel> dataDistritos = await DBProvider.db.getDistrito1(
          temporalDistrito[d].toString().substring(2, 4),
          temporalDistrito[d].toString().substring(0, 2),
          temporalDistrito[d].toString().substring(4, 6));
      _listDistritos.add(dataDistritos[0]);
    }
    print(_listDistritos);
    _valueDistrito = _listDistritos[0].descripcion;
    _selectCodProvincia = value.codigoProvincia;
    _selectCodDistrito = _listDistritos[0].codigoDistrito;
    update(['distrito']);
  }

  changeDistrito(String valor) {
    _valueDistrito = valor;
    update(['distrito']);
  }

  selectedDistrito(UbigeoModel value) {
    _selectCodDistrito = value.codigoDistrito;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class DropDownDepartamento extends StatelessWidget {
  final List<UbigeoModel> showDepartamentos;
  final List<String> dataUbi;
  const DropDownDepartamento({Key key, this.showDepartamentos, this.dataUbi})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String value = showDepartamentos[0].descripcion;

    return GetBuilder<EncuestaController>(
      init: EncuestaController(),
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
                _.selectedDepartamento(dataUbi, value);
              },
            );
          }).toList(),
          onChanged: (valor) {
            _.selectdepartamento(valor);
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
  const DropDownProvincia(
      {Key key, this.showProvincia, this.dataUbi, this.isManual})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String value; //showProvincia[0].descripcion;

    return GetBuilder<EncuestaController>(
      init: EncuestaController(),
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
            child: Text('Seleccione un departamento'),
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
                  _.selectProvinciaManual(value);
                } else {
                  _.selectedProvincia(dataUbi, value);
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

    return GetBuilder<EncuestaController>(
      init: EncuestaController(),
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
                  _.selectDistritoManual(value);
                } else {
                  _.selectedDistrito(value);
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

    return GetBuilder<EncuestaController>(
      init: EncuestaController(),
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
                } else {
                  //_.selectedDistrito(value);
                }
              },
            );
          }).toList(),
          onChanged: (valor) {
            //_.changeDistrito(valor);
          },
        ),
      ),
    );
  }
}
