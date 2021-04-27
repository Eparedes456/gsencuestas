import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Multimedia/MultimediaModel.dart';
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

  List<MultimediaModel> _listMultimedia = [];
  List<MultimediaModel> get listMultimedia => _listMultimedia;
  

  File _imagePath;
  File get imagepath => _imagePath;
  

  showModalImage()async{
    Get.dialog(
      
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        title: Text('Esocge una de las opciones'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Usar camara'),
              onTap: (){
                Get.back();
                pickImage("CAMARA");
              },
            ),
            ListTile(
              leading: Icon(Icons.collections),
              title: Text('Abrir galeria'),
              onTap: (){
                Get.back();
                pickImage("GALERIA");
              },
            ),


          ],
        ),
      )
    );
  }

  


  

  pickImage(String valor)async{

    final ImagePicker image = ImagePicker();
    if(valor == "CAMARA"){
      PickedFile imageCapturada = await image.getImage(source: ImageSource.camera,imageQuality: 50,maxHeight: 500,maxWidth: 500,);

      String photoBase64 = "";
      File image1;

      image1 = File(imageCapturada.path);

      photoBase64 = base64Encode(image1.readAsBytesSync());

      print(photoBase64);

      var resp = await DBProvider.db.insertMultimedia(idFicha, photoBase64);
      _listMultimedia  = await DBProvider.db.getAllMultimediaxFicha(idFicha);

      print(_listMultimedia);
      update();

    }else{

      //maxHeight: 480,maxWidth: 640
      //
      PickedFile imageCapturada = await image.getImage(source: ImageSource.gallery,imageQuality: 50);
      String photoBase64 = "";
      File image1;

      image1 = File(imageCapturada.path);

      photoBase64 = base64Encode(image1.readAsBytesSync());

      print(photoBase64);

      var resp = await DBProvider.db.insertMultimedia(idFicha, photoBase64);
      _listMultimedia  = await DBProvider.db.getAllMultimediaxFicha(idFicha);

      print(_listMultimedia);
      update();

    }

    



    /*final ImagePicker image = ImagePicker();
    PickedFile imageCapturada = await image.getImage(source: ImageSource.camera,imageQuality: 50,maxHeight: 480,maxWidth: 640);
    _imagePath = File(imageCapturada.path);
    print(_imagePath);
    update();  */

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
    
    
    DateTime now = DateTime.now();
    print(now);
    var hola =  await DBProvider.db.updateFicha( idFicha, _controllerObservacion.text, now.toString(),"F");

    print(hola);

    Get.offAll(

      TabsPage()

    );


  }



}