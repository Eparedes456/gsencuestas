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
  String idTecnico;
  String validadoReniec;
  String idInstitucion;
  String createdAt;
  String updatedAt;

  EncuestadoModel(
    {
      this.idEncuestado, this.documento, this.nombre, this.apellidoPaterno, this.apellidoMaterno, this.sexo, this.estadoCivil, this.direccion, this.telefono, this.email, this.foto, this.estado, this.tipoPersona,
      this.tipoDocumento, this.representanteLegal, this.idUbigeo, this.observacion, this.validadoReniec,this.idInstitucion,
      this.idTecnico,this.createdAt, this.updatedAt
    }
  );
  
     // El from json es para mostrare los datos de la base de datos local
  factory EncuestadoModel.fromMap(Map<String, dynamic> json) => EncuestadoModel(
    idEncuestado            : json["idEncuestado"].toString(),
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
    idUbigeo                : json["idUbigeo"].toString(),
    validadoReniec          : json["validadoReniec"].toString(),
    idTecnico               : json["idTecnico"].toString(),
    idInstitucion           : json["idInstitucion"].toString(),
    estado                  : json['estado'],
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
      'idUbigeo'                    : idUbigeo,
      'validadoReniec'              : validadoReniec,
      'idTecnico'                   : idTecnico,
      'idInstitucion'               : idInstitucion,
      'estado'                      : estado,
    };
  }
}