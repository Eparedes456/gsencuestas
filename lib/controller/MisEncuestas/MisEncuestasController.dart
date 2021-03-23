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

      _listDbEncuesta.forEach((element2) {

        _listMisEncuestas.add(

          MisEncuestasModel(
            
            idFicha         : idFicha,
            idProyecto      : element2.idProyecto.toString(),
            idEncuesta      : element2.idEncuesta.toString(),
            nombreProyecto  : element2.titulo,
            nombreEncuesta  : element2.titulo, 

          )

        );

      });

    });

    

    

    print(listFichasDb);
    print(_listDbEncuesta);   

    _listDbEncuesta.forEach((item){


      
    });


    update();
  }

  updateScreen()async{




  }

}