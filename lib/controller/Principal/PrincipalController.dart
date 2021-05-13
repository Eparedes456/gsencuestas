import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:easyping/easyping.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';
import 'package:flutter/material.dart';
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
  List<EncuestadoModel> _encuestadosLista = [];

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hayData = false;
  bool get haydata => _hayData;

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
    this.validarCarga();
  }

  ApiServices apiConexion = new ApiServices();

  navigateToProfile(){
    Get.to(ProfilePage());
  }
  
  validarCarga()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    //var connectionInternet = await DataConnectionChecker().connectionStatus;

    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();
    
    var flag1 = preferences.getString('primeraCarga');

    if(conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

      print('hay conexion a internet');
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

            _isLoading = false;
            _hayData = true;
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

          _isLoading = false;
          _hayData = true;

        }


      }


    }
    
    

    /*if(connectionInternet == DataConnectionStatus.connected ){

     
      
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

    }*/

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

      var listEncuestados = await apiConexion.getAllEncuestado();

      if( listEncuestados != 1 && listEncuestados != 2 && listEncuestados  != 3 ){

        listEncuestados.forEach((element){

          _encuestadosLista.add(
            EncuestadoModel(
              idEncuestado    : element["idEncuestado"].toString(),
              documento       : element["documento"],
              nombre          : element["nombre"],
              apellidoPaterno : element["apellidoPaterno"],
              apellidoMaterno : element["apellidoMaterno"],
              sexo            : element["sexo"],
              estadoCivil     : element["estadoCivil"],
              direccion       : element["direccion"],
              telefono        : element["telefono"],
              email           : element["email"],
              estado          : element["estado"].toString() ,
            )
          );

        });

      }

      for (var e = 0; e < _encuestadosLista.length ; e++) {

        await DBProvider.db.insertEncuestados(_encuestadosLista[e]);
          
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

            List preguOpcion = item["preguntaGrupoOpcion"];

            if(preguOpcion.length > 0){

              int idPreguOpcion =  preguOpcion[0]["idPreguntaGrupoOpcion"];
              var listOpciones =  preguOpcion[0]["grupoOpcion"]["opcion"];

              listOpciones.forEach((item2){

                _opcionesPreguntas.add(

                  OpcionesModel(

                    idOpcion                : item2["idOpcion"],
                    idPreguntaGrupoOpcion   : idPreguOpcion.toString(),
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


            }

            //print(listOpciones);


        });
        
      } 
 
      for (var e = 0; e < _preguntas.length; e++) {

        await DBProvider.db.insertPreguntasxEncuestas(_preguntas[e]);
        
      }

      var lisspreguntas =  await DBProvider.db.getAllPreguntas();
      print(lisspreguntas);

      for (var r = 0; r < _opcionesPreguntas.length; r++) {

        await DBProvider.db.insertOpcionesxPregunta(_opcionesPreguntas[r]);

      }

      var lissopciones =  await DBProvider.db.getAllOpciones();
      print(lissopciones);




 
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

  searchProyecto(String value)async{
    _proyectos = [];

    if(value == "" || value == null ){
      List<ProyectoModel>resultado = await DBProvider.db.searchProyecto(controllerSearch.text);
      if(resultado.length == 0 ){
        print('No se encontro el proyecto');
        
        //update();
      }else{

        _proyectos = resultado;
        _hayData = true;
        update();
      }

    
    }else{
      List<ProyectoModel>resultado = await DBProvider.db.searchProyecto(controllerSearch.text);
        if(resultado.length == 0 ){
          print('No se encontro el proyecto');
          _hayData = false;
          
          _proyectos = [];

          update();
        }else{
          _proyectos = resultado;
          _hayData = true;
          update();
        }
    }
  }
  navigateToProyecto(ProyectoModel proyecto){

    

    Get.to(

      ProyectoPage(),
      arguments:  proyecto  //this._proyectos
    
    );

  }

  exit(){
    Get.dialog(
        AlertDialog(  
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          title: Text('Notificación'),
          content: Text('¿Está seguro de cerrar la aplicación?'),
          actions: [

            Container(
              height: 40,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                color: Color.fromRGBO(0, 102, 84, 1),
                onPressed: ()async{
                  
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
                borderRadius: BorderRadius.circular(10)
              ),
              child: MaterialButton(
                onPressed: (){
                  Get.back();
                },
                child: Text('Continuar',style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1), ),),
              ),
            )

          ],

        )

      );
  }

}
