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
  String  fecha_inicio;
  String  fecha_fin;
  String  observacion;
  String     estado;
  String  createdAt;
  String  updatedAt; 
   
    FichasModel({

      this.idFicha,this.idEncuesta,this.idUsuario,this.idEncuestado,this.latitud,this.longitud,
      this.fecha_inicio,this.fecha_fin,this.estado,this.createdAt ,this.updatedAt

    });


     // El from json es para mostrare los datos de la base de datos local

  factory FichasModel.fromMap(Map<String, dynamic> json) => FichasModel(

    idFicha         : json["idFicha"],
    idEncuesta      : json["idEncuesta"],
    idUsuario       : json['idUsuario'],
    idEncuestado    : json['idEncuestado'],
    latitud         : json['latitud'],
    longitud        : json['longitud'],
    fecha_inicio    : json['fecha_inicio'],
    fecha_fin       : json['fecha_fin'],
    estado          : json['estado'].toString(),
    createdAt       : json['createdAt'],
    updatedAt       : json['updatedAt']       

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {

      'id_ficha'      : idFicha,      
      'id_encuesta'   : idEncuesta,     
      'id_usuario'    : idUsuario,      
      'id_encuestado' : idEncuestado,   
      'latitud'       : latitud,         
      'longitud'      : longitud,      
      'fecha_inicio'  : fecha_inicio,    
      'fecha_fin'     : fecha_fin,       
      'estado'        : estado, 
      'createdAt'     : createdAt, 
      'updatedAt'     : updatedAt


    };


  }


}