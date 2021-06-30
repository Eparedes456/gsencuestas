import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
    onload();
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

  bool showCard = false;
  String latitud = "";
  String longitud = "";
  String punto = "";

  //Set<Marker> _markers = Set<Marker>();
  //Set<Marker> get markers => _markers;

  final Map<MarkerId,Marker> _markers ={};
  Set<Marker> get markers =>_markers.values.toSet();

  LatLng miubicacion;
  Position position;
  bool load = true;
  var i;
  int _polygonCounterId = 1;
  String areacalculada = "";
  List listCodDep = [];
  List listcodProvincia = [];
  List liscodDistrito = [];
  TextEditingController _descripcion = new TextEditingController();
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
  print(_initialCameraPosition);

  if(miubicacion.latitude != null){
    load = false;
  }

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
    update();
  }

  /*showMarker(){

    _markers.add(
      Marker(
        markerId: MarkerId('inicio'),
        position: miubicacion,
        icon: BitmapDescriptor.defaultMarker
      )
    );

    update();

  }*/

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
    final markerid = MarkerId(i.toString());
    final marker = Marker(
      markerId: markerid,
      position: LatLng(position.latitude, position.longitude),
    );
    _markers[markerid] = marker;

    polylineCoordinate.add(
      LatLng(position.latitude, position.longitude)
    ); 
    
    print(_markers.length);

    
    print(polylineCoordinate);
    setPolyline(i);
    i = i+1;
    //setPolygon();
    update();

  }

  polygonSave()async{

    setPolygon();
    //calculateAreaPolygon();
    showModaLoading();
    var dataSend = {
      "area"              : double.parse(areacalculada),
      "descripcion"       : _descripcion.text,
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

  modal(){
    calculateAreaPolygon();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        title: Text('Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Area en m2 : $areacalculada'),
            SizedBox(height: 12,),
            TextField(
              controller: _descripcion,
              decoration: InputDecoration(
                hintText: 'Ingrese una descripcion',
                hintStyle: TextStyle(
                  fontSize: 12
                )
              ),
            ),
            SizedBox(height: 12,),
            MaterialButton(
              color: Color.fromRGBO(0, 102, 84, 1),
              onPressed: (){
                Get.back();
                polygonSave();
              },
              child: Text('Guardar',style: TextStyle(color: Colors.white),),
            )
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

  tapMap(/*LatLng position*/)async{
    i = 1;
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final markerId = MarkerId(  (_markers.length + 1).toString());
    final marker = Marker(
      markerId: markerId,
      position: LatLng(position.latitude,position.longitude),
      /*infoWindow:  InfoWindow(
          title: 'Punto ${(_markers.length + 1).toString()}',
          snippet: 'Latitud: ${position.latitude} , Longitud: ${position.longitude}'
      ),*/
      onTap: (){
        showCard = true;
        latitud = position.latitude.toString();
        longitud = position.longitude.toString();
        punto = markerId.value.toString();
        update();
      }
    );
    _markers[markerId] = marker;
    polylineCoordinate.add(
      LatLng(position.latitude, position.longitude)
    ); 
  
    setPolyline(i);
    i = i+1;

    update();
  }

  close(){
     showCard = false;
    update();
  }

  deleteMarker(String numeroMarker){
    _markers.removeWhere((key, value) => key.value == numeroMarker);
    print(_markers.length);
    showCard = false;
    if(_markers.length == 0){
      polylineCoordinate =  [];
    }
    update();
    //controllerInput.removeWhere((item) => item.controller.text == "");
  }



}