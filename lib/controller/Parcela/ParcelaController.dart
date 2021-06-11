import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;

import 'package:gsencuesta/services/apiServices.dart';



class ParcelaController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    
    polylinePoints = PolylinePoints();
    var listData = Get.arguments;
    
    idSeccion = listData["idEncuestado"];
    ubigeo    = listData["ubigeo"];
    print(idSeccion);
    print(ubigeo);
    this.onload();
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  String idSeccion;
  String ubigeo = "";
  Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> get controller => _controller;

  CameraPosition _initialCameraPosition;
  CameraPosition get initialCameraPosition => _initialCameraPosition;
  List<LatLng> polylineCoordinate = [];
  Set<Polyline> _polylinesDraw = Set<Polyline>();
  Set<Polyline> get polylines => _polylinesDraw;
  PolylinePoints polylinePoints;

  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polygon> get polygons => _polygons;

  Set<Marker> _markers = Set<Marker>();
  Set<Marker> get markers => _markers;
  LatLng miubicacion;
  Position position;
  var i;
  int _polygonCounterId = 1;
  String areacalculada = "";
  List listCodDep = [];
  List listcodProvincia = [];
  List liscodDistrito = [];

  ApiServices apiConexion = ApiServices();

 onload()async{

  position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  miubicacion = LatLng(position.latitude, position.longitude); 
  _initialCameraPosition = CameraPosition(
      zoom: 17,
      tilt: 0,
      bearing: 0,
      target: miubicacion,
  );

  _markers.add(
      Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(-6.021184, -76.987839),
        infoWindow: InfoWindow(
          title: 'Punto 1',
          snippet: 'Latitud: ${position.latitude} , Longitud: ${position.longitude}'
        ),
        icon: BitmapDescriptor.defaultMarker
      )
  );

  _markers.add(
      Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(-6.021776, -76.988057),
        infoWindow: InfoWindow(
          title: 'Punto 2',
          snippet: 'Latitud: ${position.latitude} , Longitud: ${position.longitude}'
        ),
        icon: BitmapDescriptor.defaultMarker
      )
  );

  _markers.add(
      Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(-6.021824, -76.987517),
        infoWindow: InfoWindow(
          title: 'Punto 3',
          snippet: 'Latitud: ${position.latitude} , Longitud: ${position.longitude}'
        ),
        icon: BitmapDescriptor.defaultMarker
      )
  );

  _markers.add(
      Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(-6.021184, -76.987839),
        infoWindow: InfoWindow(
          title: 'Punto 4',
          snippet: 'Latitud: ${position.latitude} , Longitud: ${position.longitude}'
        ),
        icon: BitmapDescriptor.defaultMarker
      )
  );
  polylineCoordinate.add(
      LatLng(-6.021184, -76.987839)
  );
  polylineCoordinate.add(
      LatLng(-6.021776, -76.988057)
  );
  polylineCoordinate.add(
      LatLng(-6.021824, -76.987517)
  );
  polylineCoordinate.add(
      LatLng(-6.021184, -76.987839)
  );


  update();
 }

  setPolyline(var i){

    _polylinesDraw.add(
      Polyline(
        width: 10,
        polylineId: PolylineId('$i'),
        color: Colors.green,
        points: polylineCoordinate
      )
    );
    update();

  }

  setPolygon(){
    _polygons.add(
      Polygon(
        polygonId: PolygonId('polygon_id_$_polygonCounterId'),
        points: polylineCoordinate,
        strokeWidth: 2,
        strokeColor: Colors.green,
        fillColor: Colors.yellow
      )
    );
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
    /*_markers.add(
      Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'Punto $i',
          snippet: 'Latitud: ${position.latitude} , Longitud: ${position.longitude}'
        ),
        icon: BitmapDescriptor.defaultMarker
      )
    );*/ 
    
    print(_markers.length);

    
    print(polylineCoordinate);
    setPolyline(i);
    i = i+1;
    //setPolygon();
    update();

  }

  polygonSave()async{

    setPolygon();
    calculateAreaPolygon();
    showModaLoading();
    var dataSend = {
      "area"              : double.parse(areacalculada),
      "descripcion"       : "Prueba2",
      "foto"              : "",
      "idSeccion"         : idSeccion,  // id del encuestado
      "ubigeo"            : ubigeo,
      "seccion"           : "BENEFICIARIO"
    };

    var coordenadas ={};
    List<Map> listCoordenadasMap = new List();

    polylineCoordinate.forEach((element) { 

      coordenadas["latitud"] = element.latitude;
      coordenadas["longitud"] = element.longitude;
      

      listCoordenadasMap.add(
        coordenadas
      );
      
      coordenadas ={};
    });
    dataSend['parcelaCoordenada']  = listCoordenadasMap;
    print(listCoordenadasMap);
    print(dataSend);
    var result  = await apiConexion.saveParcela(dataSend);
    
    if(result["success"] == true){

      Get.back();
      Get.back();

    }

    print(result);

    update();
  }
  
  showModaLoading(){
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        title: Text('Guardando la data ..'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator()
          ],
        ),
      )
    );
  }

  calculateAreaPolygon(){
    double area = 0;
    if(polylineCoordinate.length > 2){
      for (var i = 0; i < polylineCoordinate.length - 1; i++) {
        var p1 = polylineCoordinate[i];
        var p2 = polylineCoordinate[i + 1];
        //var p3 = polylineCoordinate[i + 2];
        area += convertToRadian(p2.longitude - p1.longitude) * 
        ( 2 + 
          Math.sin(convertToRadian(p1.latitude)) + 
          Math.sin(convertToRadian(p2.latitude)) 
          
        );
        
      }
      area = area * 6378137 * 6378137 / 2;
    }
    //areacalculada = (area.abs() * 0.000247105).toString();
    areacalculada = (area.abs()).toString();
    print("resultado : $areacalculada" ); 

  }

  double convertToRadian(double input){
    return input * Math.pi/180;
  }




}