import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Usuarios/UsuariosModel.dart';
import 'package:gsencuesta/pages/Login/LoginPage.dart';
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
  LocationPermission permission;

  TextEditingController get username => _username;
  TextEditingController get password => _password;
  bool _show = true;
  bool get show => _show;
  

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

      permission = await Geolocator.checkPermission();

      if(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          print(permission);
          print(position.latitude);
          print(position.longitude);
          var usuario = preferences.getString('nombreUser');
          var idUsuario = preferences.getString("idUsuario");
          if(usuario == null && idUsuario == null || usuario == "" && idUsuario == ""){

            Get.back();

          }else{

            Get.offAll(TabsPage());

          }
        }else if(permission == LocationPermission.denied){
          Get.back();
          await Geolocator.requestPermission();
          checkInternet();
        }else if(permission == LocationPermission.deniedForever){
          Get.back();
          Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              title: Text('Notificacion'),
              content: SingleChildScrollView(child: Text('Estimado usuario usted denegó el acceso a sus servicios de localización, por favor actívelo en la configuración de aplicaciones y busque la aplicación GSEncuesta, o sólo desinstale la aplicación y vuelva a instalarlo otorgando los permisos de ubicación.')),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: MaterialButton(
                    color: Color.fromRGBO(0, 102, 84, 1),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(FontAwesomeIcons.cogs,color: Colors.white,),
                          Text('Config. Ubicación',style: TextStyle(color: Colors.white),)

                        ],
                      ),
                    ),
                    onPressed: ()async{
                      var response =  await Geolocator.openLocationSettings();
                      Get.back();
                    }
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: MaterialButton(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.cancel,color: Colors.white,),
                          Text('Cerrar',style: TextStyle(color: Colors.white),)

                        ],
                      ),
                    ),
                    onPressed: ()async{
                      Get.back();
                    }
                  ),
                )
              ],
            )
          );
        }
        
      }else if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          print(permission);
          print(position.latitude);
          print(position.longitude);
          var usuario = preferences.getString('nombreUser');
          var idUsuario = preferences.getString("idUsuario");
          if(usuario == null && idUsuario == null || usuario == "" && idUsuario == ""){

            Get.back();

          }else{

            Get.offAll(TabsPage());

          }
        }

    }else{

      Get.back();

      Get.dialog(

        AlertDialog(
          title: Text('Notificación'),
          content: Text('El gps esta desactivado, por favor habilite el gps..'),
          actions: [

            FlatButton.icon(
              color: Color.fromRGBO(0, 102, 84, 1),
              onPressed: (){
                
                Get.back();
                checkInternet();

              },
              icon: Icon(Icons.pin_drop,color: Colors.white,), 
              label: Text('Activar GPS',style: TextStyle(color: Colors.white),)

            )

          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
        ),
        

      );

    }

    update();

  }

  login()async{

    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //var connectionInternet = await DataConnectionChecker().connectionStatus;
    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();
    permission = await Geolocator.requestPermission();
    print(permission);
    if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){

      if( conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile    /*connectionInternet == DataConnectionStatus.connected*/ ){
        loading('Verificando las credenciales',' Cargando');
        print('Estoy conectado a internet, consulto a la api');
        
        loginApi();

      }else{
        loading('Verificando las credenciales',' Cargando');
        List<UsuarioModel> resultado = await  DBProvider.db.getAllUsuarios();
        print(resultado);
        
        if(resultado.length > 0){

          print(' hay resultados');


          print('Hacer el metodo en la base de datos para validar las credenciales');

          loading('Verificando las credenciales',' Cargando');

          List<UsuarioModel> response = await DBProvider.db.consultLogueo(_username.text, '');

          print(response);

          if(response.length > 0){

            var idUsuario     = response[0].idUsuario;
            var nombreUser    = response[0].nombre + ' ' + response[0].apellidoPaterno + ' ' + response[0].apellidoMaterno;
            var usernamex     = response[0].username; 

            _username.clear();
            _password.clear();
            preferences.setString('idUsuario', idUsuario.toString());
            preferences.setString('nombreUser', nombreUser);
            //var idInstitucion = resultado["user"]["idInstitucion"].toString();
            preferences.setString('loginUser', usernamex);
            //preferences.setString('idInstitucion', idInstitucion);
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
    }else if(permission == LocationPermission.denied){
      Get.back();
      Get.dialog(
        AlertDialog(
        title: Text('Notificación'),
        content: Text('Estimado usuario, otorgue acceso a su ubicación.'),
        actions: [
          Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: MaterialButton(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Icon(FontAwesomeIcons.locationArrow,color: Colors.white,),
                        Text('Otorgar permisos',style: TextStyle(color: Colors.white),)

                      ],
                    ),
                  ),
                  onPressed: ()async{
                     permission =  await Geolocator.requestPermission(); //await Geolocator.openLocationSettings();
                     update();
                     Get.back();
                     ubicacionpermiso();
                    /*if(permission == LocationPermission.whileInUse){
                      Get.off(LoginPage());
                    }*/
                    
                    //Get.offAll(LoginPage());
                  }
                ),
              ),
        ],
      )
      );
      
      //await Geolocator.requestPermission();
      

    }else if(permission == LocationPermission.deniedForever){
      Get.back();
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            title: Text('Notificacion'),
            content: SingleChildScrollView(child: Text('Estimado usuario usted denego el acceso a sus servicios de localización, por favor activelo en la configuracion de aplicaciones y busque la aplicación GSEncuesta, o solo desinstale la aplicación y vuelva a instalarlo otorgando los permisos de ubicación')),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: MaterialButton(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Icon(FontAwesomeIcons.cogs,color: Colors.white,),
                        Text('Config. Ubicación',style: TextStyle(color: Colors.white),)

                      ],
                    ),
                  ),
                  onPressed: ()async{
                    
                    bool response =  await Geolocator.openLocationSettings();
                    print(response);
                    if(response == true){
                      Get.back();
                    }
                  }
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: MaterialButton(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Icon(Icons.cancel,color: Colors.white,),
                         Text('Cerrar',style: TextStyle(color: Colors.white),)

                      ],
                    ),
                  ),
                  onPressed: ()async{
                    Get.back();
                  }
                ),
              )
            ],
          )
        );
        
    }

  }

  ubicacionpermiso(){

    if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
      login();
      return 1;
    }else if(permission == LocationPermission.denied){
      login();
      return 2;
    }else if(permission == LocationPermission.deniedForever){
      login();
      return 3;
    }
    update();

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
      Get.back();
      var token         = resultado["token"] ;
      var idUsuario     = resultado["user"]["id"];
      var nombreUser    = resultado["user"]["nombreCompleto"];
      var usernamex     = resultado["user"]["username"]; 
      var idInstitucion = resultado["user"]["idInstitucion"].toString();
      _username.clear();
      _password.clear();
      print(token);
      print(idUsuario);
      print(nombreUser);

      preferences.setString('token', token);
      preferences.setString('idUsuario', idUsuario.toString());
      preferences.setString('nombreUser', nombreUser);
      preferences.setString('loginUser', usernamex);
      preferences.setString('idInstitucion', idInstitucion);
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

  ver(){

    _show = !_show;
    update();

  }


  exit(){
    Get.dialog(
        AlertDialog(  
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          title: Text('Notificación'),
          content: Text('¿Está seguro de cerrar la aplicación?'),
          actions: [

            Container(
              height: 40,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                color: Color.fromRGBO(0, 102, 84, 1),
                onPressed: ()async{
                  
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  

                },
                child: Text('Si'),
              ),
            ),

            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(0, 102, 84, 1),
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              child: MaterialButton(
                onPressed: (){
                  Get.back();
                },
                child: Text('Continuar',style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1), ),),
              ),
            )

          ],

        )

      );
  }






    @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }





}