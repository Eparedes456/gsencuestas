import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/MisEncuestas/MisEncuestasModel.dart';
import 'package:gsencuesta/pages/MisEncuestas/MisEncuestasPage.dart';


class MisEncuestasController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    this.getAllFichas();
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
 


  getAllFichas()async{

    _listFichasDb = await DBProvider.db.getAllFichas();

    _listFichasDb.forEach((element) async {

      String idEncuesta = element.idEncuesta.toString();
      String idFicha = element.idFicha.toString();

      _listDbEncuesta = await DBProvider.db.getOneEncuesta( _listFichasDb[0].idEncuesta.toString() );
      
      var idProyecto = _listDbEncuesta[0].idProyecto;

      var otherData = await DBProvider.db.getOneProyecto(idProyecto);

      var nombreProyecto  = otherData[0].nombre;

      _listDbEncuesta.forEach((element2) {

        _listMisEncuestas.add(

          MisEncuestasModel(
            
            idFicha         : idFicha,
            idProyecto      : element2.idProyecto.toString(),
            idEncuesta      : element2.idEncuesta.toString(),
            nombreProyecto  : nombreProyecto,
            nombreEncuesta  : element2.titulo,
            fechaInicio     : element.fecha_inicio,
            estadoFicha     : element.estado  

          )

        );

      });

    });

    /*print(listFichasDb);
    print(_listDbEncuesta); */  

   //print(_listMisEncuestas);


    update();
  }

  updateScreen(String valor)async{

    _listMisEncuestas = [];

    if( valor == "P" ){

      _listFichasDb = await DBProvider.db.fichasPendientes(valor);

      print(_listFichasDb);

      _listFichasDb.forEach((element) async {

          String idEncuesta = element.idEncuesta.toString();
          String idFicha = element.idFicha.toString();

          _listDbEncuesta = await DBProvider.db.getOneEncuesta( _listFichasDb[0].idEncuesta.toString() );
          
          var idProyecto = _listDbEncuesta[0].idProyecto;

          var otherData = await DBProvider.db.getOneProyecto(idProyecto);

          var nombreProyecto  = otherData[0].nombre;

          _listDbEncuesta.forEach((element2) {

            _listMisEncuestas.add(

              MisEncuestasModel(
                
                idFicha         : idFicha,
                idProyecto      : element2.idProyecto.toString(),
                idEncuesta      : element2.idEncuesta.toString(),
                nombreProyecto  : nombreProyecto,
                nombreEncuesta  : element2.titulo,
                fechaInicio     : element.fecha_inicio,
                estadoFicha     : element.estado  

              )

            );

          });

      });



      update();

    }else if( valor == "F"){

    }else{
      
      getAllFichas();

    }

     



  }

}