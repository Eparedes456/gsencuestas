import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';
import 'package:gsencuesta/pages/Encuesta/EncuestaPage.dart';
import 'package:gsencuesta/services/apiServices.dart';

class ProyectoController extends GetxController{

  ApiServices apiConexion = ApiServices();

  List<EncuestaModel> _encuestas = [];
  List<EncuestaModel> get  encuestas => _encuestas;

  bool _isLoadingEncuestas = false;
  bool get isLoading => _isLoadingEncuestas;

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
    
    List datos = Get.arguments;

    
    
    this.loadProyecto(datos);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();



  }


  loadProyecto( proyecto){

    
    _imagen = proyecto[0].logo;
    _nombreProyecto = proyecto[0].nombre;
    _descripcionProyecto = proyecto[0].nombre;
    id_proyecto = proyecto[0].idProyecto;
    _isLoadingData = true;
    update();
    loadEncuestas(id_proyecto.toString());
  }

  loadEncuestas(String idProyecto)async{


    var resultado = await apiConexion.getEncuestasxProyecto(idProyecto);

    if(resultado != 1 && resultado != 2 && resultado  != 3 ){

      resultado.forEach((item){

        

        _encuestas.add(

          EncuestaModel(

            createdAt           : item["createdAt"],
            updatedAt           : item["updatedAt"],
            idEncuesta          : item["idEncuesta"],
            titulo              : item["titulo"],
            descripcion         : item["descripcion"],
            url_guia            : item["url_guia"], 
            expira              : item["expira"],
            fechaInicio         : item["fechaInicio"],
            fechaFin            : item["fechaFin"],
            logo                : item["logo"],
            dinamico            : item["dinamico"] ,
            esquema             : item["esquema"] ,
            estado              : item["estado"],    
          )

        );


      });

      print(_encuestas.length);

      if(_encuestas.length > 0){

        _isLoadingEncuestas = true;

      }



    }else if( resultado == 1){

      print('Error de servidor');

    }else if(resultado == 2){

      print(' eRROR DE TOKEN');

    }else{

      print('Error, no existe la pagina 404');

    }
    update();


  }




  navigateToEncuesta(var encuestaPage){

    print(encuestaPage);

    Get.to(

      EncuestaPage(),
      arguments: encuestaPage

    );

  }



}