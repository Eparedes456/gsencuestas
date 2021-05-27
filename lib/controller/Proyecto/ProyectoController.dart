import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';
import 'package:gsencuesta/pages/Encuesta/EncuestaPage.dart';
import 'package:gsencuesta/services/apiServices.dart';

class ProyectoController extends GetxController{

  ApiServices apiConexion = ApiServices();

  List<EncuestaModel> _encuestas = [];
  List<EncuestaModel> get  encuestas => _encuestas;

  bool _isLoadingEncuestas = true;
  bool get isLoading => _isLoadingEncuestas;

  bool _hayEncuestas = false;
  bool get hayEncuestas => _hayEncuestas;

  String _imagen = "";
  String get imagen => _imagen;

  String _nombreProyecto = "";
  String get nombreProyecto => _nombreProyecto;

  String _descripcionProyecto = "";
  String get descripcionProyecto => _descripcionProyecto;

  int id_proyecto;
  int get idProyecto => id_proyecto;

  bool _isLoadingData = false;
  bool get isLoadingData => _isLoadingData;

  //List<ProyectoModel> datos;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    
    ProyectoModel datosProyecto = Get.arguments;

    
    
    this.loadProyecto(datosProyecto);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();



  }


  loadProyecto( ProyectoModel data){

    
   _imagen = data.logo;
    _nombreProyecto = data.nombre;
    _descripcionProyecto = data.nombre;
    id_proyecto = data.idProyecto;
    _isLoadingData = true;
    update();
    loadEncuestas(id_proyecto.toString());
  }

  loadEncuestas(String idProyecto)async{


    //var connectionInternet = await DataConnectionChecker().connectionStatus;
    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

    if( conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

      var resultado = await apiConexion.getEncuestasxProyecto(idProyecto);

      if(resultado != 1 && resultado != 2 && resultado  != 3 ){


        resultado.forEach((item){

          _encuestas.add(

            EncuestaModel(

              createdAt           : item["createdAt"].toString(),
              updatedAt           : item["updatedAt"].toString(),
              idEncuesta          : item["idEncuesta"],
              titulo              : item["titulo"].toString(),
              descripcion         : item["descripcion"].toString(),
              url_guia            : item["url_guia"].toString(), 
              expira              : item["expira"].toString(),
              fechaInicio         : item["fechaInicio"].toString(),
              fechaFin            : item["fechaFin"].toString(),
              logo                : item["logo"].toString(),
              dinamico            : item["dinamico"].toString(),
              esquema             : item["esquema"].toString(),
              estado              : item["estado"].toString(),
              sourceMultimedia    : item["sourceMultimedia"], 
            )

          );


        });

       

        print(_encuestas.length);

        if(_encuestas.length > 0){

          _isLoadingEncuestas = true;
          _hayEncuestas = true;

        }else{
          print('no hay encuestas');
          _isLoadingEncuestas = false;
          _hayEncuestas = false;
        }



      }else if( resultado == 1){

        print('Error de servidor');

      }else if(resultado == 2){

        print(' eRROR DE TOKEN');

      }else{

        print('Error, no existe la pagina 404');

      }



    }else{

    
      _encuestas = await DBProvider.db.consultEncuestaxProyecto(idProyecto);

      print(_encuestas);

      
      print(_encuestas.length);

      if(_encuestas.length > 0){

        _isLoadingEncuestas = false;
        _hayEncuestas = true;

      }else{
        _isLoadingEncuestas = false;
        _hayEncuestas = false;
      }


      
    

    }

    
    update();


  }




  navigateToEncuesta(var encuestaPage){

    print(encuestaPage);

    Get.to(

      EncuestaPage(),
      arguments: [encuestaPage,_nombreProyecto]

    );

  }



}