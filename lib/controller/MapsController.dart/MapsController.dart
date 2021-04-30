import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/Tracking/TrackingModal.dart';
import '../../model/Tracking/TrackingModal.dart';


class MapsController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    List<TrackingModel> data = Get.arguments;
    print(data);
    polylinePoints = PolylinePoints();
    onload(data);
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> get controller => _controller;

  CameraPosition _initialCameraPosition;
  CameraPosition get initialCameraPosition => _initialCameraPosition;
  List<LatLng> polylineCoordinate = [];
  Set<Polyline> _polylinesDraw = Set<Polyline>();
  Set<Polyline> get polylines => _polylinesDraw;
  PolylinePoints polylinePoints;

  Set<Marker> _markers = Set<Marker>();
  Set<Marker> get markers => _markers;
  LatLng miubicacion;

  onload(List<TrackingModel> datos)async{

    //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    

    datos.forEach((element){

      polylineCoordinate.add(
        LatLng(double.parse(element.latitud), double.parse(element.longitud))
      );

    });

    miubicacion = LatLng( polylineCoordinate[0].latitude,  polylineCoordinate[0].longitude  );

    _initialCameraPosition = CameraPosition(
      zoom: 15,
      tilt: 0,
      bearing: 0,
      target: miubicacion,
    );

    print(polylineCoordinate);

    

    print(_polylinesDraw.length);

    update();


  }

  setPolyline(){

    _polylinesDraw.add(
      Polyline(
        width: 10,
        polylineId: PolylineId('polyline'),
        color: Colors.green,
        points: polylineCoordinate
      )
    );
    update();

  }

  showMarker(){

    _markers.add(
      Marker(
        markerId: MarkerId('inicio'),
        position: miubicacion,
        icon: BitmapDescriptor.defaultMarker
      )
    );

    update();

  }

}