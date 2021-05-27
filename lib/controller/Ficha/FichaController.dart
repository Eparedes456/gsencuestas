import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Multimedia/MultimediaModel.dart';
import 'package:gsencuesta/model/Tracking/TrackingModal.dart';
import 'package:gsencuesta/pages/Tabs/Tabs.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FichaController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    var listData = Get.arguments;

    idFicha = listData["idFicha"];
    print(idFicha);
    loadData();
    
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
  StreamSubscription<Position> _positionStream;
  
  String _sourceMultimedia = "";
  String get sourceMultimedia => _sourceMultimedia;

  File _imagePath;
  File get imagepath => _imagePath;
  

  loadData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _sourceMultimedia =  await preferences.getString('multimedia');
    update();
  }

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

            _sourceMultimedia == 'C' || _sourceMultimedia == 'T' ? ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Usar camara'),
              onTap: (){
                Get.back();
                pickImage("CAMARA");
              },
            ):Container(),

            _sourceMultimedia == 'G' || _sourceMultimedia == 'T'?  ListTile(
              leading: Icon(Icons.collections),
              title: Text('Abrir galeria'),
              onTap: (){
                Get.back();
                pickImage("GALERIA");
              },
            ) : Container() ,


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

  }
  
  deleteImage(String idMultimedia)async{

    await DBProvider.db.deletemultimedia(idMultimedia);
    _listMultimedia = [];

    _listMultimedia  = await DBProvider.db.getAllMultimediaxFicha(idFicha);
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
    
    
    DateTime now = DateTime.now();
    String formatDate = DateFormat('yyyy-MM-dd').format(now);
    String hourFormat = DateFormat('HH:mm:ss').format(now);

    String formattedDate = formatDate + "T" + hourFormat + ".0Z";

    var hola =  await DBProvider.db.updateFicha( idFicha, _controllerObservacion.text, formattedDate,"F");

    print(hola);
    //_positionStream.cancel();

    Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  //title: Text('Notificación'),
                  content:  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline,color: Colors.green,size: 60,),
                      SizedBox(height: 8,),
                      Text('Los datos se guardaron exitosamente.',textAlign: TextAlign.justify,),
                    ],
                  ),
                ),
                barrierDismissible: false
    );

    Future.delayed(Duration(seconds: 2),(){

      Get.offAll( TabsPage());
                
    });
    
    


  }

  cannotBack(){

    Get.dialog(
      AlertDialog(
        title: Text('Notificación'),
        content: Text('Por favor debe finalizar la encuesta, presione guardar ficha.'),
      )
    );

  }

}