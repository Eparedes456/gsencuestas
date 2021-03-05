import 'dart:convert';

List<FichasModel> fichasFromJson(String str) =>
    List<FichasModel>.from(json.decode(str).map((x) => FichasModel.fromJson(x)));

    String fichasToJson(List<FichasModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


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
  String  updated_at; 
   
    FichasModel({

      this.id_ficha,this.id_encuesta,this.id_usuario,this.id_encuestado,this.latitud,this.longitud,
      this.fecha_inicio,this.fecha_fin,this.estado,this.updated_at

    });


     // El from json es para mostrare los datos de la base de datos local

  factory FichasModel.fromJson(Map<String, dynamic> json) => FichasModel(

    id_ficha        : json["id_ficha"],
    id_encuesta     : json["id_encuesta"],
    id_usuario      : json['id_usuario'],
    id_encuestado   : json['id_encuestado'],
    latitud         : json['latitud'],
    longitud        : json['longitud'],
    fecha_inicio    : json['fecha_inicio'],
    fecha_fin       : json['fecha_fin'],
    estado          : json['estado'],
    updated_at      : json['updated_at']       

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toJson(){

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
      'updated_at'    : updated_at


    };


  }


}