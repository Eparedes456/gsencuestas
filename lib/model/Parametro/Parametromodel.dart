import 'dart:convert';

ParametroModel usuarioFromJson(String str){

  final jsonData = json.decode(str);
  return ParametroModel.fromMap(jsonData);

}

String usuarioToJson( ParametroModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}

class ParametroModel {
  int idParametro;
  String ultiimaActualizacionUsuario;
  int idInstitucion;
  String ultimaActualizacion;

  ParametroModel({this.idParametro,this.ultiimaActualizacionUsuario,this.idInstitucion,this.ultimaActualizacion});

  factory ParametroModel.fromMap(Map<String, dynamic> json) => ParametroModel(
    idParametro                   : json['idParametro'],
    ultiimaActualizacionUsuario   : json['ultiimaActualizacionUsuario'],
    idInstitucion                 : json['idInstitucion'],
    ultimaActualizacion           : json['ultimaActualizacion'],
  );

  Map<String,dynamic> toMap(){
    return{
      'idParametro'                 : idParametro,
      'ultiimaActualizacionUsuario' : ultiimaActualizacionUsuario,
      'idInstitucion'               : idInstitucion,
      'ultimaActualizacion'         : ultimaActualizacion,
    };
  }

}

