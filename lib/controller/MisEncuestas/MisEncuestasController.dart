import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/MisEncuestas/MisEncuestasModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/pages/MisEncuestas/DetailMiEncuestaPage.dart';
import 'package:gsencuesta/pages/MisEncuestas/MisEncuestasPage.dart';


class MisEncuestasController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    this.getAllFichas();
    super.onInit();
    
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  List<FichasModel> _listFichasDb = [];
  List<FichasModel> get listFichasDb => _listFichasDb;

  List<EncuestaModel> _listDbEncuesta =[];

  List<MisEncuestasModel> _listMisEncuestas =[];
  List<MisEncuestasModel> get listMisEncuestas => _listMisEncuestas;

  List<EncuestadoModel> _listEncuestado = [];
  List<EncuestadoModel> get listEncuestado => _listEncuestado;

  List<PreguntaModel> _listPreguntas = [];
  List<PreguntaModel> get listPreguntas =>  _listPreguntas;
  

  String _nroTotalPreguntas = "";
  String get nroTotalPreguntas => _nroTotalPreguntas;
  
  bool _haydata = false;
  bool get haydata => _haydata;

  bool _isLoading = true;
  bool get isLoading => _isLoading;


  getAllFichas() async{

    _listFichasDb = await DBProvider.db.getAllFichas();

    if(_listFichasDb.length > 0){  

      for( var element in _listFichasDb ){

        String idEncuesta = element.idEncuesta.toString();
        String idFicha = element.idFicha.toString();
        String idEncuestado = element.idEncuestado.toString();
        _listDbEncuesta = await DBProvider.db.getOneEncuesta(idEncuesta);
        _listEncuestado = await DBProvider.db.getOneEncuestado(idEncuestado);
        _listPreguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
        _nroTotalPreguntas = _listPreguntas.length.toString();

        if(_listDbEncuesta.length > 0 ){

          print('hay datos ');
          var idProyecto = _listDbEncuesta[0].idProyecto;
          var otherData = await DBProvider.db.getOneProyecto(idProyecto);
          var nombreProyecto  = otherData[0].nombre;
          var nombreEncuestado = _listEncuestado[0].nombre.toString() + " " + _listEncuestado[0].apellidoPaterno.toString();
          print(nombreProyecto);

          for( var element2 in _listDbEncuesta){

            _listMisEncuestas.add(

              MisEncuestasModel(
                
                idFicha         : idFicha,
                idProyecto      : element2.idProyecto.toString(),
                idEncuesta      : element2.idEncuesta.toString(),
                nombreEncuestado: nombreEncuestado,
                nombreProyecto  : nombreProyecto,
                nombreEncuesta  : element2.titulo,
                fechaInicio     : element.fecha_inicio,
                estadoFicha     : element.estado  

              )

            );

          }

        }

      }

      if(_listMisEncuestas.length > 0){

        _haydata = true;
        _isLoading = false;
        update();

      }
    }else{

      _haydata = false;
      _isLoading = false;
      update();

    }


    
  }

  updateScreen(String valor)async{

    _listMisEncuestas = [];
    _listFichasDb = [];
    _listEncuestado = [];
    _listPreguntas = [];

    if( valor == "P" || valor == "F" || valor == "S" ){

      _listFichasDb = await DBProvider.db.fichasPendientes(valor);

      //print(_listFichasDb);

      if(_listFichasDb.length > 0){

        for( var element in _listFichasDb){

          String idEncuesta = element.idEncuesta.toString();
          String idFicha = element.idFicha.toString();
          String idEncuestado = element.idEncuestado.toString();

          _listEncuestado = await DBProvider.db.getOneEncuestado(idEncuestado);
          _listDbEncuesta = await DBProvider.db.getOneEncuesta( idEncuesta );
          _listPreguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
          _nroTotalPreguntas = _listPreguntas.length.toString();
          var nombreEncuestado = _listEncuestado[0].nombre.toString() + " " + _listEncuestado[0].apellidoPaterno.toString();

          for(var element2 in _listDbEncuesta){

            var idProyecto = element2.idProyecto;
            var otherData = await DBProvider.db.getOneProyecto(idProyecto);
            var nombreProyecto  = otherData[0].nombre;

            _listMisEncuestas.add(

              MisEncuestasModel(
                
                idFicha         : idFicha,
                idProyecto      : element2.idProyecto.toString(),
                idEncuesta      : element2.idEncuesta.toString(),
                nombreEncuestado: nombreEncuestado,
                nombreProyecto  : nombreProyecto,
                nombreEncuesta  : element2.titulo,
                fechaInicio     : element.fecha_inicio,
                estadoFicha     : element.estado  

              )

            );

          }

        }


        if(_listMisEncuestas.length > 0){

          _haydata = true;
          _isLoading = false;
          update();

        }

      }else{

        _haydata = false;
        _isLoading = false;
        update();

      }
    }else{
      
      await getAllFichas();

    }

  }


  navigateToDetail(String idFicha)async{

    final result = await Get.to(

      DetailMiEncuestaPage(),
      arguments: [idFicha,_nroTotalPreguntas]

    );

    if(result == "SI" ){

      _listFichasDb   = [];
      _listDbEncuesta = [];
      _listDbEncuesta = [];

      await getAllFichas();
      
      print("Se elimino yt se volvio a recargar la pagina");

    }

  }

}