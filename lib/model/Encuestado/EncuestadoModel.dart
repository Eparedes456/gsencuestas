import 'package:flutter/material.dart';
import 'dart:convert';


EncuestadoModel encuestadoFromJson(String str){

  final jsonData = json.decode(str);
  return EncuestadoModel.fromMap(jsonData);

}

String encuestadoToJson( EncuestadoModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}


class EncuestadoModel{

  
  String idEncuestado;
  String documento;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String sexo;
  String estadoCivil;
  String direccion;
  String telefono;
  String email;
  String foto;
  String estado;
  String tipoPersona;
  String tipoDocumento;
  String representanteLegal;
  String idUbigeo;
  String observacion;
  String createdAt;
  String updatedAt;

  EncuestadoModel(
    {

      this.idEncuestado, this.documento, this.nombre, this.apellidoPaterno, this.apellidoMaterno, this.sexo, this.estadoCivil, this.direccion, this.telefono, this.email, this.foto, this.estado, this.tipoPersona,
      this.tipoDocumento, this.representanteLegal, this.idUbigeo, this.observacion, this.createdAt, this.updatedAt

    }


  );

     // El from json es para mostrare los datos de la base de datos local

  factory EncuestadoModel.fromMap(Map<String, dynamic> json) => EncuestadoModel(

    idEncuestado            : json["idEncuestado"],
    documento               : json["documento"],
    nombre                  : json["nombre"],
    apellidoPaterno         : json['apellidoPaterno'],
    apellidoMaterno         : json['apellidoMaterno'],
    sexo                    : json['sexo'],
    estadoCivil             : json['estadoCivil'],
    direccion               : json['direccion'],
    telefono                : json['telefono'],
    email                   : json['email'],
    foto                    : json['foto'],
    estado                  : json['estado'],
    tipoPersona             : json['tipoPersona'],
    tipoDocumento           : json['tipoDocumento'],
    representanteLegal      : json['representanteLegal'],
    idUbigeo                : json['idUbigeo'],
    observacion             : json['observacion'],
    createdAt               : json['createdAt'] ,
    updatedAt               : json['updatedAt'],             

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
      
      'idEncuestado'                : idEncuestado,
      'documento'                   : documento,
      'nombre'                      : nombre,
      'apellidoPaterno'             : apellidoPaterno,
      'apellidoMaterno'             : apellidoMaterno,
      'sexo'                        : sexo,
      'estadoCivil'                 : estadoCivil,
      'direccion'                   : direccion,
      'telefono'                    : telefono,
      'email'                       : email,
      'foto'                        : foto,
      'estado'                      : estado,
      'tipoPersona'                 : tipoPersona,
      'tipoDocumento'               : tipoDocumento,
      'representanteLegal'          : representanteLegal,
      'idUbigeo'                    : idUbigeo,
      'observacion'                 : observacion,
      'createdAt'                   : createdAt,
      'updatedAt'                   : updatedAt,


    };


  }



}