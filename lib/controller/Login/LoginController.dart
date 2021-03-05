import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/pages/Login/RegisterUser.dart';
import 'package:gsencuesta/pages/Principal/Principal.dart';
import 'package:gsencuesta/pages/Tabs/Tabs.dart';

class LoginController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
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