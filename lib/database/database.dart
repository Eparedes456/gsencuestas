import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';
import 'package:gsencuesta/model/Usuarios/UsuariosModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBProvider{


  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {

    if(_database != null)

    return _database;

    _database = await initDB();
    return _database;

  }

  //creamos la base de datos y las tablas correspondiente a la base de datos de  Encuestas

  initDB() async{

    return await openDatabase(

      join(await getDatabasesPath(),'gsencuesta.db'),
      onCreate: (db,version)async{
        
        await db.execute(
          '''
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
            estado  TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
        
        
          '''
        );

        await db.execute(
          '''
          
          CREATE TABLE bloque(

            id_bloque INTEGER PRIMARY KEY AUTOINCREMENT,
            id_encuesta INTEGER,
            nombre TEXT,
            icono TEXT,
            estado INTEGER,
            updated_at TEXT,
            foreign key(id_encuesta) references encuesta(id_encuesta) 

          )
          
          '''
          
        );

        await db.execute(

          '''
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
            updated_at TEXT
            
            

          )

          '''

        );

        await db.execute(

          '''
        
          CREATE TABLE opcion(

            id_opcion INTEGER PRIMARY KEY,
            idPreguntaGrupoOpcion TEXT,
            idPregunta INTEGER,
            valor TEXT,
            label TEXT,
            orden INTEGER,
            estado TEXT,
            createdAt TEXT,
            updated_at TEXT
            

          )'''

        );


        await db.execute(

          '''

          CREATE TABLE ficha(

            id_ficha INTEGER PRIMARY KEY AUTOINCREMENT,
            id_encuesta INTEGER,
            id_usuario  INTEGER,
            id_encuestado INTEGER,
            latiutd TEXT,
            longitud TEXT,
            fecha_inicio TEXT,
            fecha_fin TEXT,
            observacion TEXT,
            estado INTEGER,
            updated_at TEXT,
            foreign key(id_encuesta) references encuesta(id_encuesta)


          )

          '''

        );

        await db.execute(

          '''
          CREATE TABLE respuesta(

            id_respuesta INTEGER PRIMARY KEY AUTOINCREMENT,
            id_pregunta INTEGER,
            id_ficha INTEGER,
            valor TEXT,
            estado INTEGER,
            updated_at TEXT,
            foreign key(id_pregunta) references pregunta(id_pregunta)


          )


          '''
          

        );

        await db.execute(
          '''
          CREATE TABLE usuario(

            idUsuario INTEGER PRIMARY KEY,
            nombre TEXT,
            apellidoPaterno TEXT,
            apellidoMaterno TEXT,
            dni TEXT,
            email TEXT,
            username TEXT,
            password TEXT,
            estado TEXT,
            createdAt TEXT
           

          )

          '''
        );

        await db.execute(
          '''
          CREATE TABLE proyecto(
            idProyecto INTEGER PRIMARY KEY,
            nombre TEXT,
            abreviatura TEXT,
            nombreResponsable TEXT,
            logo TEXT,
            latitud TEXT,
            longitud TEXT,
            estado TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )

          '''
        );

        

      },
      version: 4

    ); 


  }


  //CREACION DE   LAS CONSULTAS SQL LOCAL

  /*Consulta traer todos los usuarios */
  getAllUsuarios()async{

    final db = await database;
    var respuesta = await db.query("usuario");

    List<UsuarioModel> listUser = respuesta.isNotEmpty ? 
      respuesta.map((e) => UsuarioModel.fromMap(e)).toList() :[];

    return listUser;
    

  }

  /*Consulta insertar todos los usuarios */

  insertUsuarios(UsuarioModel nuevoUsuario)async{

    final db  = await database;
    var respuesta = await db.insert("usuario", nuevoUsuario.toMap());
    return respuesta;

  }

  

  /* Consulta de eliminar a todos los usuarios TRUNCATE TABLE usuario */

  deleteAllUsuario()async{

    final db = await database;
    var respuesta = await db.delete("usuario");

  }

  /* Consulta de login  */
  consultLogueo(String username, String pass)async{

    final db = await database;

    var respuesta = await db.rawQuery(
      '''
      SELECT * FROM usuario WHERE username = '$username'
      '''
    );

    //print(respuesta);

    List<UsuarioModel> listUser = respuesta.isNotEmpty ? 
      respuesta.map((e) => UsuarioModel.fromMap(e)).toList() :[];

    return listUser;

  }

  
  /*Consulta de insertar los proyectos */
  
  insertProyectos(ProyectoModel nuevoProyecto)async{

    final db  = await database;

    

      var respuesta = await db.insert("proyecto", nuevoProyecto.toMap());
      return respuesta;
    

    

  }

  /* Consultar todos los proyectos  */

  getAllProyectos()async{

    final db = await database;
    var respuesta = await db.query("proyecto");

    List<ProyectoModel> listProyectos = respuesta.isNotEmpty ? 
      respuesta.map((e) => ProyectoModel.fromMap(e)).toList() :[];

    return listProyectos;
    

  }

  /*Consulta de insertar las encuestas por proyecto */
  
  insertEncuestasxProyecto(EncuestaModel nuevoEncuesta)async{

    final db  = await database;

    

      var respuesta = await db.insert("encuesta", nuevoEncuesta.toMap());
      return respuesta;
    

    

  }

  /* Traer todas las encuestas  */

  getAllEncuestas() async{

    final db = await database;
    var respuesta = await db.query("encuesta");

    List<EncuestaModel> listEncuesta = respuesta.isNotEmpty ? 
      respuesta.map((e) => EncuestaModel.fromMap(e)).toList() :[];

    return listEncuesta;
  }


  /* Consulta de traer encuestas relacionados a un proyecto en especifico*/
  consultEncuestaxProyecto(String idProyecto)async{

    final db = await database;

    var respuesta = await db.rawQuery(
      '''
      SELECT * FROM encuesta WHERE idProyecto = '$idProyecto'
      '''
    );

    List<EncuestaModel> listEncuesta = respuesta.isNotEmpty ? 
      respuesta.map((e) => EncuestaModel.fromMap(e)).toList() :[];

    return listEncuesta;

  }

  /* CONSULTA DE INSERCIÓN DE LA TABLA PREGUNTAS */

  /*Consulta de insertar las encuestas por proyecto */
  
  insertPreguntasxEncuestas(PreguntaModel nuevaPregunta)async{

    final db  = await database;
    var respuesta = await db.insert("pregunta", nuevaPregunta.toMap());
    return respuesta;

  }

  /* Traer todas las preguntas  */

  getAllPreguntas() async{

    final db = await database;
    var respuesta = await db.query("pregunta");

    List<PreguntaModel> listPregunta = respuesta.isNotEmpty ? 
      respuesta.map((e) => PreguntaModel.fromMap(e)).toList() :[];

    return listPregunta;
  }

  /* Consulta de traer encuestas relacionados a un proyecto en especifico*/
  consultPreguntaxEncuesta(String idEncuesta)async{

    final db = await database;

    var respuesta = await db.rawQuery(
      '''
      SELECT * FROM pregunta WHERE idEncuesta = '$idEncuesta'
      '''
    );

    List<PreguntaModel> listPreguntas = respuesta.isNotEmpty ? 
      respuesta.map((e) => PreguntaModel.fromMap(e)).toList() :[];

    return listPreguntas;

  }

  /*Consulta de insertar las opciones por pregunta */
  
  insertOpcionesxPregunta(OpcionesModel nuevaOpcion)async{

    final db  = await database;
    var respuesta = await db.insert("opcion", nuevaOpcion.toMap());
    return respuesta;

  }

  /* Traer todas las opciones  */

  getAllOpciones() async{

    final db = await database;
    var respuesta = await db.query("opcion");

    List<OpcionesModel> listOpciones = respuesta.isNotEmpty ? 
      respuesta.map((e) => OpcionesModel.fromMap(e)).toList() :[];

    return listOpciones;
  }




}