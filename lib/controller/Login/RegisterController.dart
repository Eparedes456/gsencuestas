import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:gsencuesta/pages/Login/LoginPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{

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

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();


   

  TextEditingController _nombreController = new TextEditingController();
  TextEditingController _apellidoPaternoController = new TextEditingController();
  TextEditingController _apellidoMaternoController = new TextEditingController();
  TextEditingController _usuarioController = new TextEditingController();
  TextEditingController _contrasenaController = new TextEditingController();
  TextEditingController _dniController = new TextEditingController();
  TextEditingController _correoController = new TextEditingController();

  TextEditingController get nombreController => _nombreController;
  TextEditingController get apellidoPaternoController => _apellidoPaternoController;
  TextEditingController get apellidoMaternoController => _apellidoMaternoController;
  TextEditingController get usuarioController => _usuarioController;
  TextEditingController get contrasenaController => _contrasenaController;
  TextEditingController get dniController => _dniController;
  TextEditingController get correoController => _correoController;

  ApiServices _apiConexion = ApiServices();
 
  String validateEmail(String value){
    if(GetUtils.isEmail(value)){
      return "ingrese un correo eléctronico valido";
    }
  } 

  saveUsuario()async{

    final isvalid = loginFormKey.currentState.validate();
    if(!isvalid){

      return;

    }else{

      print('guardar en la base de datos servidor');
      modal('',true,true);

      var sendData = {

        "apellidoMaterno" : _apellidoMaternoController.text,
        "apellidoPaterno" : _apellidoPaternoController.text,
        "dni"             : _dniController.text,
        "email"          : _correoController.text,
        "institucion"     : {
          "idInstitucion" : 9
        },
        "login"           : _usuarioController.text,
        "nombre"          : _nombreController.text,
        "password"        : _contrasenaController.text,
        "perfil"          : {
          "idPerfil"      : 3
        }

      };

      var resultado = _apiConexion.saveUser(sendData);

      if(resultado != 3){

        modal('',false,true);

        Future.delayed(Duration(seconds: 3),(){

          Get.offAll(LoginPage());
        });

      }else{

        modal('',false,false);

      }


    }

  }

  modal(String mensaje, bool isLoading ,bool isSuccess){
    
    Get.dialog(
      AlertDialog(
        title: Text('notificación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            isLoading? CircularProgressIndicator() : isSuccess ? Icon(Icons.add_circle_outline,color: Colors.green,size: 70,) : Icon(Icons.cancel_outlined,color: Colors.red,size: 70,),
            SizedBox(height: 12,),
            isLoading ? Text('Registrando espere por favor ...') : isSuccess ? Text('Se registro exitosamente') : Text('no se pudo registrar al usaurio')

          ],
        ),
      )
    );

  }




}