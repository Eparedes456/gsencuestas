import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/model/Proyecto/Proyectomodel.dart';
import 'package:gsencuesta/pages/Perfil/ProfilePage.dart';
import 'package:gsencuesta/pages/Proyecto/ProyectoPage.dart';
import 'package:gsencuesta/services/apiServices.dart';



class PrincipalController extends GetxController{

  List<ProyectoModel> _proyectos = [];
  List<ProyectoModel> get  proyectos => _proyectos;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    this.getProyectos();
  }

  ApiServices apiConexion = new ApiServices();

  navigateToProfile(){
    Get.to(ProfilePage());
  }

  navigateToProyecto(){

    

    Get.to(

      ProyectoPage(),
      arguments:  this._proyectos
    
    );

  }

  getProyectos()async{

    var resultado = await apiConexion.getProyectos();

    print(resultado);

    if(resultado != 1 && resultado != 2 && resultado  != 3 ){

      resultado.forEach((item){

        

        _proyectos.add(

          ProyectoModel(

            createdAt           : item["createdAt"],
            updatedAt           : item["updatedAt"],
            idProyecto          : item["idProyecto"],
            nombre              : item["nombre"],
            abreviatura         : item["abreviatura"],
            nombreResponsable   : item["nombre_responsable"], 
            logo                : item["logo"],
            latitud             : item["latitud"],
            longitud            : item["longitud"],
            estado              : item["estado"],    
          )

        );


      });

      print(proyectos.length);

    }else if( resultado == 1){

      print('Error de servidor');

    }else if(resultado == 2){

      print(' eRROR DE TOKEN');

    }else{

      print('Error, no existe la pagina 404');

    }

    update();
    
    //print(modelo);

  }


}