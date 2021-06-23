
import 'dart:convert';

import 'package:flutter/material.dart';

UbigeoModel trackingFromJson(String str){

  final jsonData = json.decode(str);
  return UbigeoModel.fromMap(jsonData);

}

String trackingToJson( UbigeoModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}

class UbigeoModel {

  int idUbigeo;
  String codigoDepartamento;
  String codigoProvincia;
  String codigoDistrito;
  String descripcion;
  

  UbigeoModel({  this.idUbigeo ,this.codigoDepartamento, this.codigoProvincia, this.codigoDistrito, 
    this.descripcion
  
  });




  factory UbigeoModel.fromMap(Map<String, dynamic> json) => UbigeoModel(

    idUbigeo              : json["id"],
    codigoDepartamento    : json["codigoDepartamento"]  ,
    codigoProvincia       : json["codigoProvincia"],
    codigoDistrito        : json['codigoDistrito'],
    descripcion           : json['descripcion'],
  );




  Map<String,dynamic> toMap(){

    return {
      
      'idUbigeo'                : idUbigeo,
      'codigoDepartamento'      : codigoDepartamento,
      'codigoProvincia'         : codigoProvincia,
      'codigoDistrito'          : codigoDistrito,
      'descripcion'             : descripcion,
      
    };


  }

}


  