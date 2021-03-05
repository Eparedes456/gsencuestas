import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class QuizController extends GetxController{

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


  String _tipo_pregunta = 'Texto';
  String get tipo_pregunta => _tipo_pregunta;




    /* Image pic to camera */

  File _imagePath;
  File get imagepath => _imagePath;

  pickImage()async{

    final ImagePicker image = ImagePicker();
    PickedFile imageCapturada = await image.getImage(source: ImageSource.camera);
    _imagePath = File(imageCapturada.path);
    print(_imagePath);
    update();  

  }


  /* Obtener la ubicación del dispositivo */
  
  String _latitud = "";
  String _longitud = "";

  String get latitud  => _latitud;
  String get longitud => _longitud;

  getCurrentLocation()async{

    bool servicioEnabled;

    servicioEnabled = await Geolocator.isLocationServiceEnabled();
    modalLoading('Obteniendo las coordenas, espere por favor...');

    if(servicioEnabled == true){

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);

      _latitud = position.latitude.toString();
      _longitud = position.longitude.toString();
      
      update();
      Get.back();

    }else{

      print('Activa tu gps');

    }

  }

  modalLoading(String mensaje){
    Get.dialog(

      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

            CircularProgressIndicator(),

            SizedBox(height: 20,),

            Padding(
              padding:  EdgeInsets.only(left: 10,right: 10),
              child: Text(mensaje,textAlign: TextAlign.center,),
            )

          ],
        ),
      ),
      
    );

  }


}