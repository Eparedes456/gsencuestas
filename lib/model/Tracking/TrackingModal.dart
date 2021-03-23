import 'dart:convert';

import 'package:flutter/material.dart';

TrackingModel trackingFromJson(String str){

  final jsonData = json.decode(str);
  return TrackingModel.fromMap(jsonData);

}

String trackingToJson( TrackingModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}

class TrackingModel {

  int idTracking;
  int idFicha;
  String latitud;
  String longitud;
  String estado;
  



  TrackingModel({  this.idTracking, this.idFicha, this.latitud, this.longitud, this.estado });




  factory TrackingModel.fromMap(Map<String, dynamic> json) => TrackingModel(

    idTracking              : json["idTracking"],
    idFicha                 : json["idFicha"]  ,
    latitud                 : json["latitud"],
    longitud                : json['longitud'],
    estado                  : json['estado'],
  );




  Map<String,dynamic> toMap(){

    return {
      
      'idTracking'              : idTracking,
      'idFicha'                 : idFicha,
      'latitud'                 : latitud,
      'longitud'                : longitud,
      'estado'                  : estado,
      
    };


  }

}


  