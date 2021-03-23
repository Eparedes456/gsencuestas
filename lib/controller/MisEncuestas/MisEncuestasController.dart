import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';


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
 


  getAllFichas()async{

    _listFichasDb = await DBProvider.db.getAllFichas();

    _listDbEncuesta = await DBProvider.db.getOneEncuesta( _listFichasDb[0].idEncuesta.toString() );

    print(listFichasDb);
    print(_listDbEncuesta);    

    update();
  }

  updateScreen()async{




  }

}