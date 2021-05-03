import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Usuarios/UsuariosModel.dart';
import 'package:gsencuesta/pages/Login/RegisterUser.dart';
import 'dart:io';
import 'dart:async';
import 'package:gsencuesta/pages/Tabs/Tabs.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    
    
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      this.checkInternet();
    });
    
    
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    
  }

  
 
  ApiServices apiConexion = new ApiServices();

  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  TextEditingController get username => _username;
  TextEditingController get password => _password;

  

  loading(String mensaje, String valor){

    Get.dialog(

      AlertDialog(

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            valor == "Error"? Icon(Icons.cancel,color: Colors.red,size: 35,) : valor == "Success"? Icon(Icons.check_circle_outline,color: Colors.green,size: 35,)
            
             :CircularProgressIndicator(),
            SizedBox(height: 12,),
            Padding(
              padding:  EdgeInsets.only(left: 10,right: 10),
              child: Text(mensaje,textAlign: TextAlign.justify,),
            )

          ],
        ),

      )

    );


  }

  checkInternet()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool servicioEnabled;

    servicioEnabled = await Geolocator.isLocationServiceEnabled();

    await loading('Comprobando requisitos de la aplicación',' Cargando');

    if( servicioEnabled == true ){

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);

      var usuario = preferences.getString('nombreUser');
      var idUsuario = preferences.getString("idUsuario");

      if(usuario == null && idUsuario == null || usuario == "" && idUsuario == ""){

        Get.back();

      }else{

        Get.offAll(TabsPage());

      }


      

    }else{

      Get.back();

      Get.dialog(

        AlertDialog(
          title: Text('Notificación'),
          content: Text('El gps esta desactivado, por favor habilite el gps..'),
          actions: [

            FlatButton.icon(

              onPressed: (){
                
                Get.back();
                checkInternet();

              },
              icon: Icon(Icons.pin_drop), 
              label: Text('Activar GPS')

            )

          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
        ),
        

      );

    }

  }

  login()async{

    loading('Verificando las credenciales',' Cargando');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //var connectionInternet = await DataConnectionChecker().connectionStatus;
    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

    //comprint(connectionInternet);
    
    if( conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile    /*connectionInternet == DataConnectionStatus.connected*/ ){

      print('Estoy conectado a internet, consulto a la api');
      
      loginApi();

    }else{

      List<UsuarioModel> resultado = await  DBProvider.db.getAllUsuarios();
      print(resultado);
      
      if(resultado.length > 0){

        print(' hay resultados');


        print('Hacer el metodo en la base de datos para validar las credenciales');

        loading('Verificando las credenciales',' Cargando');

        List<UsuarioModel> response = await DBProvider.db.consultLogueo(_username.text, '');

        print(response);

        if(response.length > 0){

          var idUsuario = response[0].idUsuario;
          var nombreUser = response[0].nombre;
          _username.clear();
          _password.clear();
          preferences.setString('idUsuario', idUsuario.toString());
          preferences.setString('nombreUser', nombreUser);
          Get.offAll(TabsPage());


        }else{

          Get.dialog(
            AlertDialog(
              content: Text('Credenciales erroneas',textAlign: TextAlign.justify,),
            )
          );

        }


      }else{

        print('no hay datos');

        loading('Por favor conéctese a internet , para poder descargar los datos necesarios para el uso de la app.', 'Error');

      }

    }

  }

  loginApi()async{

    
    
      
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var resultado = await apiConexion.ingresar(_username.text, _password.text);

    print(resultado);

    if(resultado["tokenType"] == null ){

      print(resultado["errorMessage"]);
      Get.back();

      Get.dialog(
        AlertDialog(
          content: Text(resultado["errorMessage"],textAlign: TextAlign.justify,),
        )
      );


    }else{

      var token = resultado["token"] ;
      var idUsuario = resultado["user"]["id"];
      var nombreUser = resultado["user"]["nombreCompleto"];
      _username.clear();
      _password.clear();
      print(token);
      print(idUsuario);
      print(nombreUser);

      preferences.setString('token', token);
      preferences.setString('idUsuario', idUsuario.toString());
      preferences.setString('nombreUser', nombreUser);

      Get.to(TabsPage());

    }
    

  }

  showSnackBarInternet(String titulo, String mensaje,Color color)async{

    Get.snackbar(
      titulo, 
      mensaje,
      backgroundColor: color,
      colorText: Colors.white
    );

  }


  navigateToRegisterUser(){

    Get.to(RegisterUser());

  }

  navigateToTabs(){

    Get.to(TabsPage());

  }











    @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }





}