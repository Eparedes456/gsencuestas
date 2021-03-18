import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:get/get.dart';

class FichaController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    this.getEncuestados();
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

  TextEditingController get encuestadoSelected => _encuestadoSelected;

  getEncuestados()async{


    var respuesta = await apicConexion.getAllEncuestados();

    if( respuesta != 1 && respuesta !=2 && respuesta != 3 ){

      //print(respuesta);

      respuesta.forEach((item){

        _encuestadosList.add(

          EncuestadoModel(

            idEncuestado        : item['idEncuestado'].toString(),
            documento           : item['documento'],
            nombre              : item['nombre'],
            apellidoPaterno     : item['apellidoPaterno'],
            apellidoMaterno     : item['apellidoMaterno'],
            sexo                : item['sexo'],
            estadoCivil         : item['estadoCivil'],
            direccion           : item['direccion'],
            telefono            : item['telefono'],
            email               : item['email'],
            foto                : item['foto'],
            estado              : item['estado'].toString(),
            tipoPersona         : item['tipoPersona'],
            tipoDocumento       : item['tipoDocumento'],
            representanteLegal  : item['representanteLegal'],
            idUbigeo            : item['idUbigeo'].toString(),
            observacion         : item['observacion'],
            createdAt           : item['createdAt'],
            updatedAt           : item['updatedAt']          

          )

        );


      });




    }else if( respuesta == 1){


      loadMessage('Ocurrio un error en el servidor, comuniquese con el encargado.',false);


    }else if(respuesta == 2){

      loadMessage('Lo sentimos su sesion a expirado, sera redireccionado a la pantalla de inicio de sesion.',false);

    }

    update(['encuestados']);


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




}