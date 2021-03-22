import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
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
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  List<String> _ciudades = [

    "Tarapoto",
    "Moyobamba",
    "San Juan",
    "Rioja",
    "Nueva Cajamarca",

  ];

  List<String> get ciudades => _ciudades;
  List<EncuestadoModel> _encuestadosList = [];
  List<EncuestadoModel> get encuestadolist => _encuestadosList;

  ApiServices apicConexion = new ApiServices();

  final _encuestadoSelected = TextEditingController();

  TextEditingController insertEncuestadoController = new TextEditingController();

  File _imagePath;
  File get imagepath => _imagePath;
  

  

  showModalSearch(){

    Get.dialog(

      AlertDialog(

        title: Text(''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: insertEncuestadoController,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 13
                ),
                hintText: 'Ingrese el nombre del encuestado'
              ),
            ),
            SizedBox(height: 12,),

            FlatButton.icon(
              color: Colors.green,
              onPressed: (){

                searchEncuestado();

              }, 
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              label: Text('Buscar',style: TextStyle(color: Colors.white),)
            )


          ],
        ),

      )

    );


  }

  searchEncuestado()async{

    Get.back();

    loadMessage('Cargando', true);

    if(insertEncuestadoController.text == ""){

      print('El campo es requerido para hacer la busqueda');


    }else{

      var response = await apicConexion.findEncuestado(insertEncuestadoController.text);
      print(response);       

      if(response == 2){

        Get.back();

        messageInfo('Error 500, error de servidor comuniquese con el encargado del sistema');

      }


    }


    


  }

  pickImage()async{

    final ImagePicker image = ImagePicker();
    PickedFile imageCapturada = await image.getImage(source: ImageSource.camera);
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

  createFicha(){

      

  }



}