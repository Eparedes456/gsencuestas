import 'dart:convert';

import 'package:flutter/material.dart';



List<ProyectoModel> employeeFromJson(String str) => List<ProyectoModel>.from(json.decode(str).map((x) => ProyectoModel.fromJson(x)));

String employeeToJson(List<ProyectoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));



class ProyectoModel{

  String createdAt;
  String updatedAt;
  int idProyecto;
  String nombre;
  String abreviatura;
  String nombreResponsable;
  String logo;
  String latitud;
  String longitud;
  bool estado;
  

  ProyectoModel(
      {
        this.createdAt,this.updatedAt,this.idProyecto,this.nombre,this.abreviatura,this.nombreResponsable,this.logo,this.latitud,this.longitud,this.estado,
        
      }
  );

  factory ProyectoModel.fromJson(Map<String, dynamic> json) => ProyectoModel(

    createdAt           : json['createdAt'],
    updatedAt           : json['updatedAt'],
    idProyecto          : json['idProyecto'],
    nombre              : json['nombre'],
    abreviatura         : json['abreviatura'],
    nombreResponsable   : json['nombreResponsable'],
    logo                : json['logo'],
    latitud             : json['latitud'],
    longitud            : json['longitud'],
    estado              : json['estado'],
  );

  Map<String,dynamic> toJson(){

    return{

      'createdAt'           : createdAt,
      'updateAt'            : updatedAt,
      'id_proyecto'         : idProyecto,
      'nombre'              : nombre,
      'abreviatura'         : abreviatura,
      'nombreResponsable'   : nombreResponsable,
      'logo'                : logo,
      'latitud'             : latitud,
      'longitud'            : longitud,
      'estado'              : estado   

    };


  }

    



  /*ProyectoModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    idProyecto = json['idProyecto'];
    nombre = json['nombre'];
    abreviatura = json['abreviatura'];
    nombreResponsable = json['nombre_responsable'];
    logo = json['logo'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    estado = json['estado'];
    institucion = json['institucion']; 
  }*/


  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['idProyecto'] = this.idProyecto;
    data['nombre'] = this.nombre;
    data['abreviatura'] = this.abreviatura;
    data['nombre_responsable'] = this.nombreResponsable;
    data['logo'] = this.logo;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['estado'] = this.estado;
    data['institucion'] = this.institucion;
    
    
  }*/



}


