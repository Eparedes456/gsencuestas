import 'dart:convert';

import 'package:flutter/material.dart';



ProyectoModel proyectoFromJson(String str){

  final jsonData = json.decode(str);
  return ProyectoModel.fromMap(jsonData);

}

String proyectoToJson( ProyectoModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}



class ProyectoModel{

  
  int idProyecto;
  String nombre;
  String abreviatura;
  String nombreResponsable;
  String logo;
  String latitud;
  String longitud;
  String idUsuario;
  String estado;
  String createdAt;
  String updatedAt;

  ProyectoModel(
    {
      this.idProyecto,this.nombre,this.abreviatura,this.nombreResponsable,this.logo,
      this.latitud,this.longitud,this.idUsuario,this.estado,this.createdAt,this.updatedAt
        
    }
  );

  factory ProyectoModel.fromMap(Map<String, dynamic> json) => ProyectoModel(

    
    idProyecto          : json['idProyecto'],
    nombre              : json['nombre'],
    abreviatura         : json['abreviatura'],
    nombreResponsable   : json['nombreResponsable'],
    logo                : json['logo'],
    latitud             : json['latitud'],
    longitud            : json['longitud'],
    idUsuario           : json['idUsuario'].toString(),
    estado              : json['estado'],
    createdAt           : json['createdAt'],
    updatedAt           : json['updatedAt'],
  );

  Map<String,dynamic> toMap(){

    return{

      'idProyecto'         : idProyecto,
      'nombre'              : nombre,
      'abreviatura'         : abreviatura,
      'nombreResponsable'   : nombreResponsable,
      'logo'                : logo,
      'latitud'             : latitud,
      'longitud'            : longitud,
      'idUsuario'           : idUsuario,
      'estado'              : estado,
      'createdAt'           : createdAt,
      'updatedAt'            : updatedAt,   

    };


  }

    



 


}


