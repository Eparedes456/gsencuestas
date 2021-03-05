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

            id_encuesta INTEGER PRIMARY KEY AUTOINCREMENT,
            id_proyecto INTEGER,
            titulo TEXT,
            descripcion TEXT,
            url_guia TEXT,
            expira INTEGER,
            fecha_inicio TEXT,
            fecha_fin TEXT,
            logo TEXT,
            dinamico INTEGER,
            estado  INTEGER,
            updated_at TEXT,
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

            id_pregunta INTEGER PRIMARY KEY AUTOINCREMENT,
            id_bloque INTEGER,
            id_encuesta INTEGER,
            enunciado TEXT,
            tipo_pregunta TEXT,
            apariencia TEXT,
            requerido INTEGER,
            requerido_msj TEXT,
            readonly INTEGER,
            defecto TEXT,
            calculation TEXT,
            constraint TEXT,
            constraint_msj TEXT,
            relevant TEXT,
            choice_filter TEXT,
            bind_name TEXT,
            bind_type TEXT,
            bind_field_length INTEGER,
            bind_field_placeholder TEXT,
            orden INTEGER,
            estado INTEGER,
            updated_at TEXT,
            foreign key(id_bloque) references bloque(id_bloque),
            foreign key(id_encuesta) references encuesta(id_encuesta),
            

          )

          '''

        );

        await db.execute(

          '''
        
          CREATE TABLE opcion(

            id_opcion INTEGER PRIMARY KEY,
            id_pregunta INTEGER,
            valor TEXT,
            label TEXT,
            orden INTEGER,
            estado INTEGER,
            updated_at TEXT,
            foreign key(id_pregunta) references encuesta(id_pregunta)

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
            foreign key(id_encuesta) references encuesta(id_encuesta),


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
            foreign key(id_pregunta) references pregunta(id_pregunta),


          )


          '''
          

        );

        

      },
      version: 1

    ); 


  }


  //CREACION DE   LAS CONSULTAS SQL PA


  




}