
import 'dart:typed_data';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Multimedia/MultimediaModel.dart';

class ImagenesController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    
    super.onInit();
    
    var data =  Get.arguments;
    loadImages(data);
  }

  List<MultimediaModel> lisMultimedia =  [];
  bool hayImagenes = false;
  String base64Encode;
  

  loadImages(var data)async{

    lisMultimedia  = await DBProvider.db.getAllMultimediaxFicha(data);
    if(lisMultimedia.length > 0){

      hayImagenes = true;

    }else{

    }

    update();
  }


}