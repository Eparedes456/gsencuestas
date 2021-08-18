import 'dart:convert';

import 'package:flutter/material.dart';

MisEncuestasModel misEncuestaFromJson(String str){

  final jsonData = json.decode(str);
  return MisEncuestasModel.fromMap(jsonData);

}

String misEncuestaToJson( MisEncuestasModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}

class MisEncuestasModel{

  String idFicha;
  String idProyecto;
  String idEncuesta;
  String nombreEncuestado;
  String nombreProyecto;
  String nombreEncuesta;
  String nroPreguntas;
  String fechaInicio;
  String imagen;
  String estadoFicha;
  String esRetomado;
  String preguntasRespondidas;
  String totalPreguntas;
  double percent;
  String porcentaje;

  MisEncuestasModel({

    this.idFicha, this.idProyecto, this.idEncuesta, this.nombreEncuestado ,this.nombreProyecto, this.nombreEncuesta, this.nroPreguntas,
    this.fechaInicio, this.imagen ,this.estadoFicha,this.esRetomado,this.preguntasRespondidas,this.totalPreguntas,
    this.percent,this.porcentaje

  });

    // El from json es para mostrare los datos de la base de datos local

  factory MisEncuestasModel.fromMap(Map<String, dynamic> json) => MisEncuestasModel(

    idFicha             : json["idFicha"],
    idProyecto          : json["idProyecto"]  ,
    idEncuesta          : json["idEncuesta"],
    nombreEncuestado    : json["nombreEncuestado"],
    nombreProyecto      : json['nombreProyecto'],
    nombreEncuesta      : json['nombreEncuesta'],
    nroPreguntas        : json['nroPreguntas'],
    fechaInicio         : json['fechaInicio'],
    imagen              : json['imagen'],
    estadoFicha         : json['createdAt'] ,            

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
      
      'id_opcion'             : idFicha,
      'idPreguntaGrupoOpcion' : idProyecto,
      'idPregunta'            : idEncuesta,
      'nombreEncuesta'        : nombreEncuesta,
      'valor'                 : nombreProyecto,
      'label'                 : nombreEncuesta,
      'orden'                 : nroPreguntas,
      'estado'                : fechaInicio,
      'createdAt'             : imagen,
      'updated_at'            : estadoFicha,
      'esRetomado'            : esRetomado,
      'preguntasRespondidas'  : preguntasRespondidas,
      'totalPreguntas'        : totalPreguntas,
      'percent'               : percent,
      'porcentaje'            : porcentaje


    };


  }



}