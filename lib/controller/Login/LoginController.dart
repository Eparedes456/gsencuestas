import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/pages/Login/RegisterUser.dart';
import 'package:gsencuesta/pages/Principal/Principal.dart';
import 'package:gsencuesta/pages/Tabs/Tabs.dart';
import 'package:gsencuesta/services/apiServices.dart';

class LoginController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
     /*subscription =
        Connectivity().onConnectivityChanged.listen(checkInternet());*/

    this.checkInternet();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  StreamSubscription subscription;
  ApiServices apiConexion = new ApiServices();

  checkInternet()async{

    final result = await Connectivity().checkConnectivity();

    print(result);

    if(result == ConnectivityResult.none){

      showSnackBarInternet(
        'Actualización de conectividad',
        'Estimado usuario, usted no cuenta con servicio de internet',
        Colors.redAccent
      );



    }else if( result == ConnectivityResult.wifi){

      showSnackBarInternet(
        'Actualización de conectividad',
        'Estimado usuario, usted cuenta con servicio de internet',
        Colors.green
      );


    }else{

      showSnackBarInternet(
        'Actualización de conectividad',
        'Estimado usuario, usted cuenta con servicio de internet',
        Colors.green
      );


    }

  }

  showSnackBarInternet(String titulo, String mensaje,Color color)async{

    Get.snackbar(
      titulo, 
      mensaje,
      backgroundColor: color,
      colorText: Colors.white
    );

  }


  navigateToRegisterUser(){

    Get.to(RegisterUser());

  }

  navigateToTabs(){

    Get.to(TabsPage());

  }











    @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }





}