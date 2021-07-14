

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:io';

/*class PushNotificationProvider{

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajeStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajesStream => _mensajeStreamController.stream;

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work
  }


  initNotifications()async{

    await _firebaseMessaging.requestNotificationPermissions();
    final tokenFirebase = await _firebaseMessaging.getToken(); 
    print("======= Firebase Token ========");
    print(tokenFirebase);

    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage:  Platform.isIOS? null : PushNotificationProvider.onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume
    );


  }


  Future<dynamic> onMessage( Map<String,dynamic> message){

    print("======== onMessage ======");

    print('message $message');
    String argumento = 'no-data';

    if(Platform.isAndroid){

       argumento = message['data']['uid']  ?? 'no-data';

    }else{

      argumento = message['uid'] ?? 'no-data';

    }

    
    _mensajeStreamController.sink.add(argumento);

  }

  Future<dynamic> onLaunch( Map<String,dynamic> message){

    print("======== onLaunch ======");

    print('message $message');

    String argumento = 'no-data';

    if(Platform.isAndroid){

       argumento = message['data']['uid']  ?? 'no-data';

    }else{

      argumento = message['uid'] ?? 'no-data';

    }
    _mensajeStreamController.sink.add(argumento);

  }

  Future<dynamic> onResume( Map<String,dynamic> message){

    print("======== onLaunch ======");

    print('message $message');

    String argumento = 'no-data';
    
    if(Platform.isAndroid){

       argumento = message['data']['uid']  ?? 'no-data';

    }else{

      argumento = message['uid'] ?? 'no-data';

    }

    _mensajeStreamController.sink.add(argumento);

  }

  dispose(){

    _mensajeStreamController?.close();

  }



}*/