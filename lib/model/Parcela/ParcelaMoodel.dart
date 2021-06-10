import 'package:flutter/material.dart';

import 'dart:convert';

ParcelaModel parcelasFromJson(String str){

  final jsonData = json.decode(str);
  return ParcelaModel.fromMap(jsonData);

}

String parcelasToJson( ParcelaModel data ){
  final dyn = data.toMap();
  return json.encode(dyn);
}


class ParcelaModel {
  int         idParcela;
  String      descripcion;
  int         idSeccion;
  String      seccion;
  double      area;
  String      ubigeo;
  String      foto;
  String      createdAt;
  String      updatedAt; 
   
    ParcelaModel({

      this.idParcela,this.descripcion,this.idSeccion,this.seccion,this.area,this.ubigeo,this.foto,
      this.createdAt ,this.updatedAt

    });


     // El from json es para mostrare los datos de la base de datos local

  factory ParcelaModel.fromMap(Map<String, dynamic> json) => ParcelaModel(

    idParcela         : json["idParcela"],
    descripcion       : json["descripcion"],
    idSeccion         : json['idSeccion'],
    seccion           : json['seccion'],
    area              : json['area'],
    ubigeo            : json['ubigeo'],
    foto              : json['foto'],
    createdAt         : json['createdAt'],
    updatedAt         : json['updatedAt']       

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
      'idParcela'       : idParcela,      
      'descripcion'     : descripcion,     
      'idSeccion'       : idSeccion,      
      'seccion'         : seccion,   
      'area'            : area,         
      'ubigeo'          : ubigeo,      
      'foto'            : foto,    
      'createdAt'     : createdAt, 
      'updatedAt'     : updatedAt

    };


  }


}