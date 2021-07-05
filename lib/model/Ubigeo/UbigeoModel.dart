import 'dart:convert';

import 'package:flutter/material.dart';

UbigeoModel trackingFromJson(String str) {
  final jsonData = json.decode(str);
  return UbigeoModel.fromJson(jsonData);
}

String trackingToJson(UbigeoModel data) {
  final dyn = data.toMap();

  return json.encode(dyn);
}

class UbigeoModel {
  int idUbigeo;
  String codigoDepartamento;
  String codigoProvincia;
  String codigoDistrito;
  String codigoCentroPoblado;
  String descripcion;

  UbigeoModel(
      {this.idUbigeo,
      this.codigoDepartamento,
      this.codigoProvincia,
      this.codigoDistrito,
      this.descripcion,
      this.codigoCentroPoblado});

  /*factory UbigeoModel.fromMap(Map<String, dynamic> json) => UbigeoModel(

    idUbigeo              : json["id"],
    codigoDepartamento    : json["codigoDepartamento"]  ,
    codigoProvincia       : json["codigoProvincia"],
    codigoDistrito        : json['codigoDistrito'],
    descripcion           : json['descripcion'],
  );*/

  factory UbigeoModel.fromJson(Map<String, dynamic> json) {
    return UbigeoModel(
      idUbigeo: json["id"],
      codigoDepartamento: json["codigoDepartamento"],
      codigoProvincia: json["codigoProvincia"],
      codigoDistrito: json['codigoDistrito'],
      codigoCentroPoblado: json['codigoCentroPoblado'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUbigeo': idUbigeo,
      'codigoDepartamento': codigoDepartamento,
      'codigoProvincia': codigoProvincia,
      'codigoDistrito': codigoDistrito,
      'codigoCentroPoblado': codigoCentroPoblado,
      'descripcion': descripcion,
    };
  }
}
