import 'package:geolocator/geolocator.dart';
import 'package:gsencuesta/model/Departamento/DepartamentoModel.dart';
import 'package:gsencuesta/model/Distritos/DistritosModel.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Multimedia/MultimediaModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Parametro/Parametromodel.dart';
import 'package:gsencuesta/model/Parcela/ParcelaCoordenadas.dart';
import 'package:gsencuesta/model/Parcela/ParcelaMoodel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Provincia/ProvinciaModel.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';
import 'package:gsencuesta/model/Respuesta/RespuestaModel.dart';
import 'package:gsencuesta/model/Tracking/TrackingModal.dart';
import 'package:gsencuesta/model/Ubigeo/UbigeoModel.dart';
import 'package:gsencuesta/model/Usuarios/UsuariosModel.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  //creamos la base de datos y las tablas correspondiente a la base de datos de  Encuestas

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'gsencuesta2.db'),
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE encuesta(

            idEncuesta INTEGER PRIMARY KEY,
            idProyecto TEXT,
            titulo TEXT,
            descripcion TEXT,
            url_guia TEXT,
            expira TEXT,
            fechaInicio TEXT,
            fechaFin TEXT,
            logo TEXT,
            dinamico TEXT,
            esquema TEXT,
            sourceMultimedia TEXT,
            publicado TEXT,
            requeridoObservacion TEXT,
            requeridoMultimedia TEXT,
            esRetomado TEXT,
            encuestadoIngresoManual TEXT,
            tipoVista TEXT,
            estado  TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
        
        
          ''');

      await db.execute('''
          
          CREATE TABLE bloque(

            id_bloque INTEGER PRIMARY KEY AUTOINCREMENT,
            id_encuesta INTEGER,
            nombre TEXT,
            icono TEXT,
            estado INTEGER,
            updated_at TEXT,
            foreign key(id_encuesta) references encuesta(id_encuesta) 

          )
          
          ''');

      await db.execute('''
          CREATE TABLE pregunta(

            idPregunta INTEGER PRIMARY KEY,
            id_bloque INTEGER,
            idEncuesta INTEGER,
            enunciado TEXT,
            tipo_pregunta TEXT,
            apariencia TEXT,
            requerido INTEGER,
            requerido_msj TEXT,
            readonly TEXT,
            defecto TEXT,
            calculation TEXT,
            restriccion TEXT,
            restriccion_msj TEXT,
            relevant TEXT,
            choice_filter TEXT,
            bind_name TEXT,
            bind_type TEXT,
            bind_field_length TEXT,
            bind_field_placeholder TEXT,
            orden INTEGER,
            estado TEXT,
            created_at TEXT,
            updated_at TEXT,
            index1      INTEGER,
            bloqueDescripcion TEXT
          )

          ''');

      await db.execute('''
        
          CREATE TABLE opcion(

            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_opcion INTEGER,
            idPreguntaGrupoOpcion TEXT,
            idPregunta INTEGER,
            valor TEXT,
            label TEXT,
            orden INTEGER,
            requiereDescripcion TEXT,
            estado TEXT,
            createdAt TEXT,
            updated_at TEXT
            

          )''');

      await db.execute('''

          CREATE TABLE ficha(

            idFicha INTEGER PRIMARY KEY AUTOINCREMENT,
            idEncuesta INTEGER,
            idUsuario  INTEGER,
            idEncuestado INTEGER,
            latitud TEXT,
            longitud TEXT,
            latitud_retorno TEXT,
            longitud_retorno TEXT,
            fecha_inicio TEXT,
            fecha_fin TEXT,
            fecha_retorno TEXT,
            fecha_envio   TEXT,
            observacion TEXT,
            ubigeo      TEXT,
            estado TEXT,
            updated_at TEXT
          
          )

          ''');

      await db.execute('''
          CREATE TABLE respuesta(

            idRespuesta INTEGER PRIMARY KEY AUTOINCREMENT,
            idPregunta INTEGER,
            idFicha INTEGER,
            idsOpcion TEXT,
            valor TEXT,
            tipoPregunta TEXT,
            estado TEXT         
          )

          ''');

      await db.execute('''
          CREATE TABLE usuario(

            idUsuario INTEGER PRIMARY KEY,
            nombre TEXT,
            apellidoPaterno TEXT,
            apellidoMaterno TEXT,
            dni TEXT,
            email TEXT,
            username TEXT,
            password TEXT,
            foto TEXT,
            fechaAlta TEXT,
            perfil TEXT,
            estado TEXT,
            createdAt TEXT
           

          )

          ''');

      await db.execute('''
          CREATE TABLE proyecto(
            idProyecto INTEGER PRIMARY KEY,
            nombre TEXT,
            abreviatura TEXT,
            nombreResponsable TEXT,
            logo TEXT,
            latitud TEXT,
            longitud TEXT,
            idUsuario INTEGER,
            estado TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )

          ''');

      await db.execute('''
          CREATE TABLE tracking(
            idTracking INTEGER PRIMARY KEY AUTOINCREMENT,
            idFicha INTEGER,
            latitud TEXT,
            longitud TEXT,
            estado TEXT

          )

          ''');

      await db.execute('''
          CREATE TABLE multimedia(
            idMultimedia INTEGER PRIMARY KEY AUTOINCREMENT,
            idFicha INTEGER,
            tipo TEXT,
            latitud TEXT,
            longitud TEXT,
            nombre TEXT,
            fecha_captura TEXT,
            estado TEXT

          )

          ''');

      await db.execute('''
          CREATE TABLE encuestado(
            idEncuestado INTEGER PRIMARY KEY AUTOINCREMENT,
            documento TEXT,
            nombre TEXT,
            apellidoPaterno TEXT,
            apellidoMaterno TEXT,
            sexo TEXT,
            estadoCivil TEXT,
            direccion TEXT,
            telefono TEXT,
            email TEXT,
            foto TEXT,
            idUbigeo TEXT,
            validadoReniec TEXT,
            idTecnico TEXT,
            idInstitucion TEXT,
            estado TEXT

          )

          ''');

      await db.execute('''
          CREATE TABLE parametro(
            idParametro INTEGER PRIMARY KEY AUTOINCREMENT,
            ultiimaActualizacionUsuario TEXT,
            idInstitucion INTEGER,
            ultimaActualizacion TEXT
          )
          ''');

      await db.execute('''
          CREATE TABLE departamento(
            idDepartamento INTEGER PRIMARY KEY AUTOINCREMENT,
            codigoDepartamento TEXT,
            descripcion TEXT,
            estado TEXT
          )
          ''');

      await db.execute('''
          CREATE TABLE provincia(
            idProvincia INTEGER PRIMARY KEY AUTOINCREMENT,
            codigoDepartamento TEXT,
            codigoProvincia TEXT,
            descripcion TEXT,
            estado TEXT
          )
          ''');

      await db.execute('''
          CREATE TABLE distrito(
            idDistrito INTEGER PRIMARY KEY AUTOINCREMENT,
            codigoDepartamento TEXT,
            codigoProvincia TEXT,
            codigoDistrito TEXT,
            descripcion TEXT,
            estado TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE parcelaCoordenadas(
            idParcelaCoordenada INTEGER PRIMARY KEY AUTOINCREMENT,
            idParcela INTEGER,
            idBeneficiario INTEGER,
            latitud TEXT,
            longitud TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE ubigeo(
            idUbigeo INTEGER PRIMARY KEY AUTOINCREMENT,
            codigoDepartamento TEXT,
            codigoProvincia TEXT,
            codigoDistrito TEXT,
            codigoCentroPoblado TEXT,
            descripcion TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE parcelas(
            idParcela INTEGER PRIMARY KEY AUTOINCREMENT,
            descripcion TEXT,
            idSeccion INTEGER,
            seccion TEXT,
            area TEXT,
            foto TEXT,
            nombreCompleto TEXT,
            ubigeo TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
          ''');
    }, version: 13);
  }

  //CREACION DE   LAS CONSULTAS SQL LOCAL

  /*Consulta traer todos los usuarios */
  getAllUsuarios() async {
    final db = await database;
    var respuesta = await db.query("usuario");

    List<UsuarioModel> listUser = respuesta.isNotEmpty
        ? respuesta.map((e) => UsuarioModel.fromMap(e)).toList()
        : [];

    return listUser;
  }

  /*Consulta insertar todos los usuarios */

  insertUsuarios(UsuarioModel nuevoUsuario) async {
    final db = await database;
    var respuesta = await db.insert("usuario", nuevoUsuario.toMap());
    return respuesta;
  }

  /* Consulta de eliminar a todos los usuarios TRUNCATE TABLE usuario */

  deleteAllUsuario() async {
    final db = await database;
    var respuesta = await db.delete("usuario");
  }

  /* Consulta de login  */
  consultLogueo(String username, String pass) async {
    final db = await database;

    var respuesta = await db.rawQuery('''
      SELECT * FROM usuario WHERE username = '$username'
      ''');

    //print(respuesta);

    List<UsuarioModel> listUser = respuesta.isNotEmpty
        ? respuesta.map((e) => UsuarioModel.fromMap(e)).toList()
        : [];

    return listUser;
  }

  dataUser(String value) async {
    final db = await database;
    var response = await db.rawQuery('''
      SELECT * FROM usuario WHERE username = '$value'
      ''');
    List<UsuarioModel> dataUser = response.isNotEmpty
        ? response.map((e) => UsuarioModel.fromMap(e)).toList()
        : [];
    return dataUser;
  }

  /*Consulta de insertar los proyectos */

  insertProyectos(ProyectoModel nuevoProyecto) async {
    final db = await database;
    var respuesta = await db.insert("proyecto", nuevoProyecto.toMap());
    return respuesta;
  }

  /* Consultar todos los proyectos  */

  getAllProyectos1(var idUsuario) async {
    final db = await database;

    //var respuesta = await db.query("proyecto");
    var respuesta = await db.rawQuery('''
      SELECT * FROM proyecto WHERE idUsuario = $idUsuario
      ''');
    List<ProyectoModel> listProyectos = respuesta.isNotEmpty
        ? respuesta.map((e) => ProyectoModel.fromMap(e)).toList()
        : [];
    return listProyectos;
  }

  getAllProyectos() async {
    final db = await database;

    var respuesta = await db.query("proyecto");

    List<ProyectoModel> listProyectos = respuesta.isNotEmpty
        ? respuesta.map((e) => ProyectoModel.fromMap(e)).toList()
        : [];
    return listProyectos;
  }

  /* Consultar un proyecto */

  getOneProyecto(String idProyecto) async {
    final db = await database;

    var response = await db.rawQuery('''
      SELECT * FROM proyecto WHERE idProyecto = $idProyecto

      ''');

    List<ProyectoModel> listProyectos = response.isNotEmpty
        ? response.map((e) => ProyectoModel.fromMap(e)).toList()
        : [];

    return listProyectos;
  }

  /*Eliminar todos los proyectos */
  deleteallProyectos() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM proyecto
      ''');
    return respuesta;
  }

  /*Consulta de insertar las encuestas por proyecto */

  insertEncuestasxProyecto(EncuestaModel nuevoEncuesta) async {
    final db = await database;
    var respuesta = await db.insert("encuesta", nuevoEncuesta.toMap());
    return respuesta;
  }

  /* Traer todas las encuestas  */

  getAllEncuestas() async {
    final db = await database;
    var respuesta = await db.query("encuesta");

    List<EncuestaModel> listEncuesta = respuesta.isNotEmpty
        ? respuesta.map((e) => EncuestaModel.fromMap(e)).toList()
        : [];

    return listEncuesta;
  }

  getOneEncuesta(String idEncuesta) async {
    final db = await database;

    var respuesta = await db.rawQuery('''
      SELECT * FROM encuesta WHERE idEncuesta = '$idEncuesta'
      ''');

    List<EncuestaModel> listEncuesta = respuesta.isNotEmpty
        ? respuesta.map((e) => EncuestaModel.fromMap(e)).toList()
        : [];

    return listEncuesta;
  }

  getOnesEncuesta(String idEncuesta) async {
    final db = await database;

    var respuesta = await db.rawQuery('''
      SELECT * FROM encuesta WHERE idEncuesta = '$idEncuesta'
      ''');

    /*List<EncuestaModel> listEncuesta = respuesta.isNotEmpty ? 
      respuesta.map((e) => EncuestaModel.fromMap(e)).toList() :[];*/

    //return listEncuesta;
    return respuesta;
  }

  /*Eliminar encuestas */
  deleteallEncuestas() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM encuesta
      ''');
    return respuesta;
  }

  /* Consulta de traer encuestas relacionados a un proyecto en especifico*/
  consultEncuestaxProyecto(String idProyecto) async {
    final db = await database;

    var respuesta = await db.rawQuery('''
      SELECT * FROM encuesta WHERE idProyecto = '$idProyecto'
      ''');

    List<EncuestaModel> listEncuesta = respuesta.isNotEmpty
        ? respuesta.map((e) => EncuestaModel.fromMap(e)).toList()
        : [];

    return listEncuesta;
  }

  /* CONSULTA DE INSERCIÓN DE LA TABLA PREGUNTAS */

  /*Consulta de insertar las encuestas por proyecto */

  insertPreguntasxEncuestas(PreguntaModel nuevaPregunta) async {
    final db = await database;
    var respuesta = await db.insert("pregunta", nuevaPregunta.toMap());
    return respuesta;
  }

  /* Traer todas las preguntas  */

  getAllPreguntas() async {
    final db = await database;
    var respuesta = await db.query("pregunta");

    List<PreguntaModel> listPregunta = respuesta.isNotEmpty
        ? respuesta.map((e) => PreguntaModel.fromMap(e)).toList()
        : [];

    return listPregunta;
  }

  /* Eliminar todas las preguntas */

  deleteallPreguntas() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM pregunta
      ''');
    return respuesta;
  }

  /* Consulta de traer encuestas relacionados a un proyecto en especifico*/
  consultPreguntaxEncuesta(String idEncuesta) async {
    final db = await database;

    var respuesta = await db.rawQuery('''
      SELECT * FROM pregunta WHERE idEncuesta = '$idEncuesta' ORDER BY orden ASC
      ''');

    List<PreguntaModel> listPreguntas = respuesta.isNotEmpty
        ? respuesta.map((e) => PreguntaModel.fromMap(e)).toList()
        : [];

    return listPreguntas;
  }

  /*Consulta de insertar las opciones por pregunta */

  insertOpcionesxPregunta(OpcionesModel nuevaOpcion) async {
    final db = await database;
    var respuesta = await db.insert("opcion", nuevaOpcion.toMap());
    return respuesta;
  }

  /* Traer todas las opciones  */

  getAllOpciones() async {
    final db = await database;
    var respuesta = await db.query("opcion");

    List<OpcionesModel> listOpciones = respuesta.isNotEmpty
        ? respuesta.map((e) => OpcionesModel.fromMap(e)).toList()
        : [];

    return listOpciones;
  }

  /* Traer Opciones por pregunta */

  getOpcionesxPregunta(String idPregunta) async {
    final db = await database;

    var respuesta = await db.rawQuery('''
      SELECT * FROM opcion WHERE idPregunta = $idPregunta
      
      ''');

    /*List<OpcionesModel> listOpcionesxPregunta = respuesta.isNotEmpty ? 
      respuesta.map((e) => OpcionesModel.fromMap(e)).toList() :[];*/

    return respuesta;
  }

  /* Eliminar todas las opciones */
  deleteallOpciones() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM opcion
      ''');
    return respuesta;
  }

  /*Eliminar bloque */
  deletAllBloque() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM bloque
      ''');
    return respuesta;
  }

  /* Eliminar fichas*/
  deletAllFichas() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM ficha
      ''');
    return respuesta;
  }

  /*Eliminar respuestas */
  deletAllRespuesta() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM respuesta
      ''');
    return respuesta;
  }

  /*Eliminar todos los tracking */
  deletAllTracking() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM tracking
      ''');
    return respuesta;
  }

  /*Eliminar todas las multimedias */
  deletAllMultimedia() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM multimedia
      ''');
    return respuesta;
  }

  /* Eliminar todas las parcelas con coordenadas */

  deletAllParcelaCoordenadas() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM parcelaCoordenadas
      ''');
    return respuesta;
  }

  /* insertar y creaciòn  de nueva ficha */

  insertNewFicha(int idEncuesta, int idEncuestado, String fechaInicio,
      String latitud, String longitud, String ubigeo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int idUsuario = int.parse(preferences.getString('idUsuario'));

    final db = await database;

    return await db.rawQuery('''
      INSERT INTO ficha(idEncuesta, idUsuario, idEncuestado, latitud, longitud, fecha_inicio,
      fecha_fin, observacion, ubigeo ,estado , updated_at) VALUES('$idEncuesta', '$idUsuario', '$idEncuestado', '$latitud', '$longitud' , '$fechaInicio' , 'NO REGISTRA', 'NO REGISTRA' ,'$ubigeo' ,'P' , 'NO REGISTRA')

      ''');
  }

  /* Traer todas las fichas insertadas */

  getAllFichas(var idUsuario) async {
    final db = await database;
    //var response = await db.query('ficha',orderBy: 'DESC',);
    var response = await db.rawQuery('''
      SELECT * FROM ficha WHERE idUsuario = $idUsuario ORDER BY idFicha DESC
      ''');
    print(response);
    List<FichasModel> listFichas = response.isNotEmpty
        ? response.map((e) => FichasModel.fromMap(e)).toList()
        : [];
    return listFichas;
  }

  /* Traer la ultima ficha insertada */

  getLastFicha() async {
    final db = await database;
    var response1 = await db.rawQuery('''
      SELECT MAX(idFicha) as idFicha from ficha

      ''');
    return response1;
  }

  /* Traer una ficha especifica */

  oneFicha(String idFicha) async {
    final db = await database;
    var response = await db.rawQuery('''
      SELECT * FROM ficha WHERE  idFicha = $idFicha
      ''');
    List<FichasModel> fichaList = response.isNotEmpty
        ? response.map((e) => FichasModel.fromMap(e)).toList()
        : [];
    return fichaList;
  }

  fichasPendientes(String valor) async {
    final db = await database;

    var response = await db.rawQuery('''
      SELECT * FROM ficha WHERE estado = '$valor'
      
      ''');
    List<FichasModel> fichaList = response.isNotEmpty
        ? response.map((e) => FichasModel.fromMap(e)).toList()
        : [];
    return fichaList;
  }

  /* Actualizar FICHA */

  updateFicha(String idFicha, String observa, String fechafinal, String estado,
      String fecha_retorno) async {
    final db = await database;
    var response2 = await db.rawQuery('''
      UPDATE ficha SET  estado = "$estado",observacion = '$observa', fecha_fin = "$fechafinal"
       WHERE idFicha = "$idFicha"

      ''');

    var response1 = await db.query('ficha');

    List<FichasModel> listFichas = response1.isNotEmpty
        ? response1.map((e) => FichasModel.fromMap(e)).toList()
        : [];

    print(listFichas);
    return listFichas;
    //return response;
  }

  /* Actualizar ficha el campo retorno */

  updateFechaRetorno(String idFicha, String fecha_retorno, String latitud,
      String longitud) async {
    final db = await database;
    var response = await db.rawQuery('''
      UPDATE ficha SET fecha_retorno = '$fecha_retorno', latitud_retorno = '$latitud', longitud_retorno = '$longitud' WHERE idFicha = '$idFicha'
      ''');
    var response1 = await db.query('ficha');

    List<FichasModel> listFichas = response1.isNotEmpty
        ? response1.map((e) => FichasModel.fromMap(e)).toList()
        : [];

    print(listFichas);
    return listFichas;
  }

  /* Actualizar ficha el campo retorno */

  updateFechaEnvio(String idFicha, String fecha_envio) async {
    final db = await database;
    var response = await db.rawQuery('''
      UPDATE ficha SET fecha_envio = '$fecha_envio' WHERE idFicha = '$idFicha'
      ''');
    var response1 = await db.query('ficha');

    List<FichasModel> listFichas = response1.isNotEmpty
        ? response1.map((e) => FichasModel.fromMap(e)).toList()
        : [];

    print(listFichas);
    return listFichas;
  }

  /* Eliminar una ficha */

  deleteOneFicha(String idFicha) async {
    final db = await database;

    var response = await db.rawQuery('''
      DELETE FROM ficha WHERE idFicha = $idFicha

      ''');

    return response;
  }

  /* Consulta traer todos los trackings de las fichas */

  getAllTrackings() async {
    final db = await database;

    var response = await db.query('tracking');

    List<TrackingModel> trackingList = response.isNotEmpty
        ? response.map((e) => TrackingModel.fromMap(e)).toList()
        : [];

    return trackingList;
  }

  /* Traer todos los registros de tracking de una encuesta especifica */

  getAllTrackingOfOneSurvery(String idFicha) async {
    final db = await database;
    var response = await db.rawQuery('''
      SELECT * FROM tracking WHERE idFicha = $idFicha
      
      ''');

    List<TrackingModel> trackingList = response.isNotEmpty
        ? response.map((e) => TrackingModel.fromMap(e)).toList()
        : [];

    return trackingList;
  }

  /* Consulta de insertar los trackings de las fichas  */

  insertTracking(
      String idFicha, String latitud, String longitud, String estado) async {
    final db = await database;
    var response = await db.rawQuery('''
      
      INSERT INTO tracking(idFicha,latitud,longitud,estado) VALUES('$idFicha','$latitud','$longitud','$estado')
      
      ''');
  }

  /* Insertar Respuesta  */

  insertRespuesta(
      String idPregunta, String idFicha, String idsOpcion, String ubigeo,String tipoPregunta) async {
    final db = await database;

    print(ubigeo);


    var response = await db.rawQuery('''
      INSERT INTO respuesta(idPregunta,idFicha,idsOpcion,valor,tipoPregunta,estado) VALUES('$idPregunta','$idFicha','$idsOpcion','$ubigeo','$tipoPregunta','TRUE')
      
      ''');
  }

  /* */

  updateRespuesta(String idPregunta, String valor)async{
    
    final db = await database;
    var response = await db.rawQuery(
      '''
      UPDATE respuesta SET valor = '$valor' WHERE idPregunta = '$idPregunta' 
      '''
    );

  }

  /* Traer todos las respuestas de una ficha */

  getAllRespuestasxFicha(String idFicha) async {
    final db = await database;

    var response = await db.rawQuery('''
      
      SELECT * FROM respuesta WHERE idFicha = '$idFicha'
      
      ''');

    List<RespuestaModel> listRespuesta = response.isNotEmpty
        ? response.map((e) => RespuestaModel.fromMap(e)).toList()
        : [];

    return listRespuesta;
  }

  /* Traer todos las respuestas */

  getAllRespuestas(String idFicha) async {
    final db = await database;

    var response = await db.query(
      'respuesta',
      where: 'idFicha = ?',
      whereArgs: [idFicha]
    );

    List<RespuestaModel> listRespuesta = response.isNotEmpty
        ? response.map((e) => RespuestaModel.fromMap(e)).toList()
        : [];

    return listRespuesta;
  }

  

  eliminarUnaRespuesta(
      String idPregunta, String idFicha, String idsOpcion) async {
    final db = await database;

    var response = await db.rawQuery('''
      
      DELETE FROM respuesta WHERE idPregunta = $idPregunta AND idFicha = $idFicha AND idsOpcion = $idsOpcion

      ''');
  }

  eliminarRespuestasxFicha(String idPregunta, String idFicha) async {
    final db = await database;

    var response = await db.rawQuery('''
      
      DELETE FROM respuesta WHERE idPregunta = $idPregunta AND idFicha = $idFicha 

      ''');
  }

  actualizarRespuestaxFicha(
      String idPregunta, String idFicha, String valor) async {
    final db = await database;
    var response = await db.rawQuery('''
      UPDATE respuesta SET valor = '$valor' WHERE idPregunta = $idPregunta AND idFicha = $idFicha
      ''');

    return 1;
  }

  unaRespuestaFicha(String idFicha, String idPregunta) async {
    final db = await database;

    var response = await db.rawQuery('''
      SELECT * FROM respuesta WHERE idFicha = $idFicha AND idPregunta = $idPregunta 
      
      ''');

    List<RespuestaModel> listRespuesta = response.isNotEmpty
        ? response.map((e) => RespuestaModel.fromMap(e)).toList()
        : [];

    return listRespuesta;
  }

  /* Traer todas las respuesta de una ficha y una encuesta especiffica */

  getAllRespuestasxEncuesta(String idFicha, String idEncuesta) async {
    final db = await database;

    var response = await db.rawQuery('''
      SELECT * FROM respuesta WHERE idFicha = $idFicha
      
      ''');

    List<RespuestaModel> listRespuesta = response.isNotEmpty
        ? response.map((e) => RespuestaModel.fromMap(e)).toList()
        : [];

    return listRespuesta;
  }

  /*Consulta insertar todos los encuestados */

  insertEncuestados(EncuestadoModel nuevoEncuestado) async {
    final db = await database;
    var respuesta = await db.insert("encuestado", nuevoEncuestado.toMap());
    return respuesta;
  }

  getLastEncuestado() async {
    final db = await database;
    var response1 = await db.rawQuery('''
      SELECT MAX(idEncuestado) as idEncuestado, idUbigeo from encuestado

      ''');
    List<EncuestadoModel> listEncuestado = response1.isNotEmpty
        ? response1.map((e) => EncuestadoModel.fromMap(e)).toList()
        : [];

    return listEncuestado;
  }

  /* Buscar al encuestado  */

  searchEncuestado(String valor) async {
    final db = await database;
    //var respuesta = await db.query("encuestado",where: 'documento = ?', whereArgs: [valor]);
    var buscar = valor;
    var respuesta = await db.rawQuery('''
      SELECT * FROM encuestado  WHERE (documento  LIKE "%$buscar%" OR nombre LIKE  "%$buscar%")
      ''');

    List<EncuestadoModel> listEncuestado = respuesta.isNotEmpty
        ? respuesta.map((e) => EncuestadoModel.fromMap(e)).toList()
        : [];

    return listEncuestado;
    //return respuesta; //.toList();
  }

  /* Obtener los encuestados */

  getOneEncuestado(String idEncuestado) async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      SELECT * FROM encuestado WHERE idEncuestado = '$idEncuestado'
      ''');
    List<EncuestadoModel> listEncuestado = respuesta.isNotEmpty
        ? respuesta.map((e) => EncuestadoModel.fromMap(e)).toList()
        : [];

    return listEncuestado;
  }

  getAllEncuestado() async {
    final db = await database;

    var response = await db.rawQuery('''
      SELECT * FROM encuestado 
      ''');
    print(response);
    List<EncuestadoModel> encuestados = response.isNotEmpty
        ? response.map((e) => EncuestadoModel.fromMap(e)).toList()
        : [];
    return encuestados;
  }

  getAllEncuestadoxinstitucion(String idInstitucion) async {
    final db = await database;

    var response = await db.rawQuery('''
      SELECT * FROM encuestado  WHERE idInstitucion = '$idInstitucion'
      ''');
    print(response);
    List<EncuestadoModel> encuestados = response.isNotEmpty
        ? response.map((e) => EncuestadoModel.fromMap(e)).toList()
        : [];
    return encuestados;
  }

  /*Eliminara todos los encuestados */
  deleteallEncuestados() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
      DELETE FROM encuestado
      ''');
    return respuesta;
  }

  /* Traer todos los registros de multimedia de una ficha especifica */

  getAllMultimediaxFicha(String idFicha) async {
    print(idFicha);
    final db = await database;
    var response = await db.rawQuery('''
      SELECT * FROM multimedia WHERE idFicha = $idFicha
      
      ''');

    List<MultimediaModel> multimediaList = response.isNotEmpty
        ? response.map((e) => MultimediaModel.fromMap(e)).toList()
        : [];

    return multimediaList;
  }

  /*  ultimo multimedia*/

  getLastMultimediaxFicha(String idFicha) async {
    print(idFicha);
    final db = await database;
    var response = await db.rawQuery('''
      SELECT MAX(idMultimedia) FROM multimedia WHERE idFicha = $idFicha
      
      ''');

    List<MultimediaModel> multimediaList = response.isNotEmpty
        ? response.map((e) => MultimediaModel.fromMap(e)).toList()
        : [];

    return multimediaList;
  }


  /*Consulta insertar todas las multimedias */

  insertMultimedia(String idFicha, String tipo, String fecha_captura) async {
    final db = await database;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String latitud = position.latitude.toString();
    String longitud = position.longitude.toString();

    var response = await db.rawQuery('''
      INSERT INTO multimedia(idFicha,tipo,latitud,longitud,fecha_captura,estado) VALUES('$idFicha','$tipo','$latitud','$longitud','$fecha_captura','TRUE')
      
      ''');
    return response;
  }

  deletemultimedia(String idMultimedia) async {
    final db = await database;
    var response = await db.rawQuery('''
      DELETE FROM multimedia WHERE idMultimedia = "$idMultimedia"
      ''');

    print(response);
    return response;
  }

  updateMultimedia(String idMultimedia, String name)async{
    final db = await database;
    var response = await db.rawQuery(
      '''
      UPDATE multimedia SET  nombre = '$name' WHERE idMultimedia = '$idMultimedia'
      '''
    );
  }

  searchProyecto(String value) async {
    final db = await database;
    if (value == "" || value == null) {
      var respuesta = await db.query("proyecto");

      List<ProyectoModel> listProyectos = respuesta.isNotEmpty
          ? respuesta.map((e) => ProyectoModel.fromMap(e)).toList()
          : [];

      return listProyectos;
    } else {
      var buscar = "%" + value + "%";
      var response = await db.rawQuery('''
        SELECT * FROM proyecto WHERE nombre LIKE "$buscar"
        ''');

      List<ProyectoModel> listProyectos = response.isNotEmpty
          ? response.map((e) => ProyectoModel.fromMap(e)).toList()
          : [];

      return listProyectos;
    }
  }

  /* Parametro */

  insertParametros(ParametroModel nuevoParametro) async {
    final db = await database;
    var respuesta = await db.insert("parametro", nuevoParametro.toMap());
    return respuesta;
  }

  deleteParametros() async {
    final db = await database;
    var respuesta = await db.delete("parametro");
  }

  updateParametros(String ultimaActualizacion, int idInstitucion,
      String ultimaActuaUsuario) async {
    final db = await database;
    var respuestas = await db.rawUpdate('''
      UPDATE parametro SET idInstitucion = $idInstitucion , ultimaActualizacion = '$ultimaActualizacion', ultiimaActualizacionUsuario = '$ultimaActuaUsuario' WHERE idParametro = 1
      ''');
    return respuestas;
  }

  getParametros() async {
    final db = await database;
    var response = await db.rawQuery('''
      SELECT * FROM parametro
      
      ''');

    List<ParametroModel> parametroData = response.isNotEmpty
        ? response.map((e) => ParametroModel.fromMap(e)).toList()
        : [];

    return parametroData;
  }

  /* Ubigeo */
  insertUbigeo(UbigeoModel nuevoUbigeo) async {
    final db = await database;
    var respuesta = await db.insert("ubigeo", nuevoUbigeo.toMap());
    return respuesta;
  }

  getAllUbigeo() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
        SELECT * FROM ubigeo LIMIT 20
        ''');
    List<UbigeoModel> listUbigeo = respuesta.isNotEmpty
        ? respuesta.map((e) => UbigeoModel.fromJson(e)).toList()
        : [];
    return listUbigeo;
  }

  deleteAllUbigeo() async {
    final db = await database;
    var respuesta = await db.delete("ubigeo");
  }

  /* */

  insertDepartamentos(DepartamentoModel nuevoDepartamento) async {
    final db = await database;
    var respuesta = await db.insert("departamento", nuevoDepartamento.toMap());
    return respuesta;
  }

  insetProvincias(ProvinciaModel nuevoProvincia) async {
    final db = await database;
    var respuesta = await db.insert("provincia", nuevoProvincia.toMap());
    return respuesta;
  }

  insertDistritos(DistritoModel nuevoDistrito) async {
    final db = await database;
    var respuesta = await db.insert("distrito", nuevoDistrito.toMap());
    return respuesta;
  }

  getDepartamentos1(String codDepartamento) async {
    final db = await database;
    var response = await db.rawQuery('''
        SELECT codigoDepartamento,descripcion FROM ubigeo WHERE codigoDepartamento = '$codDepartamento' 
        AND codigoProvincia = '00' AND codigoDistrito = '00'  AND  codigoCentroPoblado = '0000'
        ''');
    List<UbigeoModel> listDepartamento = response.isNotEmpty
        ? response.map((e) => UbigeoModel.fromJson(e)).toList()
        : [];
    return listDepartamento;
  }
  getDepartamentos2(String codDepartamento) async {
    final db = await database;
    var response = await db.rawQuery('''
        SELECT codigoDepartamento,descripcion FROM ubigeo WHERE codigoDepartamento = '$codDepartamento' 
        AND codigoProvincia != '00' AND codigoDistrito = '00'
        ''');
    List<UbigeoModel> listDepartamento = response.isNotEmpty
        ? response.map((e) => UbigeoModel.fromJson(e)).toList()
        : [];
    return listDepartamento;
  }

  getProvincia1(String codigoProvincia, String codigoDepartamento) async {
    final db = await database;
    var response = await db.rawQuery('''
        SELECT * FROM ubigeo WHERE codigoDepartamento = '$codigoDepartamento' 
        AND codigoProvincia = '$codigoProvincia' AND codigoDistrito = '00'
        ''');
    List<UbigeoModel> listDepartamento = response.isNotEmpty
        ? response.map((e) => UbigeoModel.fromJson(e)).toList()
        : [];
    return listDepartamento;
  }

  getAllProvincias(String codigoDepartamento) async {
    final db = await database;
    var response = await db.rawQuery('''
        SELECT * FROM ubigeo WHERE codigoDepartamento = '$codigoDepartamento' 
        AND codigoProvincia != '00' AND codigoDistrito = '00'
        ''');
    List<UbigeoModel> listProvincias = response.isNotEmpty
        ? response.map((e) => UbigeoModel.fromJson(e)).toList()
        : [];
    return listProvincias;
  }

  getDistrito1(String codigoProvincia, String codigoDepartamento,
      String codigoDistrito) async {
    final db = await database;
    var response = await db.rawQuery('''
        SELECT * FROM ubigeo WHERE codigoDepartamento = '$codigoDepartamento' 
        AND codigoProvincia = '$codigoProvincia' AND codigoDistrito = '$codigoDistrito' AND codigoCentroPoblado = '0000'
        ''');
    List<UbigeoModel> listDepartamento = response.isNotEmpty
        ? response.map((e) => UbigeoModel.fromJson(e)).toList()
        : [];
    return listDepartamento;
  }

  getAllDistritos(String codigoProvincia, String codigoDepartamento) async {
    final db = await database;
    var response = await db.rawQuery('''
        SELECT * FROM ubigeo WHERE codigoDepartamento = '$codigoDepartamento' 
        AND codigoProvincia = '$codigoProvincia' AND   codigoDistrito !='00' AND  codigoCentroPoblado = '0000'
        ''');
    List<UbigeoModel> listDepartamento = response.isNotEmpty
        ? response.map((e) => UbigeoModel.fromJson(e)).toList()
        : [];
    return listDepartamento;
  }

  getAllCentrosPoblados(String codigoProvincia, String codigoDepartamento,
      String codigoDistrito) async {
    final db = await database;
    var response = await db.rawQuery('''
        SELECT * FROM ubigeo WHERE codigoDepartamento = '$codigoDepartamento' 
        AND codigoProvincia = '$codigoProvincia' AND codigoDistrito = '$codigoDistrito' AND codigoCentroPoblado != '0000' 
        ''');
        
    List<UbigeoModel> listCentroPoblados = response.isNotEmpty
        ? response.map((e) => UbigeoModel.fromJson(e)).toList()
        : [];
    return listCentroPoblados;
  }

  getCentroPoblado(String codigoProvincia, String codigoDepartamento,
      String codigoDistrito, String codigoCentroPoblado) async {
    final db = await database;
    var response = await db.rawQuery('''
        SELECT * FROM ubigeo WHERE codigoDepartamento = '$codigoDepartamento' 
        AND codigoProvincia = '$codigoProvincia' AND codigoDistrito = '$codigoDistrito' AND codigoCentroPoblado = '$codigoCentroPoblado'
        ''');
    List<UbigeoModel> listCentroPoblados = response.isNotEmpty
        ? response.map((e) => UbigeoModel.fromJson(e)).toList()
        : [];
    return listCentroPoblados;
  }

  getDepartamentos(String codDepartamento) async {
    final db = await database;
    var response = await db.rawQuery('''
        SELECT DISTINCT codigoDepartamento,descripcion FROM departamento WHERE codigoDepartamento = '$codDepartamento'
        ''');
    List<DepartamentoModel> listDepartamento = response.isNotEmpty
        ? response.map((e) => DepartamentoModel.fromMap(e)).toList()
        : [];
    return listDepartamento;
  }

  getProvincia() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
        SELECT * FROM provincia
        ''');
    List<ProvinciaModel> listProvincia = respuesta.isNotEmpty
        ? respuesta.map((e) => ProvinciaModel.fromMap(e)).toList()
        : [];
    return listProvincia;
  }

  getOneProvincia(String codigoProvincia, String codigoDepartamento) async {
    final db = await database;
    var respuesta = await db.rawQuery('''
        SELECT * FROM provincia WHERE codigoProvincia = '$codigoProvincia' AND codigoDepartamento = '$codigoDepartamento'
        ''');
    List<ProvinciaModel> listProvincia = respuesta.isNotEmpty
        ? respuesta.map((e) => ProvinciaModel.fromMap(e)).toList()
        : [];
    return listProvincia;
  }

  getDistritos(String codigoProvincia, String codigoDepartamento,
      String codigoDistrito) async {
    final db = await database;
    var respuesta = await db.rawQuery('''
        SELECT * FROM distrito WHERE codigoProvincia = '$codigoProvincia' AND codigoDepartamento = '$codigoDepartamento' AND codigoDistrito = '$codigoDistrito'
        ''');
    List<DistritoModel> listDistrito = respuesta.isNotEmpty
        ? respuesta.map((e) => DistritoModel.fromMap(e)).toList()
        : [];
    return listDistrito;
  }

  /* */

  /* Parcelassssssss  ªªªª   Coordenadas    */

  insertParcelaCoordenadas(ParcelaCoordenadasModel nuevaParcela) async {
    final db = await database;
    var respuesta = await db.insert("parcelaCoordenadas", nuevaParcela.toMap());
    return respuesta;
  }

  insertParcela(ParcelaModel nuevaParcela) async {
    final db = await database;
    var respuesta = await db.insert("parcelas", nuevaParcela.toMap());
    return respuesta;
  }

  getParcela() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
        SELECT DISTINCT idParcela, descripcion, idSeccion, seccion, area, foto, nombreCompleto ,
          ubigeo, createdAt, updatedAt  FROM parcelas
        ''');
    List<ParcelaModel> listParcela = respuesta.isNotEmpty
        ? respuesta.map((e) => ParcelaModel.fromMap(e)).toList()
        : [];
    return listParcela;
  }

  getParcelaCoordenadas() async {
    final db = await database;
    var respuesta = await db.rawQuery('''
        SELECT * FROM parcelaCoordenadas
        ''');
    List<ParcelaCoordenadasModel> listParceCoorde = respuesta.isNotEmpty
        ? respuesta.map((e) => ParcelaCoordenadasModel.fromMap(e)).toList()
        : [];
    return listParceCoorde;
  }

  getBeneParcelas(String idBeneficiario) async {
    final db = await database;
    var respuesta = await db.rawQuery('''
        SELECT * FROM parcelas WHERE idSeccion = '$idBeneficiario'
        ''');
    List<ParcelaModel> listParceCoorde = respuesta.isNotEmpty
        ? respuesta.map((e) => ParcelaModel.fromMap(e)).toList()
        : [];
    return listParceCoorde;
  }

  deleteAllParcelas() async {
    final db = await database;
    var respuesta = await db.delete("parcelas");
  }

  /* */

}
