import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';

import 'package:gsencuesta/model/Usuarios/UsuariosModel.dart';
import 'package:gsencuesta/pages/Perfil/ProfilePage.dart';
import 'package:gsencuesta/pages/Proyecto/ProyectoPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';



class PrincipalController extends GetxController{

  List<ProyectoModel> _proyectos = [];
  List<ProyectoModel> get  proyectos => _proyectos;

  /* Modelo de lista de usuarios de usuarios */

  List<UsuarioModel> _usuarios = [];
  List<EncuestaModel> _encuestas = [];
  List<PreguntaModel> _preguntas = [];
  List<OpcionesModel> _opcionesPreguntas = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
    this.validarCarga();
  }

  ApiServices apiConexion = new ApiServices();

  navigateToProfile(){
    Get.to(ProfilePage());
  }
  
  validarCarga()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var connectionInternet = await DataConnectionChecker().connectionStatus;
    var flag1 = preferences.getString('primeraCarga');

    if(connectionInternet == DataConnectionStatus.connected ){

      print('verifico en la tabla parametros para actualziar o no hacer nada');
      
      if(flag1 == null){

        insertUserDb();

      }else{

        var listProyecto = await apiConexion.getProyectos();

        if(listProyecto != 1 && listProyecto != 2 && listProyecto  != 3 ){

          listProyecto.forEach((item){

            _proyectos.add(

              ProyectoModel(
                idProyecto: item["idProyecto"],
                nombre: item["nombre"],
                abreviatura: item["abreviatura"],
                nombreResponsable: item["nombre_responsable"],
                logo: item["logo"],
                latitud: item["latitud"],
                longitud: item["longitud"],
                estado: item["estado"].toString(),
                createdAt: item["createdAt"],
                updatedAt: item["updatedAt"]

              )

            );
          });

          print(_proyectos.length);
          
          if(_proyectos.length > 0 ){

            _isLoading = true;
          }

          

        }else if( listProyecto == 1){

          print('Error de servidor');

        }else if(listProyecto == 2){

          print(' eRROR DE TOKEN');

        }else{

          print('Error, no existe la pagina 404');

        }




      }

    }else{

      

      if(flag1 != null){

        print('Consulto mi base de datos local');

        _proyectos = await DBProvider.db.getAllProyectos();

        print(_proyectos);


        if(_proyectos.length > 0 ){

          _isLoading = true;

        }


      }

    }

    update();

  }

  insertUserDb()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var flag = preferences.getString('primeraCarga');

    if(flag == "Si"){

      print("Consulto a la base de datos a la tabla proyecto");


    }else{

      await DBProvider.db.deleteAllUsuario();
      var listUserApi = await apiConexion.getAllUsers();

      listUserApi.forEach((item){

        _usuarios.add(

          UsuarioModel(

            
            idUsuario       : item["idUsuario"],
            nombre          : item["nombre"],
            apellidoPaterno : item["apellidoPaterno"],
            apellidoMaterno : item["apellidoMaterno"],
            dni             : item["dni"],
            email           : item["email"],
            username        : item["login"],
            password        : item["password"],
            estado          : item["estado"].toString(),
            createdAt       : item["createdAt"],
          )

        );
      });

      print(_usuarios);

      for (var i = 0; i < _usuarios.length ; i++) {

        await DBProvider.db.insertUsuarios(_usuarios[i]);  
      }

      var listProyecto = await apiConexion.getProyectos();

      if(listProyecto != 1 && listProyecto != 2 && listProyecto  != 3 ){

      listProyecto.forEach((item){

        _proyectos.add(

          ProyectoModel(
            idProyecto: item["idProyecto"],
            nombre: item["nombre"],
            abreviatura: item["abreviatura"],
            nombreResponsable: item["nombre_responsable"],
            logo: item["logo"],
            latitud: item["latitud"],
            longitud: item["longitud"],
            estado: item["estado"].toString(),
            createdAt: item["createdAt"],
            updatedAt: item["updatedAt"]

          )

        );
      });

      print(_proyectos.length);

      
      for (var x = 0; x < _proyectos.length ; x++) {

       await DBProvider.db.insertProyectos(_proyectos[x]);

      }

      var lissproyecto =  await DBProvider.db.getAllProyectos();

      //print(lissproyecto);

      for (var j = 0; j < _proyectos.length; j++) {

        var listEncuestaApi = await apiConexion.getEncuestasxProyecto(_proyectos[j].idProyecto.toString());
        var idProyecto = _proyectos[j].idProyecto.toString();
        listEncuestaApi.forEach((item){

          _encuestas.add(

            EncuestaModel(

              idEncuesta    : item["idEncuesta"],
              idProyecto    : idProyecto.toString(),
              titulo        : item["titulo"],
              descripcion   : item["descripcion"],
              url_guia      : item["url_guia"],
              expira        : item["expira"].toString(),
              fechaInicio   : item["fechaInicio"],
              fechaFin      : item["fechaFin"],
              logo          : item["logo"],
              dinamico      : item["dinamico"].toString(),
              esquema       : item["esquema"],
              estado        : item["estado"].toString(),
              createdAt     : item["createdAt"],
              updatedAt     : item["updatedAt"]


            )

          );

        });

        
      }

      for (var m = 0; m < _encuestas.length ; m++) {

       await DBProvider.db.insertEncuestasxProyecto(_encuestas[m]);

      }

    
      var lissencuesta =  await DBProvider.db.getAllEncuestas();

      List listPreguntas = [];

      for (var n = 0; n < _encuestas.length; n++) {

        var idEncuesta = _encuestas[n].idEncuesta.toString();
        var listPreguntasxEncuesta = await apiConexion.getPreguntasxEncuesta(idEncuesta);
        listPreguntas = listPreguntasxEncuesta["pregunta"];

        listPreguntas.forEach((item)async{
            int idPregunta = item["idPregunta"];
            _preguntas.add(

              PreguntaModel(

                id_pregunta       : item["idPregunta"],
                id_bloque         : item["id_bloque"],
                idEncuesta       :  int.parse(idEncuesta),
                enunciado         : item["enunciado"],
                tipo_pregunta     : item["tipo_pregunta"],
                apariencia        : item["apariencia"],
                requerido         : item["requerido"].toString(),
                requerido_msj     : item["requerido_msj"],
                readonly          : item["readonly"].toString(),
                defecto           : item["defecto"],
                calculation       : item["calculation"],
                restriccion       : item["restriccion"].toString(),
                restriccion_msj   : item["restriccion_msj"],
                relevant          : item["relevant"],
                choice_filter     : item["choice_filter"], 
                bind_name         : item["bind_name"],
                bind_type         : item["bind_type"],
                bind_field_length : item["bind_field_length"],
                bind_field_placeholder  : item["bind_field_placeholder"],
                orden             : item["orden"],
                estado            : item["estado"].toString(),
                updated_at        : item["updatedAt"],
                created_at        : item["createdAt"]
              ),

            );

            var preguOpcion = item["preguntaGrupoOpcion"];
            int idPreguOpcion =  preguOpcion[0]["idPreguntaGrupoOpcion"];
            var listOpciones =  preguOpcion[0]["grupoOpcion"]["opcion"];

            print(listOpciones);

            listOpciones.forEach((item2){

              _opcionesPreguntas.add(

                OpcionesModel(

                  id_opcion               : item2["idOpcion"],
                  idPreguntaGrupoOpcion   : idPreguOpcion,
                  idPregunta              : idPregunta,
                  valor                   : item2["valor"],
                  label                   : item2["label"], 
                  orden                   : item2["orden"],
                  estado                  : item2["estado"].toString(),
                  createdAt               : item2["createdAt"],
                  updated_at              : item2["updatedAt"], 
                )

              );

            });

        });
        
      } 
 
      for (var e = 0; e < _preguntas.length; e++) {

        await DBProvider.db.insertPreguntasxEncuestas(_preguntas[e]);
        
      }

      var lisspreguntas =  await DBProvider.db.getAllPreguntas();
      print(lisspreguntas);

      /*for (var r = 0; r < _opcionesPreguntas.length; r++) {

        await DBProvider.db.insertOpcionesxPregunta(_opcionesPreguntas[r]);

      }*/

      var lissopciones =  await DBProvider.db.getAllOpciones();
      print(lissopciones);



      //for (var j = 0; j < _proyectos.length ; j++) {

        

        /*for (var k = 0; k < _encuestas.length; k++) {

          //await DBProvider.db.insertEncuestasxProyecto(_encuestas[k]);
        
        }*/

        


      //}

 
      if(_proyectos.length > 0 ){

        _isLoading = true;

      }

    }else if( listProyecto == 1){

      print('Error de servidor');

    }else if(listProyecto == 2){

      print(' eRROR DE TOKEN');

    }else{

      print('Error, no existe la pagina 404');

    }

  
      List<UsuarioModel> listUserDbLocal = await  DBProvider.db.getAllUsuarios();
      List<ProyectoModel> listProyectoDbLocal = await DBProvider.db.getAllProyectos();
      var insertDataLocal = "Si";
      preferences.setString('primeraCarga', insertDataLocal);

      //print(listUserDbLocal);
      //print(listProyectoDbLocal);
      update();

    }
  }

  navigateToProyecto(ProyectoModel proyecto){

    

    Get.to(

      ProyectoPage(),
      arguments:  proyecto  //this._proyectos
    
    );

  }



}