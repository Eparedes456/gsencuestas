import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';

class PracticaController extends GetxController{

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  


  GoogleMapController mapController;
  Marker marker;
  Geolocator geolocator;
  Position userLocation;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation,).listen((Position position) async{

      print('latitud : ${position.latitude} // longitud : ${position.longitude}');

      if(marker != null ){
        //mapController.removeMarker(marker);
      }

      /*marker = await mapController?.addMarker(MarkerOptions(
        position: LatLng(position.latitude, position.longitude),
      ));*/

      mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              position.latitude, position.longitude
            ),
            zoom: 20.0,
          ),
        ),
      );


      
    });
    

  }

}

