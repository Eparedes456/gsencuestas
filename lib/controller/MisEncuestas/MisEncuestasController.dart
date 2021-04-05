import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
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

  List<EncuestadoModel> _listEncuestado = [];
  List<EncuestadoModel> get listEncuestado => _listEncuestado;
  
  
  bool _haydata = false;
  bool get haydata => _haydata;


  getAllFichas() async{

    _listFichasDb = await DBProvider.db.getAllFichas();

    if(_listFichasDb.length > 0){

      _listFichasDb.forEach((element) async {

        String idEncuesta = element.idEncuesta.toString();
        String idFicha = element.idFicha.toString();
        String idEncuestado = element.idEncuestado.toString();

        _listDbEncuesta = await DBProvider.db.getOneEncuesta( _listFichasDb[0].idEncuesta.toString() );
        //_listEncuestado = await DBProvider.db.getOneEncuestado(idEncuestado);
        
        if(_listDbEncuesta.length > 0 ){

          print('hay datos ');
          var idProyecto = _listDbEncuesta[0].idProyecto;
          var otherData = await DBProvider.db.getOneProyecto(idProyecto);
          var nombreProyecto  = otherData[0].nombre;
          //var nombreEncuestado = _listEncuestado[0].nombre.toString() + _listEncuestado[0].apellidoPaterno.toString();

          print(nombreProyecto);
          _listDbEncuesta.forEach((element2) {

            _listMisEncuestas.add(

              MisEncuestasModel(
                
                idFicha         : idFicha,
                idProyecto      : element2.idProyecto.toString(),
                idEncuesta      : element2.idEncuesta.toString(),
                //nombreEncuestado: nombreEncuestado,
                nombreProyecto  : nombreProyecto,
                nombreEncuesta  : element2.titulo,
                fechaInicio     : element.fecha_inicio,
                estadoFicha     : element.estado  

              )

            );

          });

          print(_listMisEncuestas.length);
          _haydata = true;
          update(['misencuestas']);

        }else{
          _haydata = false;
          update(['misencuestas']);

        }
        
    

      });
      

    }


    
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



      update(['misencuestas']);

    }else if( valor == "F"){

    }else{
      
      getAllFichas();

    }

     



  }

}