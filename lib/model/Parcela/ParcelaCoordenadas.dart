import 'package:flutter/material.dart';

import 'dart:convert';

ParcelaCoordenadasModel parcelasCoordenadasFromJson(String str){

  final jsonData = json.decode(str);
  return ParcelaCoordenadasModel.fromMap(jsonData);

}

String parcelasCoordenadasToJson( ParcelaCoordenadasModel data ){
  final dyn = data.toMap();
  return json.encode(dyn);
}


class ParcelaCoordenadasModel {
  int         idParcelaCoordenada;
  int         idParcela;
  String      latitud;
  String      longitud;
  int         orden;
   
    ParcelaCoordenadasModel({

      this.idParcelaCoordenada,this.idParcela,this.latitud,this.longitud,this.orden

    });


     // El from json es para mostrare los datos de la base de datos local

  factory ParcelaCoordenadasModel.fromMap(Map<String, dynamic> json) => ParcelaCoordenadasModel(

    idParcelaCoordenada         : json["idParcelaCoordenada"],
    idParcela                   : json["idParcela"],
    latitud                     : json['latitud'],
    longitud                    : json['longitud'],
    orden                       : json['orden'] 
    
  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {

      'idParcelaCoordenada'       : idParcelaCoordenada,      
      'idParcela'                 : idParcela,     
      'latitud'                   : latitud,      
      'longitud'                  : longitud,
      'orden'                     : orden   
      
    };


  }


}