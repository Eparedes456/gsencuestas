import 'dart:convert';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:easyping/easyping.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Departamento/DepartamentoModel.dart';
import 'package:gsencuesta/model/Distritos/DistritosModel.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Parametro/Parametromodel.dart';
import 'package:gsencuesta/model/Parcela/ParcelaCoordenadas.dart';
import 'package:gsencuesta/model/Parcela/ParcelaMoodel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Provincia/ProvinciaModel.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';
import 'package:flutter/material.dart';
import 'package:gsencuesta/model/Usuarios/UsuariosModel.dart';
import 'package:gsencuesta/pages/Encuesta/EncuestaPage.dart';
import 'package:gsencuesta/pages/Parcela/ParcelasPage.dart';
import 'package:gsencuesta/pages/Perfil/ProfilePage.dart';
import 'package:gsencuesta/pages/Proyecto/ProyectoPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gsencuesta/model/Ubigeo/UbigeoModel.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

class PrincipalController extends GetxController {
  List<ProyectoModel> _proyectos = [];
  List<ProyectoModel> get proyectos => _proyectos;

  /* Modelo de lista de usuarios de usuarios */

  List<UsuarioModel> _usuarios = [];
  List<EncuestaModel> _encuestas = [];
  List<EncuestaModel> get listEncuesta => _encuestas;
  List<PreguntaModel> _preguntas = [];
  List<OpcionesModel> _opcionesPreguntas = [];
  List<EncuestadoModel> _encuestadosLista = [];
  List<ParametroModel> _parametros = [];
  List<DepartamentoModel> _listDepartamento = [];
  List<ProvinciaModel> _listProvincia = [];
  List<DistritoModel> _listDistrito = [];
  List<ParcelaModel> _listParcelas = [];
  List<ParcelaCoordenadasModel> _listParcelaCoordenada = [];
  List<UbigeoModel> _listUbigeos = [];
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hayData = false;
  bool get haydata => _hayData;

  bool hayEncuestas = false;
  bool isLoadingEncuestas = false;

  String _nombreProyecto = "";
  String get nombreProyecto => _nombreProyecto;

  /*Dinammica o estatica boleanos */
  bool presionadoEstatica = false;
  bool presionadoDinamica = false;
  String valor = "";
  /* */

  TextEditingController _controllerSearch = new TextEditingController();
  TextEditingController get controllerSearch => _controllerSearch;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //this.getProyectos();
    this.checkVersion();
    //this.validarCarga();
  }

  ApiServices apiConexion = new ApiServices();
  

  navigateToProfile() {
    Get.to(ProfilePage());
  }


  checkVersion()async{
    
    SharedPreferences pref = await SharedPreferences.getInstance();
    
    final info = await PackageInfo.fromPlatform();
    print(info);

    var versionAndroid = info.version == null || info.version == "" ? "" :info.version ;
    var versioniOS =  info.version == null || info.version == "" ? "" :info.version;
    

    var response = await apiConexion.getVersionsApp();

    var isDrastico = false;

    var prefresp = pref.getBool('drastico');

    if(prefresp == null){

       if (Platform.isAndroid) {
      
        if(versionAndroid == response[0]['versionAndroid']){
          validarCarga();
        }else{
          showModalUpdateApp('android',isDrastico);
          print('hay nueva actualizacion de la aplicacion');
        }

      } else if (Platform.isIOS) {
        if(versioniOS == response[0]['versionIos']){
          validarCarga();
        }else{
          showModalUpdateApp('ios',isDrastico);
          print('hay nueva actualizacion de la aplicacion');
        }
      }
      

    } else if( isDrastico == prefresp ){
      validarCarga();
    } else{

        if (Platform.isAndroid) {
      
        if(versionAndroid == response[0]['versionAndroid']){
          validarCarga();
        }else{
          showModalUpdateApp('android',isDrastico);
          print('hay nueva actualizacion de la aplicacion');
        }

      } else if (Platform.isIOS) {
        if(versioniOS == response[0]['versionIos']){
          validarCarga();
        }else{
          showModalUpdateApp('ios',isDrastico);
          print('hay nueva actualizacion de la aplicacion');
        }
      }

    }

    

    //print(response[0]['versionAndroid']);

  }



  
  showModalUpdateApp(String icon, bool isDrastico){
    Get.dialog(
      
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        title: Text('Actualización de GSEncuesta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tenemos una nueva versión de GSEncuesta, presione "Descargar" a continuación para obtener la ultima versión más reciente de las tiendas digitales'),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: ()async{
                var androidurl = "https://play.google.com/store/apps/details?id=pe.gob.regionsanmartin.gsencuesta";
                var iOSurl = "https://apps.apple.com/pe/app/gsencuesta/id1566926144";

                if (Platform.isAndroid) {
      
                    if (  await canLaunch(androidurl)) {
                      await launch(androidurl);
                    } 
                      else {
                          throw 'Could not launch $androidurl';
                    }

                } else if (Platform.isIOS) {
                  
                  if (  await canLaunch(iOSurl)) {
                      await launch(iOSurl);
                    } 
                      else {
                          throw 'Could not launch $iOSurl';
                    }

                }
                  
                
              },
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon( icon == "android"? FontAwesomeIcons.googlePlay : FontAwesomeIcons.appStore,color: Colors.white),
                    SizedBox(width: 20,),
                    Text('Descargar',style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ),
            SizedBox(height: 12,),
            isDrastico == true ?  Container():
            GestureDetector(
              onTap: ()async{
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool('drastico', false);
                
                Get.back();
                validarCarga();
              },
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Descargar, más tarde',style: TextStyle(color: Colors.white),),
                    SizedBox(width: 20,),
                    Icon( Icons.arrow_forward_ios,color: Colors.white),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
      
      barrierDismissible: false,
      
    );
  }

  

  validarCarga() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    ConnectivityResult conectivityResult =
        await Connectivity().checkConnectivity();
    var ubigeo = preferences.getString('ubigeoCargo');
    if (ubigeo != "si") {
              loadingUbigeo();
              await cargarUbigeo();
    }else{
      loading();
    }
    var flag1 = preferences.getString('primeraCarga');
    if (conectivityResult == ConnectivityResult.wifi ||
        conectivityResult == ConnectivityResult.mobile) {
      print('hay conexion a internet');
      print('verifico en la tabla parametros para actualziar o no hacer nada');
      List<ParametroModel> dataParametro = await DBProvider.db.getParametros();
      //print(dataParametro);
      if (dataParametro.length > 0) {
        var fechaActuUsuario =
            dataParametro[0].ultiimaActualizacionUsuario.toString();
        var fechaActuInstitucion =
            dataParametro[0].ultimaActualizacion.toString();
        var idInstitucion = dataParametro[0].idInstitucion;

        var response = await apiConexion.getParametroUsuario();

        if (fechaActuUsuario == response["ultimaActualizacionUsuario"]) {
          print("si coinciden");
        } else {
          print(
              'descargar los nuevos usuarios para guardar en la base de datos local');
          await DBProvider.db.deleteAllUsuario();
          
          var listUserApi = await apiConexion.getAllUsers();
          listUserApi.forEach((item) {
            _usuarios.add(UsuarioModel(
              idUsuario: item["idUsuario"],
              nombre: item["nombre"],
              apellidoPaterno: item["apellidoPaterno"],
              apellidoMaterno: item["apellidoMaterno"],
              dni: item["dni"],
              email: item["email"],
              username: item["login"],
              password: item["password"],
              foto: item["foto"],
              estado: item["estado"].toString(),
              createdAt: item["createdAt"],
            ));
          });
          print(_usuarios);
          for (var i = 0; i < _usuarios.length; i++) {
            await DBProvider.db.insertUsuarios(_usuarios[i]);
          }
          await DBProvider.db.updateParametros(fechaActuInstitucion,
              idInstitucion, response["ultimaActualizacionUsuario"]);
        }
        var resp = await apiConexion.getParametroMaestro();
        if (fechaActuInstitucion == resp["ultimaActualizacion"]) {
          print('si coinciden, no hacer nada');
        } else {
          //print('No coinciden, eliminar toda la data de las tablas maestras y actualizar con la nueva data');
          List<FichasModel> listPendientes =
              await DBProvider.db.fichasPendientes('P');
          List<FichasModel> listFinalizadas =
              await DBProvider.db.fichasPendientes('F');
          var pendientesLength =
              listPendientes.length.toString() + " fichas pendientes";
          var finalizadaslenght =
              listFinalizadas.length.toString() + " fichas finalizadas";
          if (listPendientes.length > 0 || listFinalizadas.length > 0) {
            if (pendientesLength == "0 fichas pendientes") {
              pendientesLength = "";
            }
            if (finalizadaslenght == "0 fichas finalizadas") {
              finalizadaslenght = "";
            }
            Get.dialog(AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Notificación',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              content: Text(
                  'Se encontró una actualización, no se puede proceder ya que usted cuenta con  $pendientesLength $finalizadaslenght para subir al servidor'),
              actions: [
                Container(
                  height: 40,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Color.fromRGBO(0, 102, 84, 1),
                    onPressed: () async {
                      Get.back();
                    },
                    child: Text('Ok',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ));
          } else {
            print('eliminar datas maestras');
            await DBProvider.db.deleteAllUsuario(); //  usuario table
            //await DBProvider.db.deleteAllUbigeo(); // ubigeo table
            await DBProvider.db.deleteAllParcelas(); // parcelas table
            await DBProvider.db.deleteallEncuestas(); // encuestas table
            await DBProvider.db.deleteallProyectos(); //proyectos table
            await DBProvider.db.deleteallEncuestados(); //encuestados table
            await DBProvider.db.deleteallPreguntas(); // preguntas table
            await DBProvider.db.deleteallOpciones(); //opciones table
            await DBProvider.db.deletAllBloque(); // bloque table
            await DBProvider.db.deletAllFichas(); // fichas table
            //await DBProvider.db.deletAllRespuesta(); // respuestas table
            //await DBProvider.db.deletAllTracking(); // tracking table
            //await DBProvider.db.deletAllMultimedia(); // multimedia table
            await DBProvider.db
                .deletAllParcelaCoordenadas(); // parcela coordenadas table

            await DBProvider.db.updateParametros(resp["ultimaActualizacion"],
                idInstitucion, response["ultimaActualizacionUsuario"]);
            
            
            await cargarEncuestados();
            await cargarUsuarios();
            await cargarParcelas();
            await cargarProyectosEncuesta();

            //await cargarUbigeo();
            Get.back();
          }
        }
      }

      if (flag1 == null) {
        insertUserDb();
      } else {
        _proyectos = [];
        var listProyecto = await apiConexion.getProyectos();
        if (listProyecto != 1 && listProyecto != 2 && listProyecto != 3) {
          listProyecto.forEach((item) {
            _proyectos.add(ProyectoModel(
                idProyecto: item["idProyecto"],
                nombre: item["nombre"],
                abreviatura: item["abreviatura"],
                nombreResponsable: item["nombre_responsable"],
                logo: item["logo"],
                latitud: item["latitud"],
                longitud: item["longitud"],
                estado: item["estado"].toString(),
                createdAt: item["createdAt"],
                updatedAt: item["updatedAt"]));
          });
          _proyectos.add(ProyectoModel(
            idProyecto: 3000,
            nombre: "Encuestas estáticas",
            logo: "",
          ));
          if (_proyectos.length > 0) {
            _isLoading = false;
            _hayData = true;
          } else {
            print('no hay proyectos');
            _isLoading = false;
            _hayData = false;
          }
        } else if (listProyecto == 1) {
          print('Error de servidor');
        } else if (listProyecto == 2) {
          print(' eRROR DE TOKEN');
        } else {
          print('Error, no existe la pagina 404');
        }
        Get.back();
      }
    } else {
      if (flag1 != null) {
        print('Consulto mi base de datos local');
        var idUsuario = int.parse(preferences.getString('idUsuario'));
        _proyectos = await DBProvider.db.getAllProyectos();
        if (_proyectos.length > 0) {
          _isLoading = false;
          _hayData = true;
        } else {
          print('no hay proyectos');
          _isLoading = false;
          _hayData = false;
        }
      }
    }
    update();
  }

  insertUserDb() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var flag = preferences.getString('primeraCarga');

    if (flag == "Si") {
      print("Consulto a la base de datos a la tabla proyecto");
    } else {

      var ubigeo = preferences.getString('ubigeoCargo');
      /*if (ubigeo != "si") {
        loadingUbigeo();
        await cargarUbigeo();
      }*/

      /*E liminar las data */
      await DBProvider.db.deleteAllUsuario(); //  usuario table
      //await DBProvider.db.deleteAllUbigeo(); // ubigeo table
      await DBProvider.db.deleteAllParcelas(); // parcelas table
      await DBProvider.db.deleteallEncuestas(); // encuestas table
      await DBProvider.db.deleteallProyectos(); //proyectos table
      await DBProvider.db.deleteallEncuestados(); //encuestados table
      await DBProvider.db.deleteallPreguntas(); // preguntas table
      await DBProvider.db.deleteallOpciones(); //opciones table
      await DBProvider.db.deletAllBloque(); // bloque table
      await DBProvider.db.deletAllFichas(); // fichas table
      await DBProvider.db.deletAllRespuesta(); // respuestas table
      //await DBProvider.db.deletAllTracking(); // tracking table
      //await DBProvider.db.deletAllMultimedia(); // multimedia table
      await DBProvider.db
          .deletAllParcelaCoordenadas(); // parcela coordenadas table

      /* Cargar data  */

      await cargarUsuarios();
      await cargarEncuestados();

      var parametro = await apiConexion.getParametroUsuario();
      if (parametro != 1 && parametro != 2 && parametro != 3) {
        print(parametro["idParametro"]);
        _parametros.add(ParametroModel(
          idParametro: parametro["idParametro"],
          ultiimaActualizacionUsuario: parametro["ultimaActualizacionUsuario"],
          idInstitucion: 1,
          ultimaActualizacion: "",
        ));
        print(_parametros.length);
        for (var e = 0; e < _parametros.length; e++) {
          await DBProvider.db.insertParametros(_parametros[e]);
        }
      }
      var parametro1 = await apiConexion.getParametroMaestro();
      if (parametro1 != 1 && parametro1 != 2 && parametro1 != 3) {
        await DBProvider.db.updateParametros(
            parametro1["ultimaActualizacion"],
            parametro1["idInstitucion"],
            parametro["ultimaActualizacionUsuario"]);
      }
      List<ParametroModel> dataParametro2 = await DBProvider.db.getParametros();
      print(dataParametro2);
      await cargarParcelas();
      await cargarProyectosEncuesta();
      
      _isLoading = false;
      _hayData = true;

      
      
      update();
      Get.back();
    }
  }

  loading(){
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12,),
            Text('Cargando las encuestas...')
          ],
        ),
      )
    );
  }

  searchProyecto(String value) async {
    _proyectos = [];
    if (value == "" || value == null) {
      List<ProyectoModel> resultado =
          await DBProvider.db.searchProyecto(controllerSearch.text);
      if (resultado.length == 0) {
      } else {
        _proyectos = resultado;
        _hayData = true;
        update();
      }
    } else {
      List<ProyectoModel> resultado =
          await DBProvider.db.searchProyecto(controllerSearch.text);
      if (resultado.length == 0) {
        _hayData = false;
        _proyectos = [];
        update();
      } else {
        _proyectos = resultado;
        _hayData = true;
        update();
      }
    }
  }

  navigateToProyecto(ProyectoModel proyecto) {
    Get.to(ProyectoPage(), arguments: proyecto //this._proyectos
        );
  }

  exit() {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text('Notificación'),
      content: Text('¿Está seguro de cerrar la aplicación?'),
      actions: [
        Container(
          height: 40,
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color.fromRGBO(0, 102, 84, 1),
            onPressed: () async {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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

  cargarEncuestados() async {
    var listEncuestados = await apiConexion.getAllEncuestado2();
    if (listEncuestados != 1 && listEncuestados != 2 && listEncuestados != 3) {
      print(listEncuestados);
      for (var i = 0; i < listEncuestados.length; i++) {
        var listEncuestados2 = listEncuestados[i]["encuestado"];
        print(listEncuestados2["documento"]);
        _encuestadosLista.add(EncuestadoModel(
            idEncuestado    : listEncuestados2["idEncuestado"].toString(),
            documento       : listEncuestados2["documento"],
            nombre          : listEncuestados2["nombre"],
            apellidoPaterno : listEncuestados2["apellidoPaterno"],
            apellidoMaterno : listEncuestados2["apellidoMaterno"],
            sexo            : listEncuestados2["sexo"],
            estadoCivil     : listEncuestados2["estadoCivil"],
            direccion       : listEncuestados2["direccion"],
            telefono        : listEncuestados2["telefono"],
            email           : listEncuestados2["email"],
            idUbigeo        : listEncuestados2["idUbigeo"],
            estado          : listEncuestados2["estado"].toString(),
            idInstitucion   : listEncuestados[i]["idInstitucion"].toString(),
            foto: listEncuestados2["foto"]));
      }
    }
    for (var e = 0; e < _encuestadosLista.length; e++) {
      await DBProvider.db.insertEncuestados(_encuestadosLista[e]);
    }
    var data = await DBProvider.db.getAllEncuestado();
    if (data.length > 0) {
      print("Se registro todos los encuestados");
    }
  }

  cargarParcelas() async {
    var listParcelas = await apiConexion.getAllParcelas();
    for (var i = 0; i < listParcelas.length; i++) {
      List<EncuestadoModel> beneficiario = await DBProvider.db
          .getOneEncuestado(listParcelas[i]["idSeccion"].toString());
      if (beneficiario.length > 0) {
        var foto = beneficiario[0].foto;
        Uint8List _photoBase64 = base64Decode(foto);
        _listParcelas.add(ParcelaModel(
            idParcela: listParcelas[i]["idParcela"],
            descripcion: listParcelas[i]["descripcion"],
            idSeccion: listParcelas[i]["idSeccion"],
            seccion: listParcelas[i]["seccion"],
            area: listParcelas[i]["area"],
            ubigeo: listParcelas[i]["ubigeo"],
            foto: _photoBase64,
            nombreCompleto: beneficiario[0].nombre +
                " " +
                beneficiario[0].apellidoPaterno +
                " " +
                beneficiario[0].apellidoMaterno,
            createdAt: listParcelas[i]["createdAt"],
            updatedAt: listParcelas[i]["updatedAt"]));
      }

      for (var x = 0; x < listParcelas[i]["parcelaCoordenada"].length; x++) {
        _listParcelaCoordenada.add(ParcelaCoordenadasModel(
            idParcela: listParcelas[i]["idParcela"],
            idBeneficiario: listParcelas[i]["idSeccion"],
            latitud: listParcelas[i]["parcelaCoordenada"][x]["latitud"],
            longitud: listParcelas[i]["parcelaCoordenada"][x]["longitud"]));
      }
    }
    for (var i = 0; i < _listParcelas.length; i++) {
      await DBProvider.db.insertParcela(_listParcelas[i]);
    }

    for (var z = 0; z < _listParcelaCoordenada.length; z++) {
      await DBProvider.db.insertParcelaCoordenadas(_listParcelaCoordenada[z]);
    }
    print('se inserto todas las parcelas');
  }

  cargarProyectosEncuesta() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var listProyecto = await apiConexion.getProyectos();
    if (listProyecto != 1 && listProyecto != 2 && listProyecto != 3) {
      if (listProyecto.length == 0) {
        print('no hay proyectos');
        _isLoading = false;
        _hayData = false;
        var insertDataLocal = "Si";
        preferences.setString('primeraCarga', insertDataLocal);
        update();
        return;
      }
      listProyecto.forEach((item) {
        _proyectos.add(ProyectoModel(
            idProyecto: item["idProyecto"],
            nombre: item["nombre"],
            abreviatura: item["abreviatura"],
            nombreResponsable: item["nombre_responsable"],
            logo: item["logo"],
            latitud: item["latitud"],
            longitud: item["longitud"],
            idUsuario: preferences.getString('idUsuario'),
            estado: item["estado"].toString(),
            createdAt: item["createdAt"],
            updatedAt: item["updatedAt"]));
      });
      _proyectos.add(ProyectoModel(
        idProyecto: 3000,
        nombre: "Encuestas estáticas",
        logo: "",
        abreviatura: "",
        nombreResponsable: "",
        latitud: "",
        longitud: "",
        idUsuario: "",
        estado: "",
        createdAt: "",
        updatedAt: "",
      ));

      for (var x = 0; x < _proyectos.length; x++) {
        var data = await DBProvider.db.getAllProyectos();
        print(data);
        await DBProvider.db.insertProyectos(_proyectos[x]);
        var data1 = await DBProvider.db.getAllProyectos();
        print(data1);
      }

      for (var j = 0; j < _proyectos.length; j++) {
        var listEncuestaApi = await apiConexion
            .getEncuestasxProyecto(_proyectos[j].idProyecto.toString());
        var idProyecto = _proyectos[j].idProyecto.toString();
        listEncuestaApi.forEach((item) {
          _encuestas.add(EncuestaModel(
              idEncuesta: item["idEncuesta"],
              idProyecto: idProyecto.toString(),
              titulo: item["titulo"],
              descripcion: item["descripcion"],
              url_guia: item["url_guia"],
              expira: item["expira"].toString(),
              fechaInicio: item["fechaInicio"],
              fechaFin: item["fechaFin"],
              logo: item["logo"],
              dinamico: item["dinamico"].toString(),
              esquema: item["esquema"],
              estado: item["estado"].toString(),
              sourceMultimedia: item["sourceMultimedia"],
              publicado: item['publicado'].toString(),
              requeridoObservacion: item['requeridoObservacion'].toString(),
              requeridoMultimedia: item['requeridoMultimedia'].toString(),
              esRetomado: item['esRetomado'].toString(),
              encuestadoIngresoManual:
                  item['encuestadoIngresoManual'].toString(),
              tipoVista: item["tipoVista"],
              createdAt: item["createdAt"],
              updatedAt: item["updatedAt"]));
        });
      }
      for (var m = 0; m < _encuestas.length; m++) {
        await DBProvider.db.insertEncuestasxProyecto(_encuestas[m]);
      }
      List listPreguntas = [];
      for (var n = 0; n < _encuestas.length; n++) {
        var idEncuesta = _encuestas[n].idEncuesta.toString();
        var listPreguntasxEncuesta =
            await apiConexion.getPreguntasxEncuesta(idEncuesta);
        listPreguntas = listPreguntasxEncuesta["pregunta"];
        listPreguntas.asMap().forEach((index, item) async {
          int idPregunta = item["idPregunta"];
          _preguntas.add(
            PreguntaModel(
                id_pregunta: item["idPregunta"],
                id_bloque: item["id_bloque"],
                idEncuesta: int.parse(idEncuesta),
                enunciado: item["enunciado"],
                tipo_pregunta: item["tipoPregunta"]["questionType"],
                apariencia: item["apariencia"]["appearance"],
                requerido: item["requerido"].toString(),
                requerido_msj: item["requerido_msj"],
                readonly: item["readonly"].toString(),
                defecto: item["defecto"],
                calculation: item["calculation"],
                restriccion: item["restriccion"].toString(),
                restriccion_msj: item["restriccion_msj"],
                relevant: item["relevant"],
                choice_filter: item["choice_filter"],
                bind_name: item["name"],
                bind_type: item["bindType"],
                bind_field_length: item["bindFieldLength"].toString(),
                bind_field_placeholder: item["bindFieldPlaceholder"],
                orden: item["orden"],
                estado: item["estado"].toString(),
                updated_at: item["updatedAt"],
                created_at: item["createdAt"],
                index1: index,
                bloqueDescripcion: item["bloque"]["nombre"]),
          );
          List preguOpcion = item["preguntaGrupoOpcion"];
          if (preguOpcion.length > 0) {
            int idPreguOpcion = preguOpcion[0]["idPreguntaGrupoOpcion"];
            var listOpciones = preguOpcion[0]["grupoOpcion"]["opcion"];
            listOpciones.forEach((item2) {
              _opcionesPreguntas.add(OpcionesModel(
                  idOpcion: item2["idOpcion"],
                  idPreguntaGrupoOpcion: idPreguOpcion.toString(),
                  idPregunta: idPregunta,
                  valor: item2["valor"],
                  label: item2["label"],
                  orden: item2["orden"],
                  estado: item2["estado"].toString(),
                  createdAt: item2["createdAt"],
                  updated_at: item2["updatedAt"],
                  requiereDescripcion:
                      item2["requiereDescripcion"].toString()));
            });
          }
        });
      }
      for (var e = 0; e < _preguntas.length; e++) {
        await DBProvider.db.insertPreguntasxEncuestas(_preguntas[e]);
      }
      for (var r = 0; r < _opcionesPreguntas.length; r++) {
        await DBProvider.db.insertOpcionesxPregunta(_opcionesPreguntas[r]);
      }
      if (_proyectos.length > 0) {
        /*_isLoading = false;
        _hayData = true;
        update();*/
      }
    } else if (listProyecto == 1) {
      print('Error de servidor');
    } else if (listProyecto == 2) {
      print(' eRROR DE TOKEN');
    } else {
      print('Error, no existe la pagina 404');
    }
    var insertDataLocal = "Si";
    //_proyectos = [];
    preferences.setString('primeraCarga', insertDataLocal);
    print('se inserto todos los  proyectos');
    update();
  }

  cargarUsuarios() async {
    var listUserApi = await apiConexion.getAllUsers();
    listUserApi.forEach((item) {
      _usuarios.add(UsuarioModel(
        idUsuario: item["idUsuario"],
        nombre: item["nombre"],
        apellidoPaterno: item["apellidoPaterno"],
        apellidoMaterno: item["apellidoMaterno"],
        dni: item["dni"],
        email: item["email"],
        username: item["login"],
        password: item["password"],
        foto: item["foto"],
        fechaAlta: item["fechaAlta"],
        perfil: item['perfil']['nombre'],
        estado: item["estado"].toString(),
        createdAt: item["createdAt"],
      ));
    });

    for (var i = 0; i < _usuarios.length; i++) {
      await DBProvider.db.insertUsuarios(_usuarios[i]);
    }
    print('se inserto todos los usuarios');
  }

  cargarUbigeo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var ubigeoCargo = preferences.setString('ubigeoCargo', 'si');

    var response = await rootBundle.loadString("assets/ubi.json");
    var data = json.decode(response);
    print(data.runtimeType);

    List<UbigeoModel> data1 =
        (data as List).map((e) => UbigeoModel.fromJson(e)).toList();
    //print(data1);
    /*var ubi = UbigeoModel.fromMap(data);
    print(ubi);*/

    /*data.forEach((element){
      _listUbigeos.add(
        UbigeoModel(
          idUbigeo            : element["id"],
          codigoDepartamento  : element["codigoDepartamento"],
          codigoProvincia     : element["codigoProvincia"],
          codigoDistrito      : element["codigoDistrito"],
          descripcion         : element["descripcion"] 
        )
      );
    });*/

    for (var x = 0; x < data1.length; x++) {
      await DBProvider.db.insertUbigeo(data1[x]);
      print(x);
    }
    List<UbigeoModel> ubigeos = await DBProvider.db.getAllUbigeo();
    /*if (ubigeos.length > 0) {
      _isLoading = false;
      _hayData = true;
      update();
      Get.back();
    }*/

    //Get.back();
  }

  loadingUbigeo() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Notificación',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Se está cargando los datos de las siguientes tablas:'),
            Text('- Encuestadores'),
            Text('- Encuestados'),
            Text('- Proyecto'),
            Text('- Encuesta'),
            Text('- Preguntas'),
            Text('- Ubigeo'),
            SizedBox(
              height: 20,
            ),
            Center(child: CircularProgressIndicator()),
            SizedBox(
              height: 20,
            ),
            Text(
                'Está operación se realiza sólo una vez, tiempo estimado de carga 28 a 40 segundos aproximadamente.')
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  loadEncuestas(int id_proyecto, String proyectonombre) async {
    _nombreProyecto = proyectonombre;
    _encuestas = [];
    print(id_proyecto);
    ConnectivityResult conectivityResult =
        await Connectivity().checkConnectivity();

    /*if( conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

      var resultado = await apiConexion.getEncuestasxProyecto(id_proyecto.toString());

      if(resultado != 1 && resultado != 2 && resultado  != 3 ){

        resultado.forEach((item){
          _encuestas.add(

            EncuestaModel(

              createdAt           : item["createdAt"].toString(),
              updatedAt           : item["updatedAt"].toString(),
              idEncuesta          : item["idEncuesta"],
              titulo              : item["titulo"].toString(),
              descripcion         : item["descripcion"].toString(),
              url_guia            : item["url_guia"].toString(), 
              expira              : item["expira"].toString(),
              fechaInicio         : item["fechaInicio"].toString(),
              fechaFin            : item["fechaFin"].toString(),
              logo                : item["logo"].toString(),
              dinamico            : item["dinamico"].toString(),
              esquema             : item["esquema"].toString(),
              estado              : item["estado"].toString(),
              sourceMultimedia    : item["sourceMultimedia"], 
            )

          );


        });
        print(_encuestas.length);

        if(_encuestas.length > 0){

          isLoadingEncuestas = true;
          hayEncuestas = true;

        }else{
          print('no hay encuestas');
          isLoadingEncuestas = false;
          hayEncuestas = false;
        }



      }else if( resultado == 1){

        print('Error de servidor');

      }else if(resultado == 2){

        print(' eRROR DE TOKEN');

      }else{

        print('Error, no existe la pagina 404');

      }

    }else{*/
    _encuestas =
        await DBProvider.db.consultEncuestaxProyecto(id_proyecto.toString());

    print(_encuestas);

    print(_encuestas.length);

    if (_encuestas.length > 0) {
      isLoadingEncuestas = false;
      hayEncuestas = true;
    } else {
      isLoadingEncuestas = false;
      hayEncuestas = false;
    }

    //}
    update();
    //loadEncuestas(id_proyecto.toString());
  }

  navigateToEncuesta(var encuestaPage) {
    Get.to(EncuestaPage(), arguments: [encuestaPage, _nombreProyecto]);
  }

  validarEcuestaDiEst(bool estatica, bool dinamica, int id_proyecto,
      String proyectonombre) async {
    if (estatica == true && dinamica == false) {
      presionadoEstatica = estatica;
      presionadoDinamica = dinamica;
      valor = "estáticas";
    } else if (estatica == false && dinamica == true) {
      presionadoEstatica = estatica;
      presionadoDinamica = dinamica;
      valor = "dinámicas";
      loadEncuestas(id_proyecto, proyectonombre);
    }
    update();
  }

  navigateToParcela() async {
    Get.to(ParcelaPage());
  }
}
