import 'package:flutter/material.dart';
import 'dart:convert';


MultimediaModel multimediaFromJson(String str){

  final jsonData = json.decode(str);
  return MultimediaModel.fromMap(jsonData);

}

String multimediaToJson( MultimediaModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}


class MultimediaModel{

  
  String idMultimedia;
  String idFicha;
  String tipo;
  String latitud;
  String longitud;
  String fecha_capturada;
  String nombre;

  MultimediaModel(
    {

      this.idMultimedia, this.idFicha, this.tipo, this.latitud, this.longitud,this.fecha_capturada,this.nombre

    }


  );

     // El from json es para mostrare los datos de la base de datos local

  factory MultimediaModel.fromMap(Map<String, dynamic> json) => MultimediaModel(

    idMultimedia            : json["idMultimedia"].toString(),
    idFicha                 : json["idFicha"].toString(),
    tipo                    : json["tipo"],
    latitud                 : json['latitud'],
    longitud                : json['longitud'],
    fecha_capturada         : json['fecha_capturada'],   
    nombre                  : json['nombre'] 
               

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
      
      'idMultimedia'    :   idMultimedia,
      'idFicha'         :   idFicha,  
      'tipo'            :   tipo,
      'latitud'         :   latitud,
      'longitud'        :   longitud,
      'fecha_capturada' :   fecha_capturada,
      'nombre'          :   nombre

    };


  }



}