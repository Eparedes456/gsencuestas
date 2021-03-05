import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';


class TabsController extends GetxController{

  final _selectIndex = 0.obs;
  get selectIndex => this._selectIndex.value;
  set selectIndex(index) => this._selectIndex.value = index;

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





  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}