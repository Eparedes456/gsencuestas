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
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';
import 'package:gsencuesta/model/Ubigeo/UbigeoModel.dart';
import 'package:gsencuesta/pages/MisEncuestas/DetailMiEncuestaPage.dart';
import 'package:gsencuesta/pages/Practica/Practica.dart';
import 'package:gsencuesta/pages/Retomar/RetomarEncuestaPage.dart';
import 'package:gsencuesta/pages/quiz/MultiPageQuiz/MultiPageQuiz.dart';
import 'package:gsencuesta/pages/quiz/QuizPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';

import '../../database/database.dart';
import '../../database/database.dart';
import '../../database/database.dart';
import '../../model/Encuesta/EncuestaModel.dart';
import '../../model/Encuesta/EncuestaModel.dart';
import '../../model/Encuestado/EncuestadoModel.dart';
import '../../model/Encuestado/EncuestadoModel.dart';

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
    tipoVista = data[0].tipoVista;
    print(tipoVista);

    loadData(data[0]);
  }

  ApiServices apiConexion = new ApiServices();
  String ingresoNuevo = "";

  /*Cabecera de la encuesta , nombre de la persona a encuestar */

  
  


  /* */

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

  String tipoVista = "";

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

  String _valueCentroPoblado;
  String get valueCentroPoblado => _valueCentroPoblado;

  String _selectCodDepartamento = "";
  String _selectCodProvincia = "";
  String _selectCodDistrito = "";
  String _selectCodCentroPoblado = "";


  String _selectCodDistritoManual = "";

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
    await getPreguntas(encuesta.idEncuesta.toString());
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
        
        String idEncuesta = element.idEncuesta.toString();
        List<PreguntaModel> _listPreguntas1 = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
        String _nroTotalPreguntasa = _listPreguntas1.length.toString();

        List<RespuestaModel> listRespuesta  = await DBProvider.db.getAllRespuestasxFicha(element.idFicha.toString());
        print(listRespuesta);

        List<int> respuestas = [];
        listRespuesta.forEach((element) {
          respuestas.add(element.idPregunta);
        });
        var respuestasLong = respuestas.toSet().toList();
        print(respuestasLong);
        print(_nroTotalPreguntasa);


        var calPercent =  ( respuestasLong.length *  100 ) / _listPreguntas1.length;
        print('Porcentaje '  + calPercent.toStringAsFixed(0));
        var porcentaje =  ( double.parse(calPercent.toStringAsFixed(0)))  / 100;
        print(porcentaje);

        listdata.forEach((item) {
          _listEncuesta.add(
            MisEncuestasModel(
              idEncuesta              : item["idEncuesta"].toString(),
              idProyecto              : item["idProyecto"].toString(),
              nombreEncuestado        : nombreEncuestado,
              nombreEncuesta          : item["titulo"],
              fechaInicio             : item["fechaInicio"],
              idFicha                 : element.idFicha.toString(),
              esRetomado              : item["esRetomado"].toString(),
              preguntasRespondidas    : respuestasLong.length.toString(),
              totalPreguntas          : _listPreguntas1.length.toString(),
              percent                 : porcentaje,
              porcentaje              : calPercent.toStringAsFixed(0) 
            )
          );
        });
      }

      _encuestasPendientes = true;
      print(_listEncuesta.length);
    } else {
      _encuestasPendientes = false;
    }

    

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
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 12,
            ),
            Text('Buscando....')
          ],
        ),
      ),
      barrierDismissible: false
    );
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
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    var idInstitucion = await preferencias.getString('idInstitucion');
    print(idInstitucion);

    //List<EncuestadoModel> response = await DBProvider.db.getAllEncuestado();
    List<EncuestadoModel> response = await DBProvider.db.getAllEncuestadoxinstitucion(idInstitucion.toString());
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

    Get.dialog(
      AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text('Encuestados encontrados'),
      content: SingleChildScrollView( //MUST TO ADDED
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < response.length; i++)...{
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: response[i].foto == "" || response[i].foto == null || response[i].foto == "null"
                              ? AssetImage('assets/images/nouserimage.jpg')
                              : MemoryImage(_photoBase64)),
                      title: Text(
                        '${response[i].nombre}  ${response[i].apellidoPaterno} ${response[i].apellidoMaterno}',
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        Get.back();
                        showEncuestadoModalFinal(response[i]);
                      },
                    ),
                  ),
                }
              ],
            ),
          ),
    ));
  }

  showEncuestadoModal(List<EncuestadoModel> response) async {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text('Encuestados encontrados'),
      content: SingleChildScrollView( //MUST TO ADDED
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < response.length; i++)...{
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: response[i].foto == "" || response[i].foto == null
                    ? AssetImage('assets/images/nouserimage.jpg'): MemoryImage(_photoBase64)
                  ),
                  title: Text(
                    '${response[i].nombre}  ${response[i].apellidoPaterno} ${response[i].apellidoMaterno}',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.back();
                    showEncuestadoModalFinal(response[i]);
                  },
                ),
              ),
            }
          ],
        ),
      ),
    ));
  }

  List listCodDep = [];
  List listcodProvincia = [];
  List liscodDistrito = [];

  showEncuestadoModalFinal(EncuestadoModel data) async {
    //print(data);
    listCodDep = [];
    listcodProvincia = [];
    liscodDistrito = [];
    _listprovincias = [];
    _listDistritos = [];
    _listCentrosPoblados = [];
    var idEncuestado2 = data.idEncuestado.toString();
    var nombreCompleto =
        data.nombre + " " + data.apellidoPaterno + " " + data.apellidoMaterno;
    var foto = data.foto;
    
    if (foto != null) {
      _photoBase64 = base64Decode(foto);
    }

    var idUbigeo = data.idUbigeo; // "220101,220203,210402,220103, 2202020026";
    var dataUbi = idUbigeo.split(",");
    List temporalDepartamento = [];
    List temporalProvincia = [];
    List temporalDistrito = [];
    List temporalCentroPoblado = [];

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
      //print(dataDepartamento[0].descripcion);
      showDepartamentos.add(dataDepartamento[0]);
    }
    _valueDepartamento = showDepartamentos[0].descripcion;
    var idDepartamento = showDepartamentos[0].codigoDepartamento;
    listcodProvincia.removeWhere((element) => element.toString().substring(0, 2) != idDepartamento);

    print(listcodProvincia);
    temporalProvincia = [];
    listcodProvincia.forEach((element) {
      var flat = element.substring(2, 4);
      temporalProvincia.add(flat);
    });
    
    List codProvincia = temporalProvincia.toSet().toList();

    for (var x = 0; x < codProvincia.length; x++) {
      List<UbigeoModel> dataProvincias = await DBProvider.db.getProvincia1(codProvincia[x].toString(), idDepartamento);
      _listprovincias.add(dataProvincias[0]);
    }
    /*print(dataUbi[0].substring(2, 4));
    print(idDepartamento);*/

    _valueProvincia = _listprovincias[0].descripcion;

    var result = dataUbi.where((element) =>element.contains(_listprovincias[0].codigoDepartamento) && element.contains(_listprovincias[0].codigoProvincia));
    print(result);
    result.forEach((element) {
      var flat = element.substring(4, 6);
      temporalDistrito.add(flat);
    });

    List codDistrito = temporalDistrito.toSet().toList();

    for (var d = 0; d < codDistrito.length; d++) {
      List<UbigeoModel> dataDistritos = await DBProvider.db.getDistrito1(
          _listprovincias[0].codigoProvincia, //temporalDistrito[d].toString().substring(2, 4),
          idDepartamento, //temporalDistrito[d].toString().substring(0, 2),
          codDistrito[d].toString() //temporalDistrito[d].toString().substring(4, 6)
      );
      _listDistritos.add(dataDistritos[0]);
    }
    print(_listDistritos);

    var result2 = dataUbi.where((item) =>  item.contains(_listDistritos[0].codigoDepartamento) && item.contains(_listDistritos[0].codigoProvincia) && item.contains(_listDistritos[0].codigoDistrito) );
    print(result2);

    result2.forEach((element) {
      var flat = element.substring(6, 10);
      temporalCentroPoblado.add(flat);
    });
    List codCentroPoblado = temporalCentroPoblado.toSet().toList();
   
    for (var i = 0; i < codCentroPoblado.length; i++) {

      List<UbigeoModel> dataCentroPoblados = await DBProvider.db.getCentroPoblado(
        _listprovincias[0].codigoProvincia, //temporalCentroPoblado[i].toString().substring(2,4), 
        idDepartamento, //temporalCentroPoblado[i].toString().substring(0,2),
        _listDistritos[0].codigoDistrito, //temporalCentroPoblado[i].toString().substring(4,6), 
        codCentroPoblado[i].toString()  //temporalCentroPoblado[i].toString().substring(6,10)
      );
      _listCentrosPoblados.add(dataCentroPoblados[0]);
    }
    print(_listCentrosPoblados);

    _selectCodDistrito      = _listDistritos[0].codigoDistrito;
    _selectCodDepartamento  = idDepartamento;
    _selectCodProvincia     = _listprovincias[0].codigoProvincia;
    _selectCodCentroPoblado = _listCentrosPoblados[0].codigoCentroPoblado;

    _valueCentroPoblado     = _listCentrosPoblados[0].descripcion;
    _valueDistrito          = _listDistritos[0].descripcion;
    _valueProvincia         = _listprovincias[0].descripcion;
    
    print(_valueCentroPoblado);
    print(_valueDistrito);
    print(_valueProvincia);

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
                backgroundImage: foto == null || foto == "null" || foto == ""
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
            tieneUbigeo: true,
            
          ),
          SizedBox(
            height: 8,
          ),
          Text('PROVINCIA'),
          DropDownProvincia(
            showProvincia: _listprovincias,
            dataUbi: dataUbi,
            isManual: false,
          ),
          SizedBox(
            height: 8,
          ),
          Text('DISTRITO'),
          DropDownDistrito(
            showDistrito: _listDistritos,
            dataUbi: dataUbi,
            isManual: false,
          ),
          SizedBox(
            height: 8,
          ),
          
          Text('CENTRO POBLADO'),
          CentroPoblado(
            showCentroPoblado: _listCentrosPoblados,
            dataUbi: dataUbi,
            isManual: false,
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
                onPressed: () {
                  String ubigeo = _selectCodDepartamento +
                      _selectCodProvincia +
                      _selectCodDistrito + _selectCodCentroPoblado;
                  idEncuestado = idEncuestado2.toString();
                  print(idEncuestado);
                  print(ubigeo);

                  confirmationModal(idEncuestado, ubigeo,data);

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

  confirmationModal(String id, String ubigeo, var dataEncuestado) {
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
                navigateToQuiz(id, ubigeo,dataEncuestado);
            },
            child: Text('Empezar',style: TextStyle(color: Colors.white),),
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

  navigateToQuiz(String idEncuestado, String ubigeo, var EncuestadoData) async {

    Get.dialog(

      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8,),
            Text('Cargando preguntas....')
          ],
        ),
      )
    );

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

    if(tipoVista == "MULTIPAGE"){
      Get.to(MultiPageQuiz(),arguments: {
        'idEncuesta': idEncuesta,
        'tituloEncuesta': titulo,
        'idEncuestado': idEncuestado,
        'idFicha': idFicha.toString()
      });
    }else {
      Get.back();
      var result = await Get.to(QuizPage(), arguments: {
        'idEncuesta'      : idEncuesta,
        'tituloEncuesta'  : titulo,
        'idEncuestado'    : idEncuestado,
        'idFicha'         : idFicha.toString(),
        'encuestado'      : EncuestadoData
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

        List<PreguntaModel> _listPreguntas1 = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
        String _nroTotalPreguntasa = _listPreguntas1.length.toString();


        List<RespuestaModel> listRespuesta  = await DBProvider.db.getAllRespuestasxFicha(element.idFicha.toString());
        print(listRespuesta);

        List<int> respuestas = [];
        listRespuesta.forEach((element) {
          respuestas.add(element.idPregunta);
        });
        var respuestasLong = respuestas.toSet().toList();
        print(respuestasLong);
        print(_nroTotalPreguntasa);

        var calPercent =  ( respuestasLong.length *  100 ) / _listPreguntas1.length;
        print('Porcentaje '  + calPercent.toStringAsFixed(0));
        var porcentaje =  ( double.parse(calPercent.toStringAsFixed(0)))  / 100;
        print(porcentaje);

        listdata.forEach((item) {
          _listEncuesta.add(
            MisEncuestasModel(
              idEncuesta:             item["idEncuesta"].toString(),
              idProyecto:             item["idProyecto"].toString(),
              nombreEncuestado:       nombreEncuestado,
              nombreEncuesta:         item["titulo"],
              fechaInicio:            item["fechaInicio"],
              idFicha:                element.idFicha.toString(),
              esRetomado:             item["esRetomado"].toString(),
              preguntasRespondidas:   respuestasLong.length.toString(),
              totalPreguntas:         _listPreguntas1.length.toString(),
              percent                 : porcentaje,
              porcentaje              : calPercent.toStringAsFixed(0) 
            )
          );
              
        });
      }

      _encuestasPendientes = true;
    } else {
      _encuestasPendientes = false;
    }

    update();
  }

  navigateToRetomarEncuesta( String idFicha, String idEncuesta, String encuestaName) async {
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
    var result = await Get.to(RetomarEncuestaPage(), arguments: data);

    if (result == "SI") {
        print('Actualizar la vista mostrando las encuestas pendientes');
        
        _listEncuesta = [];
        _encuestasPendientes = false;
        update();
        await pendientesEncuestas();
    }


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
    }else{
      modalDeRegistro();
    }
  }
  
  TextEditingController _nombreController     = new TextEditingController();
  TextEditingController _apellidoPaController = new TextEditingController();
  TextEditingController _apellidoMaController = new TextEditingController();
  TextEditingController _documentoController  = new TextEditingController();

  modalDeRegistro()async{
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        title: Text('Registrar encuestado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre'),
              SizedBox(height: 8,),
              Container(
                height: 40,
                child: Padding(
                  padding:  EdgeInsets.only(right: 8),
                  child: TextField(
                    style: TextStyle(fontSize: 13),
                    controller: _nombreController,
                    decoration: InputDecoration(
                      hintText: 'Ingresar nombre',
                      hintStyle: TextStyle(fontSize: 13)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Text('Apellido Paterno'),
              SizedBox(height: 8,),
              Container(
                height: 40,
                child: Padding(
                  padding:  EdgeInsets.only(right: 8),
                  child: TextField(
                    style: TextStyle(fontSize: 13),
                    controller: _apellidoPaController,
                    decoration: InputDecoration(
                      hintText: 'Ingresar apellido paterno',
                      hintStyle: TextStyle(fontSize: 13)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Text('Apellido Materno'),
              SizedBox(height: 8,),
              Container(
                height: 40,
                child: Padding(
                  padding:  EdgeInsets.only(right: 8),
                  child: TextField(
                    style: TextStyle(fontSize: 13),
                    controller: _apellidoMaController,
                    decoration: InputDecoration(
                      hintText: 'Ingresar apellido materno',
                      hintStyle: TextStyle(fontSize: 13)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Text('Nº de documento'),
              SizedBox(height: 8,),
              Container(
                height: 40,
                child: Padding(
                  padding:  EdgeInsets.only(right: 8),
                  child: TextField(
                    style: TextStyle(fontSize: 13),
                    controller: _documentoController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el número de documento',
                      hintStyle: TextStyle(fontSize: 13)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              MaterialButton(
                color: Color.fromRGBO(0, 102, 84, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 12,),
                    Text('Guardar', style: TextStyle(color: Colors.white))
                  ],
                ),
                onPressed: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  encuestadoData["apellidoMaterno"] = _apellidoMaController.text == "" || _apellidoMaController.text == null ? "" :   _apellidoMaController.text;
                  encuestadoData["apellidoPaterno"] = _apellidoPaController.text == "" || _apellidoPaController.text == null ? "" : _apellidoPaController.text;
                  encuestadoData["nombre"] = _nombreController.text == "" || _nombreController.text == null ? "NO SE REGISTRO" : _nombreController.text;
                  encuestadoData["documento"] = _documentoController.text;
                  encuestadoData["email"] = "";
                  encuestadoData["direccion"] = "";
                  encuestadoData["estadoCivil"] = "";
                  encuestadoData["foto"] = "";
                  encuestadoData["representanteLegal"] = "";
                  encuestadoData["sexo"] = "";
                  encuestadoData["telefono"] = "";
                  encuestadoData["tipoDocumento"] = "";
                  encuestadoData["tipoPersona"] = "NATURAL";
                  encuestadoData["idTecnico"] = preferences.getString('idUsuario');
                  if(_documentoController.text == "" || _documentoController.text == null){
                    Get.dialog(
                      AlertDialog(
                        title: Text('Notificación'),
                        content: Text('El campo del número de documento es obligatorio'),
                        actions: [
                          MaterialButton(
                            color: Color.fromRGBO(0, 102, 84, 1),
                            onPressed: (){
                              Get.back();
                            },
                            child: Text('Entendido',style: TextStyle(color: Colors.white),),
                          )
                        ],
                      )
                    );
                  }else{
                    Get.back();
                    modalAmbitodeIntervencion(encuestadoData,false);
                  }
                  
                }
              )
            ],
          ),
        ),
      )
    );
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
              var result = await apiConexion.buscarReniec(searchReniecController.text);
              
              if(result == 3){
                Get.back();
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    title: Text('Notificación'),
                    content: Text('No se encontro ningún registro asociado al número de documento insertado.'),
                  )
                );
              }else{

                Get.back();
                showInfoReniecModal(result["datosPersona"]);
              }
              
            })
      ]),
    ));
  }

  Map encuestadoData = {};
  List<EncuestadoModel> dataEncuestado = [];

  showInfoReniecModal(var dataReniec) async {
    var nombreCompletoReniec = dataReniec["prenombres"];
    var apellidoPaterno = dataReniec["apPrimer"];
    var apellidoMaterno = dataReniec["apSegundo"];
    var ubigeoString = dataReniec["ubigeo"];
    var direccion = dataReniec["direccion"];
    var imagenReniec = dataReniec["foto"];
    var estado_civil = dataReniec["estadoCivil"];

    Uint8List _fotoBase64 = base64Decode(imagenReniec);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
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
              Text(
                'Ubigeo: $ubigeoString',
                style: TextStyle(fontSize: 14),
              ),

              SizedBox(
                height: 10,
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
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          
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
                          encuestadoData["tipoPersona"] = "NATURAL";
                          encuestadoData["idTecnico"] =
                              preferences.getString('idUsuario');
                          
                          Get.back();
                          modalAmbitodeIntervencion(encuestadoData,true);
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

  modalWarningAmbito(){
    Get.dialog(
      
      AlertDialog(

        title: Text('Notificación'),
        content: Text('Seleccione el ambito de intervención'),
        actions: [
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(0, 102, 84, 1),),
            ),
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.cancel),
            label: Text('Cerrar')
          )
        ],
      ),
      barrierDismissible: false
    );
  }

  modalAmbitodeIntervencion(var dataEncuestados, bool isValidadoReniec) async {
    listCodDep = [];
    listcodProvincia = [];
    liscodDistrito = [];
    _listprovincias = [];
    _listDistritos = [];
    String ubigeo;

    /* Datos del encuestado de reniec */
    print('hola');
    print(dataEncuestados["nombre"]);


    /* */
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
          Text('DEPARTAMENTO'),
          DropDownDepartamento(
            showDepartamentos: showDepartamentos,
            tieneUbigeo: false,
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
          CentroPoblado(
            showCentroPoblado: _listCentrosPoblados,
            isManual: true,
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
                onPressed: () async{
                  dataEncuestado = [];
                  //await DBProvider.db.insertEncuestados(nuevoEncuestado);
                  ubigeo = "22" + _selectCodProvincia + _selectCodDistritoManual + _selectCodCentroPoblado;
                  
                  dataEncuestado.add(
                    EncuestadoModel(
                      documento: searchReniecController.text == "" ? dataEncuestados["documento"] : searchReniecController.text,
                      nombre: dataEncuestados["nombre"],
                      apellidoMaterno: dataEncuestados["apellidoMaterno"],
                      apellidoPaterno: dataEncuestados["apellidoPaterno"],
                      sexo: "",
                      email: "",
                      direccion: dataEncuestados["direccion"] == "" || dataEncuestados["direccion"] == null ? ""  :  dataEncuestados["direccion"],
                      estadoCivil: dataEncuestados["estadoCivil"],
                      foto: dataEncuestados["foto"],
                      representanteLegal: "",
                      telefono: "",
                      tipoDocumento: "DNI",
                      tipoPersona: "NATURAL",
                      validadoReniec: isValidadoReniec.toString(),
                      idTecnico: dataEncuestados["idTecnico"],
                      idUbigeo: ubigeo
                    )
                  );
                  if(_selectCodProvincia == "" &&  _selectCodDistritoManual == "" && _selectCodCentroPoblado == ""){
                    modalWarningAmbito();
                  } else if(_selectCodProvincia == ""){
                    modalWarningAmbito();
                  }else if(_selectCodDistritoManual == ""){
                    modalWarningAmbito();
                  }else if(_selectCodCentroPoblado == ""){
                    modalWarningAmbito();
                  }else{

                    print(dataEncuestado);
                    await DBProvider.db.insertEncuestados(dataEncuestado[0]);
                    List<EncuestadoModel> respuesta = await DBProvider.db.getLastEncuestado();
                    print(respuesta);

                    print(idEncuestado);
                    print(ubigeo);

                    confirmationModal(respuesta[0].idEncuestado, ubigeo,dataEncuestado[0]);


                  }

                  

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
    
    
    //_listCentrosPoblados = [];
    List<UbigeoModel> dataDistritos =
        await DBProvider.db.getAllDistritos(value.codigoProvincia, "22");
    print(dataDistritos.length);
    //
    _listDistritos = [];
    dataDistritos.forEach((element) { 
      _listDistritos.add(element);
    });

    if (_listDistritos.length > 0) {
      print(_listDistritos.length);
      _selectCodProvincia = value.codigoProvincia;
      _selectCodDistritoManual = _listDistritos[0].codigoDistrito;
      _valueDistrito = _listDistritos[0].descripcion;
      print(_selectCodDistrito);

      update(['distrito']);

      await selectDistritoManual(value, _selectCodProvincia, _selectCodDistritoManual,true);
    }
    //update(['distrito']);
    
  }

  selectDistritoManual(UbigeoModel value,String codProvincia,String codDistrito ,bool estado) async {
    
    _listCentrosPoblados = [];
    List<UbigeoModel> dataCentroPoblados =[];
    print(value.codigoDistrito);
    if(estado == true){
      dataCentroPoblados = await DBProvider.db.getAllCentrosPoblados(codProvincia, "22", codDistrito);
    }else{
      dataCentroPoblados = await DBProvider.db.getAllCentrosPoblados(value.codigoProvincia, "22", value.codigoDistrito);
    }
    
    //print(dataCentroPoblados.length);

    for (var i = 0; i < dataCentroPoblados.length; i++) {
      _listCentrosPoblados.add(dataCentroPoblados[i]);
    }
    _selectCodCentroPoblado = _listCentrosPoblados[0].codigoCentroPoblado;
    if(codDistrito == ""){
      _selectCodDistritoManual = value.codigoDistrito;
    }else{
      _selectCodDistritoManual = codDistrito;
    }
    
    _valueCentroPoblado = _listCentrosPoblados[0].descripcion;

    update(['centroPoblado']);

  }

  selectedCentroPoblado(UbigeoModel value) {
    _selectCodCentroPoblado = value.codigoCentroPoblado;
  }
  
  changeCentroPoblado(String valor){
    _valueCentroPoblado = valor;
    update(['centroPoblado']);
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
    print(dataUbi);
    var result = dataUbi.where((element) => element.contains(value.codigoDepartamento));


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
    _listCentrosPoblados = [];
    List temporalDistrito = [];
    _selectCodDistrito = "";

    List result = dataUbi.where((element) => element.contains(value.codigoDepartamento + value.codigoProvincia)).toList();
    print(result.length);

    result.forEach((element) {
      temporalDistrito.add(element);
    });

    print(temporalDistrito);
    for (var d = 0; d < temporalDistrito.length; d++) {
      List<UbigeoModel> dataDistritos = await DBProvider.db.getDistrito1(
        temporalDistrito[d].toString().substring(2, 4),
        temporalDistrito[d].toString().substring(0, 2),
        temporalDistrito[d].toString().substring(4, 6)
      );
      _listDistritos.add(dataDistritos[0]);
    }
   
    _valueDistrito          = _listDistritos[0].descripcion;
    _selectCodProvincia     = value.codigoProvincia;
    _selectCodDistrito      = _listDistritos[0].codigoDistrito;
    print(_selectCodDistrito);
    update(['distrito'],true);
    await centroPobladoSelected(dataUbi, _listDistritos[0]); 
  }

  centroPobladoSelected(List<String> dataUbi, UbigeoModel value) async{
    _listCentrosPoblados = [];
    List temporalCentroPoblado = [];
    List result = dataUbi.where((element) => element.contains(value.codigoDepartamento + value.codigoProvincia + value.codigoDistrito)).toList();
    print(result.length);
    result.forEach((element) {
      temporalCentroPoblado.add(element);
    });
    print(temporalCentroPoblado);
    for (var i = 0; i < temporalCentroPoblado.length; i++) {
      List<UbigeoModel> dataCentroPoblados = await DBProvider.db.getCentroPoblado(
        temporalCentroPoblado[i].toString().substring(2, 4),
        temporalCentroPoblado[i].toString().substring(0, 2),
        temporalCentroPoblado[i].toString().substring(4, 6),
        temporalCentroPoblado[i].toString().substring(6, 10),
      );
      _listCentrosPoblados.add(dataCentroPoblados[0]);
    }
    _valueCentroPoblado     = _listCentrosPoblados[0].descripcion;
    _selectCodCentroPoblado = _listCentrosPoblados[0].codigoCentroPoblado;
    update(['centroPoblado'],true);

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
  final bool tieneUbigeo;
  const DropDownDepartamento({Key key, this.showDepartamentos, this.dataUbi, this.tieneUbigeo})
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
                  value.descripcion.toUpperCase(),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              onTap: () async {
                //print(value.codigoDepartamento);
                if(tieneUbigeo == true){
                  _.selectedDepartamento(dataUbi, value);
                }else{

                }
                
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
                  value.descripcion.toUpperCase(),
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
                  value.descripcion.toUpperCase(),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              onTap: () async {
                if (isManual == true) {
                  _.selectDistritoManual(value,"","",false);
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
          value: _.valueCentroPoblado,
          items: _.listCentroPoblados.map((value) {
            return DropdownMenuItem(
              value: value.descripcion,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.descripcion.toUpperCase(),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              onTap: () async {
                if (isManual == true) {
                  _.selectedCentroPoblado(value);
                } else {
                  _.selectedCentroPoblado(value);
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
