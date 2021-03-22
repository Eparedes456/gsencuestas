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

  
  int     id_ficha;
  int     id_encuesta;
  int     id_usuario;
  int     id_encuestado;
  String  latitud;
  String  longitud;
  String  fecha_inicio;
  String  fecha_fin;
  String  observacion;
  int     estado;
  String  createdAt;
  String  updatedAt; 
   
    FichasModel({

      this.id_ficha,this.id_encuesta,this.id_usuario,this.id_encuestado,this.latitud,this.longitud,
      this.fecha_inicio,this.fecha_fin,this.estado,this.createdAt ,this.updatedAt

    });


     // El from json es para mostrare los datos de la base de datos local

  factory FichasModel.fromMap(Map<String, dynamic> json) => FichasModel(

    id_ficha        : json["id_ficha"],
    id_encuesta     : json["id_encuesta"],
    id_usuario      : json['id_usuario'],
    id_encuestado   : json['id_encuestado'],
    latitud         : json['latitud'],
    longitud        : json['longitud'],
    fecha_inicio    : json['fecha_inicio'],
    fecha_fin       : json['fecha_fin'],
    estado          : json['estado'],
    createdAt       : json['createdAt'],
    updatedAt       : json['updatedAt']       

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {

      'id_ficha'      : id_ficha,      
      'id_encuesta'   : id_encuesta,     
      'id_usuario'    : id_usuario,      
      'id_encuestado' : id_encuestado,   
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