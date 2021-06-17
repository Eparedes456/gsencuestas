import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:gsencuesta/model/Parcela/ParcelaCoordenadas.dart';

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
  Uint8List      foto;
  String      nombreCompleto;
  List<ParcelaCoordenadasModel> coordenadas;
  String      createdAt;
  String      updatedAt; 
   
    ParcelaModel({

      this.idParcela,this.descripcion,this.idSeccion,this.seccion,this.area,this.ubigeo,this.foto,this.nombreCompleto,this.coordenadas,
      this.createdAt ,this.updatedAt

    });


     // El from json es para mostrare los datos de la base de datos local

  factory ParcelaModel.fromMap(Map<String, dynamic> json) => ParcelaModel(

    idParcela         : json["idParcela"],
    descripcion       : json["descripcion"],
    idSeccion         : json['idSeccion'],
    seccion           : json['seccion'],
    area              : double.parse(json['area']) ,
    ubigeo            : json['ubigeo'],
    foto              : json['foto'],
    nombreCompleto    : json['nombreCompleto'],
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
      'nombreCompleto'  : nombreCompleto,    
      'createdAt'       : createdAt, 
      'updatedAt'       : updatedAt

    };


  }


}