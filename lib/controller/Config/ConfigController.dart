import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Parcela/ParcelaCoordenadas.dart';
import 'package:gsencuesta/model/Parcela/ParcelaMoodel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';
import 'package:gsencuesta/model/Ubigeo/UbigeoModel.dart';
import 'package:gsencuesta/model/Usuarios/UsuariosModel.dart';
import 'package:gsencuesta/pages/Parcela/ParcelasPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/database.dart';
import '../../model/Ficha/FichasModel.dart';
import '../../model/Multimedia/MultimediaModel.dart';
import '../../model/Respuesta/RespuestaModel.dart';
import '../../model/Tracking/TrackingModal.dart';
import '../../services/apiServices.dart';
import '../../services/apiServices.dart';

class ConfigController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadData();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  String _cantidadFinalizadas = "";
  String get cantidadFinalizadas => _cantidadFinalizadas;
  ApiServices apiConexion = new ApiServices();
  List<EncuestadoModel> _encuestadosLista = [];

  loadData() async {
    List<FichasModel> listFichas = await DBProvider.db.fichasPendientes('F');

    _cantidadFinalizadas = listFichas.length.toString();
    update();
  }

  sendDataToServer() async {
    Get.back();
    List data = [];
    List<FichasModel> listFichas = await DBProvider.db.fichasPendientes('F');
    ApiServices apiConexion = new ApiServices();

    for (var i = 0; i < listFichas.length; i++) {
      
      var dataEncuesta = await DBProvider.db.getOneEncuesta(listFichas[i].idEncuesta.toString());
      print(dataEncuesta);

      List<RespuestaModel> listRespuestaDBlocal = await DBProvider.db.getAllRespuestasxFicha(listFichas[i].idFicha.toString());
      List<TrackingModel> listTracking = await DBProvider.db.getAllTrackingOfOneSurvery(listFichas[i].idFicha.toString());
      List<MultimediaModel> listMultimedia = await DBProvider.db.getAllMultimediaxFicha(listFichas[i].idFicha.toString());

      DateTime now = DateTime.now();
      var utc = now.toUtc();
      var part = utc.toString().split(" ");
      var fecha = part[0].toString();
      var hora = part[1].toString();
      String fechaFin = fecha + "T" + hora;

      var sendFicha = {};
      sendFicha['idficha'] = listFichas[i].idFicha;
      sendFicha['fechaFin'] = fechaFin;
      sendFicha['fechaInicio'] = listFichas[i].fecha_inicio;
      sendFicha['idUsuario'] = listFichas[i].idUsuario;
      sendFicha["latitud"] = listFichas[i].latitud;
      sendFicha["longitud"] = listFichas[i].longitud;
      sendFicha["observacion"] = listFichas[i].observacion;
      sendFicha["ubigeo"] = listFichas[i].ubigeo;
      sendFicha["fechaRetomo"] = listFichas[i].fecha_retorno == null ||
              listFichas[i].fecha_retorno == "null"
          ? ""
          : listFichas[i].fecha_retorno.toString();
      sendFicha["latitudRetomo"] = listFichas[i].latitud_retorno == null
          ? ""
          : listFichas[i].latitud_retorno;
      sendFicha["longitudRetomo"] = listFichas[i].longitud_retorno == null
          ? ""
          : listFichas[i].longitud_retorno;
      sendFicha["fechaEnvio"] = fechaFin;



      var encuesta = {};
      encuesta["idEncuesta"] = listFichas[i].idEncuesta;
      encuesta["encuestadoIngresoManual"] = dataEncuesta[0].encuestadoIngresoManual;
      sendFicha['encuesta'] = encuesta;



      var encuestado = {};
      if(dataEncuesta[0].encuestadoIngresoManual == "true"){
        List<EncuestadoModel> dataEncuestado = await DBProvider.db.getOneEncuestado(listFichas[i].idEncuestado.toString());
        for (var i = 0; i < dataEncuestado.length; i++) {
          encuestado["idEncuestado"]    = "0";
          encuestado["apellidoMaterno"] = dataEncuestado[i].apellidoMaterno;
          encuestado["apellidoPaterno"] = dataEncuestado[i].apellidoPaterno;
          encuestado["direccion"]       = dataEncuestado[i].direccion;
          encuestado["documento"] = dataEncuestado[i].documento;
          encuestado["email"] = dataEncuestado[i].email;
          encuestado["estado"] = dataEncuestado[i].estado;
          encuestado["estadoCivil"] = dataEncuestado[i].estadoCivil;
          encuestado["foto"] = dataEncuestado[i].foto;
          encuestado["idTecnico"] = dataEncuestado[i].idTecnico;
          encuestado["idUbigeo"] = dataEncuestado[i].idUbigeo;
          encuestado["nombre"] = dataEncuestado[i].nombre;
          encuestado["representanteLegal"] = dataEncuestado[i].representanteLegal;
          encuestado["sexo"] = dataEncuestado[i].sexo;
          encuestado["telefono"] = dataEncuestado[i].telefono;
          encuestado["tipoDocumento"] = "DNI";
          encuestado["tipoPersona"] = "NATURAL";
          encuestado["validadoReniec"] = dataEncuestado[i].validadoReniec;
        }
        sendFicha['encuestado'] = encuestado;

      }else{
        encuestado["idEncuestado"] = listFichas[i].idEncuestado;
        sendFicha['encuestado'] = encuestado;
      }
      
      var respuesta = {};
      List<Map> listRespuestaMap =  [];//new List();

      var pregunta = {};

      for (var i = 0; i < listRespuestaDBlocal.length; i++) {
        bool b = listRespuestaDBlocal[i].estado.toLowerCase() == 'true';
        pregunta["idPregunta"] = listRespuestaDBlocal[i].idPregunta.toInt();

        respuesta["idRespuesta"] = listRespuestaDBlocal[i].idRespuesta.toInt();
        respuesta["idsOpcion"] = listRespuestaDBlocal[i].idsOpcion;
        respuesta["valor"] = listRespuestaDBlocal[i].valor;
        respuesta["estado"] = b; //listRespuestaDBlocal[i].estado;
        respuesta["pregunta"] = pregunta;

        listRespuestaMap.add(respuesta);

        sendFicha['respuesta'] = listRespuestaMap;

        respuesta = {};
        pregunta = {};
      }

      var tracking = {};
      List<Map> listTrackingMap =  []; //new List();

      for (var i = 0; i < listTracking.length; i++) {
        bool b = listTracking[i].estado.toLowerCase() == 'true';

        tracking["idTracking"] = listTracking[i].idTracking;
        tracking["latitud"] = listTracking[i].latitud;
        tracking["longitud"] = listTracking[i].longitud;
        tracking["estado"] = b; //listTracking[x].estado;

        listTrackingMap.add(tracking);

        sendFicha['tracking'] = listTrackingMap;
        tracking = {};
      }

      var multimedia = {};
      List<Map> listMultimediaMap =  []; //new List();

      for (var z = 0; z < listMultimedia.length; z++) {
        multimedia["idMultimedia"] = listMultimedia[z].idMultimedia;
        multimedia["latitud"] = listMultimedia[z].latitud;
        multimedia["longitud"] = listMultimedia[z].longitud;
        multimedia["url"] = listMultimedia[z].tipo;
        multimedia["nombre"] = listMultimedia[z].nombre;

        listMultimediaMap.add(multimedia);

        sendFicha['multimedia'] = listMultimediaMap;
        multimedia = {};
      }

      data.add(sendFicha);
    }
    ;
    

    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

    if (data.length > 0) {
      int contador = 0;

      if (conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile) {
        modal(true, false);

        for (var x = 0; x < data.length; x++) {
          var response = await apiConexion.sendFichaToServer(data[x]);

          if(response == 1){
            print("token");
            showModal("Estimado usuario su token expiro.",false,"Error inesperado");
            Future.delayed(Duration(seconds: 2),(){
              Get.back();
            });
          }else if(response == 2){
            showModal("Error de servidor comuniquese con el administrador del sistema.",false,"Error inesperado");
            Future.delayed(Duration(seconds: 2),(){
              Get.back();
              
            });
            print("error server");
          }else if(response == 3){
            print("error 404 o bad request");
            showModal("Error por parte del cliente, apunta a una ruta desconocia o envia mal los datos, comuniquese con el administrador del sistema.",false,"Error inesperado");
            Future.delayed(Duration(seconds: 2),(){
              Get.back();
        
            });
          }else{
            var _estado = "S";
            await DBProvider.db.updateFicha(data[x]['idficha'].toString(),data[x]['observacion'], data[x]['fechaFin'], _estado, "");
            contador++;
            if(contador == data.length){
              Get.back();
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 60,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Los datos se subieron exitosamente.',
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                barrierDismissible: false
              );
              Future.delayed(Duration(seconds: 2), () {
                _cantidadFinalizadas = "0";
                Get.back();
                update();
              });
              
            }

          }
          
        }
        //aca el else
      } else {
        Get.dialog(AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Notificación'),
          content: Text(
              'Usted no cuenta con conexión a internet, vuelva intentarlo más tarde'),
        ));
      }
    }
  }

  showModal(String mensaje, bool loading, String titulo){
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        title: Text(titulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            loading == true ? 
            CircularProgressIndicator() : Container(),
            SizedBox(height: 8,),
            mensaje == "" || mensaje == null ? Container(): Text(mensaje)
          ],
        ),
      )
    );
  }

  modal(bool isLoading, bool hayFinalizadas) {
    Get.dialog(
      AlertDialog(
        title:
            isLoading ? Text('Sincronizando los datos') : Text('Notificación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? CircularProgressIndicator()
                : hayFinalizadas
                    ? Text(
                        '¿Desea subir las $_cantidadFinalizadas fichas finalizadas?')
                    : Text('No tiene encuestas que sincronizar.')
          ],
        ),
        actions: isLoading
            ? []
            : hayFinalizadas
                ? [
                    Container(
                      height: 40,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Color.fromRGBO(0, 102, 84, 1),
                        onPressed: () {
                          sendDataToServer();
                        },
                        child: Text('Subir'),
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
                  ]
                : [],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
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

  navigateToParcela() async {
    Get.to(ParcelaPage());
  }

  modalLoadingDescargar() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Descargando datos..'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tiempo estimado de descarga 3 min'),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  loadingStatus(String message, String status) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Notificación'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$message'),
          SizedBox(
            height: 20,
          ),
          status == "Success"
              ? Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                )
              : Icon(
                  Icons.cancel,
                  color: Colors.redAccent,
                  size: 60,
                )
        ],
      ),
    ));
  }

  mostrarMensajeModal() {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Center(child: Text('¡Importante!')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Usted esta a punto de truncar (eliminar) los datos que se encuentra en el dispositivo movil, para actualizar con los nuevos datos del servidor.'),
          SizedBox(
            height: 12,
          ),
          Text('¿Está seguro de querer realizar la acción?')
        ],
      ),
      actions: [
        Container(
          height: 40,
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color.fromRGBO(0, 102, 84, 1),
            onPressed: () {
              //deleteFicha(idFicha);
              Get.back();
              downloadAllDataToServer();
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
    ));
  }

  downloadAllDataToServer() async {
    modalLoadingDescargar();
    //mostrarMensajeModal();
    var response = await deleteAllMasterTable();
    if (response == 1) {
      var response2 = await loadDataToServer();
      if (response2 == 1) {
        Get.back();
        loadingStatus("Se descargo toda la data exitosamente", "Success");
      } else {
        Get.back();
        loadingStatus(
            "Error al momento de descargar los datos, comuniquese con el encargado del sistema",
            "CANCEL");
      }
    } else {
      Get.back();
      loadingStatus(
          "Error al momento de eliminar las tablas maestras de la aplicación, comuniquese con el encargado del sistema",
          "CANCEL");
    }

    //loadingStatus("Se descargo toda la data exitosamente","Cancel");

    //Get.back();
  }

  deleteAllMasterTable() async {
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

    return 1;
  }

  loadDataToServer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    ConnectivityResult conectivityResult =
        await Connectivity().checkConnectivity();

    if (conectivityResult == ConnectivityResult.wifi ||
        conectivityResult == ConnectivityResult.mobile) {
      print('hay conexion a internet');

      await loadUsers();
      var ubigeo = preferences.getString('ubigeoCargo');
      if(ubigeo != "si"){
        await loadUbigeo();
      }
      await loadEncuestados();
      await cargarProyectosEncuesta();
      var response = await loadParcelas();
      if (response == 1) {
        return 1;
      } else {
        return 2;
      }
    } else {
      Get.back();
      loadingStatus(
          "Usted no cuenta con servicio a internet, intentelo más tarde",
          "CANCEL");
    }
  }

  loadUsers() async {
    List<UsuarioModel> _usuarios = [];
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
    for (var i = 0; i < _usuarios.length; i++) {
      await DBProvider.db.insertUsuarios(_usuarios[i]);
    }
    print('Todos los usuarios fueron descargados');
  }

  loadUbigeo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var ubigeoCargo = preferences.setString('ubigeoCargo','si');

    var response = await rootBundle.loadString("assets/ubi.json");
    var data = json.decode(response);
    print(data.runtimeType);

    List<UbigeoModel> data1 =
        (data as List).map((e) => UbigeoModel.fromJson(e)).toList();

    for (var x = 0; x < data1.length; x++) {
      await DBProvider.db.insertUbigeo(data1[x]);
    }
    List<UbigeoModel> ubigeos = await DBProvider.db.getAllUbigeo();
    if(ubigeos.length > 0){
      Get.back();
      print('Todos los ubigeos fueron descargados');
    }
    
  }

  cargarProyectosEncuesta() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<ProyectoModel> _proyectos = [];
    List<EncuestaModel> _encuestas = [];
    List<PreguntaModel> _preguntas = [];
    List<OpcionesModel> _opcionesPreguntas = [];
    var listProyecto = await apiConexion.getProyectos();
    if (listProyecto != 1 && listProyecto != 2 && listProyecto != 3) {
      if (listProyecto.length == 0) {
        print('no hay proyectos');
        //_isLoading = false;
        //_hayData = false;
        var insertDataLocal = "Si";
        preferences.setString('primeraCarga', insertDataLocal);
        //update();

        //return;
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
            idUsuario: preferences.getString('idUsuario')?? "",
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
          _encuestas.add(
            EncuestaModel(
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
              encuestadoIngresoManual:item['encuestadoIngresoManual'].toString(),
              tipoVista: item["tipoVista"],
              createdAt: item["createdAt"],
              updatedAt: item["updatedAt"]
            )
          );
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
                bloqueDescripcion: item["bloque"]["nombre"]
            ),
          );
          List preguOpcion = item["preguntaGrupoOpcion"];
          if (preguOpcion.length > 0) {
            int idPreguOpcion = preguOpcion[0]["idPreguntaGrupoOpcion"];
            var listOpciones = preguOpcion[0]["grupoOpcion"]["opcion"];
            listOpciones.forEach((item2) {
              _opcionesPreguntas.add(OpcionesModel(
                idOpcion                : item2["idOpcion"],
                idPreguntaGrupoOpcion   : idPreguOpcion.toString(),
                idPregunta              : idPregunta,
                valor                   : item2["valor"],
                label                   : item2["label"],
                orden                   : item2["orden"],
                estado                  : item2["estado"].toString(),
                createdAt               : item2["createdAt"],
                updated_at              : item2["updatedAt"],
                requiereDescripcion     : item2["requiereDescripcion"].toString()
              ));
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
      var result = await DBProvider.db.getAllOpciones();
      print(result);
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
    //var insertDataLocal = "Si";
    //_proyectos = [];
    //preferences.setString('primeraCarga', insertDataLocal);

    print('Los proyectos, encuestas y preguntas se descargaron exitosamente');
  }

  /*loadEncuestados() async {
    List<EncuestadoModel> _encuestadosLista = [];
    var listEncuestados = await apiConexion.getAllEncuestado2();
    if (listEncuestados != 1 && listEncuestados != 2 && listEncuestados != 3) {
      
      print(listEncuestados);
      for (var i = 0; i < listEncuestados.length; i++) {
        var listEncuestados2 = listEncuestados[i]["encuestado"];
        print(listEncuestados2["documento"]);
        _encuestadosLista.add(
            EncuestadoModel(
              idEncuestado: listEncuestados2["idEncuestado"].toString(),
              documento: listEncuestados2["documento"],
              nombre: listEncuestados2["nombre"],
              apellidoPaterno: listEncuestados2["apellidoPaterno"],
              apellidoMaterno: listEncuestados2["apellidoMaterno"],
              sexo: listEncuestados2["sexo"],
              estadoCivil: listEncuestados2["estadoCivil"],
              direccion: listEncuestados2["direccion"],
              telefono: listEncuestados2["telefono"],
              email: listEncuestados2["email"],
              idUbigeo: listEncuestados2["idUbigeo"],
              estado: listEncuestados2["estado"].toString(),
              foto: listEncuestados2["foto"]
            )
          );      
      }

    }

    for (var e = 0; e < _encuestadosLista.length; e++) {
      await DBProvider.db.insertEncuestados(_encuestadosLista[e]);
    }

    var data = await DBProvider.db.getAllEncuestado();
    if (data.length > 0) {
      print("Se registro todos los encuestados");
    }

    var result2 = await DBProvider.db.getLastEncuestado();
    print(result2);
    print('Se descargaron los encuestados exitosamente');
  }*/

  loadEncuestados() async {
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

  loadParcelas() async {
    List<ParcelaModel> _listParcelas = [];
    List<ParcelaCoordenadasModel> _listParcelaCoordenada = [];
    var listParcelas = await apiConexion.getAllParcelas();
    for (var i = 0; i < listParcelas.length; i++) {
      List<EncuestadoModel> beneficiario = await DBProvider.db
          .getOneEncuestado(listParcelas[i]["idSeccion"].toString());

      /*var foto = beneficiario[0].foto;
      Uint8List _photoBase64 = base64Decode(foto);
      _listParcelas.add(
        ParcelaModel(
          idParcela       : listParcelas[i]["idParcela"],
          descripcion     : listParcelas[i]["descripcion"],
          idSeccion       : listParcelas[i]["idSeccion"],
          seccion         : listParcelas[i]["seccion"],
          area            : listParcelas[i]["area"],
          ubigeo          : listParcelas[i]["ubigeo"],
          foto            : _photoBase64,
          nombreCompleto  : beneficiario[0].nombre + " " + beneficiario[0].apellidoPaterno + " " + beneficiario[0].apellidoMaterno,    
          createdAt       : listParcelas[i]["createdAt"],
          updatedAt       : listParcelas[i]["updatedAt"]
        )
      );*/
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
    print('Todas las parcelas se descargaron exitosamente');
    return 1;
  }
}
