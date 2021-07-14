import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gsencuesta/pages/Login/LoginPage.dart';
import 'package:gsencuesta/pages/Perfil/ProfilePage.dart';
import 'package:gsencuesta/provider/push_notification.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() { 
    super.initState();
    /*final pushProvider = new PushNotificationProvider();
    pushProvider.initNotifications();

    pushProvider.mensajesStream.listen((argumento) { 

      print('argument from main dart : $argumento');

      navigatorKey.currentState.push(
        MaterialPageRoute(builder: (BuildContext context) => ProfilePage())
      );
      
      //Get.to(ProfilePage,arguments: argumento);

    });*/

  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: 'GSEncuesta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        primaryColor: Color.fromRGBO(0, 102, 84, 1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
           
        ) 

      ),
      home: LoginPage()
    );
  }
}


