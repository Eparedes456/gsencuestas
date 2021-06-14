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
  int         idBeneficiario;
  String      latitud;
  String      longitud;
  
   
    ParcelaCoordenadasModel({

      this.idParcelaCoordenada,this.idParcela,this.idBeneficiario,this.latitud,this.longitud,

    });


     // El from json es para mostrare los datos de la base de datos local

  factory ParcelaCoordenadasModel.fromMap(Map<String, dynamic> json) => ParcelaCoordenadasModel(

    idParcelaCoordenada         : json["idParcelaCoordenada"],
    idParcela                   : json["idParcela"],
    idBeneficiario              : json["idBeneficiario"],
    latitud                     : json['latitud'],
    longitud                    : json['longitud'],
     
    
  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {

      'idParcelaCoordenada'       : idParcelaCoordenada,      
      'idParcela'                 : idParcela,   
      'idBeneficiario'            : idBeneficiario,  
      'latitud'                   : latitud,      
      'longitud'                  : longitud,
       
      
    };


  }


}