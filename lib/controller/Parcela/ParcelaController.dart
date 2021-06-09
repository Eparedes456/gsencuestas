import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class ParcelaController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    

    polylinePoints = PolylinePoints();
    this.onload();
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
  Position position;
  var i;
 onload()async{

  position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  miubicacion = LatLng(position.latitude, position.longitude); 
  _initialCameraPosition = CameraPosition(
      zoom: 17,
      tilt: 0,
      bearing: 0,
      target: miubicacion,
  );
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

  addMarker()async{
    i = 1;
    print("añadiento nuevo punto");
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    _markers.add(
      Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'Punto'
        ),
        icon: BitmapDescriptor.defaultMarker
      )
    ); 
    i = i+1;
    print(_markers.length);

    polylineCoordinate.add(
      LatLng(position.latitude, position.longitude)
    );
    print(polylineCoordinate);
    setPolyline();
    update();

  }
}