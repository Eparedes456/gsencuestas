
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Usuarios/UsuariosModel.dart';
import 'package:gsencuesta/pages/Login/LoginPage.dart';
import 'package:gsencuesta/pages/Parcela/NewParcelapage.dart';
import 'package:gsencuesta/pages/Parcela/ParcelasPage.dart';
import 'package:gsencuesta/pages/Perfil/EditProfilePage.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../../database/database.dart';

class ProfileController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    var argument = Get.arguments;
    print('Dato recibido $argument');
    
    this.loadData();



  }
  

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  String _userName = "";
  String get userName => _userName;

  String _encuestasFinalizadas = "";
  String get encuestasFinalizadas  => _encuestasFinalizadas;
  Uint8List _photoBase64;
  Uint8List get photoBase64 => _photoBase64;

  String nroDocumento       = "";
  String correoElectronico  = "";
  String fechaAlta          = "";
  String perfil             = "";

 
  loadData()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    _userName = preferences.getString('nombreUser');
    var nombreUsuario =  preferences.getString('loginUser');
    
    List<UsuarioModel> usuarioData = await DBProvider.db.dataUser(nombreUsuario);
    nroDocumento        = usuarioData[0].dni;
    correoElectronico   = usuarioData[0].email;
    fechaAlta           = usuarioData[0].fechaAlta;
    perfil              = usuarioData[0].perfil;  
    print(usuarioData);
    var foto = usuarioData[0].foto;
    if(foto == "" || foto == null){
      print('No hay foto');
    }else{
      _photoBase64 = base64Decode(foto);
    }
    

    List<FichasModel> listMisEncuestas = await DBProvider.db.fichasPendientes("F");

    //_userName = usuarioData[0].nombre + " " + usuarioData[0].apellidoPaterno + " " + usuarioData[0].apellidoMaterno;
    print(listMisEncuestas.length);

    if(listMisEncuestas.length == 0){
      _encuestasFinalizadas = "0";

    }else{
      _encuestasFinalizadas = listMisEncuestas.length.toString();
    }

    
    update();

  }

 

  navigateToEditProfile()async{

    Get.to(

      EditProfilePage()

    );


  }

  logout()async{

    SharedPreferences preferences = await  SharedPreferences.getInstance();

    //preferences.clear();
    List<FichasModel> listPendientes    = await DBProvider.db.fichasPendientes('P');
    List<FichasModel> listFinalizadas   = await DBProvider.db.fichasPendientes('F');

    if(listFinalizadas.length > 0 || listPendientes.length > 0){
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Notificación'),
          content: Text('Se encontró encuestas pendientes de subir servidor, no podrá cerrar sesión si no sincroniza las fichas faltantes.'),
          actions: [
            Container(
              height: 40,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                color: Color.fromRGBO(0, 102, 84, 1),
                onPressed: ()async{
                  Get.back();
                },
                child: Text('Ok'),
              ),
            ),
          ],
        )
      );
    }else{
      await DBProvider.db.deleteParametros();
      preferences.remove('primeraCarga');
      preferences.remove('nombreUser');
      preferences.remove('idUsuario');


      Get.offAll(
        LoginPage()
      );

    }

    /*preferences.remove('primeraCarga');
    preferences.remove('nombreUser');
    preferences.remove('idUsuario');


    Get.offAll(
      LoginPage()
    );*/


  }

  navigateToParcela()async{
    Get.to(
      ParcelaPage()
    );
  }



}