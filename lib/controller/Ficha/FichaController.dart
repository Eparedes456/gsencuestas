import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/pages/Tabs/Tabs.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FichaController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    var listData = Get.arguments;

    idFicha = listData["idFicha"];
    print(idFicha);

  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  





  ApiServices apicConexion = new ApiServices();

  TextEditingController _controllerObservacion = TextEditingController();
  TextEditingController get controllerobservacion => _controllerObservacion;

  String idFicha;

  

  File _imagePath;
  File get imagepath => _imagePath;
  

  

  
  

  pickImage()async{

    final ImagePicker image = ImagePicker();
    PickedFile imageCapturada = await image.getImage(source: ImageSource.camera,imageQuality: 50,maxHeight: 480,maxWidth: 640);
    _imagePath = File(imageCapturada.path);
    print(_imagePath);
    update();  

  }


  messageInfo(String mensaje){

    Get.dialog(
      AlertDialog(

        title: Text('Notificación'),
        content: Text('$mensaje'),

      )

    );

  }

  loadMessage(String message, bool isLoading){

    Get.dialog(

      AlertDialog(

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            isLoading == true ? CircularProgressIndicator() : Container(),

            SizedBox(height: 20,),

            Text(message)

          ],
        ),

      )

    );


  }

  saveFicha()async{
    
    var tipo = "Foto";
    DateTime now = DateTime.now();
    print(now);
    await DBProvider.db.updateFicha( idFicha, _controllerObservacion.text, now.toString());

    await DBProvider.db.insertMultimedia(idFicha, tipo);

    Get.offAll(

      TabsPage()

    );


  }



}