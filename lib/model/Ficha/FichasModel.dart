import 'dart:convert';

FichasModel fichasFromJson(String str){

  final jsonData = json.decode(str);
  return FichasModel.fromMap(jsonData);

}

String fichasToJson( FichasModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}


class FichasModel {

  
  int     idFicha;
  int     idEncuesta;
  int     idUsuario;
  int     idEncuestado;
  String  latitud;
  String  longitud;
  String  latitud_retorno;
  String  longitud_retorno;
  String  fecha_inicio;
  String  fecha_fin;
  String  fecha_retorno;
  String  fecha_envio;
  String  observacion;
  String  estado;
  String  ubigeo;
  String  createdAt;
  String  updatedAt; 
   
    FichasModel({

      this.idFicha,this.idEncuesta,this.idUsuario,this.idEncuestado,this.latitud,this.longitud,this.latitud_retorno,this.longitud_retorno,
      this.fecha_inicio,this.fecha_fin, this.fecha_retorno ,this.fecha_envio ,this.ubigeo ,this.estado,this.createdAt ,this.updatedAt,this.observacion
      
    });


     // El from json es para mostrare los datos de la base de datos local

  factory FichasModel.fromMap(Map<String, dynamic> json) => FichasModel(

    idFicha         : json["idFicha"],
    idEncuesta      : json["idEncuesta"],
    idUsuario       : json['idUsuario'],
    idEncuestado    : json['idEncuestado'],
    latitud         : json['latitud'],
    longitud        : json['longitud'],
    latitud_retorno : json['latitud_retorno'],
    longitud_retorno: json['longitud_retorno'],
    fecha_inicio    : json['fecha_inicio'],
    fecha_fin       : json['fecha_fin'],
    fecha_retorno   : json['fecha_retorno'],
    fecha_envio     : json['fecha_envio'],
    ubigeo          : json['ubigeo'],
    estado          : json['estado'].toString(),
    createdAt       : json['createdAt'],
    updatedAt       : json['updatedAt'],
    observacion     : json['observacion'],
   

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {

      'id_ficha'        : idFicha,      
      'id_encuesta'     : idEncuesta,     
      'id_usuario'      : idUsuario,      
      'id_encuestado'   : idEncuestado,   
      'latitud'         : latitud,         
      'longitud'        : longitud,
      'latitud_retorno' : latitud_retorno,
      'longitud_retorno': longitud_retorno,      
      'fecha_inicio'    : fecha_inicio,    
      'fecha_fin'       : fecha_fin,
      'fecha_retorno'   : fecha_retorno,
      'fecha_envio'     : fecha_envio,
      'ubigeo'          : ubigeo,       
      'estado'          : estado, 
      'createdAt'       : createdAt, 
      'updatedAt'       : updatedAt,
      'observacion'     : observacion


    };


  }


}