
import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Usuarios/UsuariosModel.dart';
import 'package:gsencuesta/pages/Login/LoginPage.dart';
import 'package:gsencuesta/pages/Perfil/EditProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  loadData()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    //_userName = preferences.getString('nombreUser');
    var nombreUsuario =  preferences.getString('loginUser');
    
    List<UsuarioModel> usuarioData = await DBProvider.db.dataUser(nombreUsuario);
    print(usuarioData);
    var foto = usuarioData[0].foto;
    if(foto == "" || foto == null){
      print('No hay foto');
    }else{
      _photoBase64 = base64Decode(foto);
    }
    

    List<FichasModel> listMisEncuestas = await DBProvider.db.fichasPendientes("F");

    _userName = usuarioData[0].nombre + " " + usuarioData[0].apellidoPaterno + " " + usuarioData[0].apellidoMaterno;
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
    preferences.remove('nombreUser');
    preferences.remove('idUsuario');


    Get.offAll(
      LoginPage()
    );


  }

  



}