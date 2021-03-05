import 'dart:convert';

List<BloqueModel> bloqueFromJson(String str) =>
    List<BloqueModel>.from(json.decode(str).map((x) => BloqueModel.fromJson(x)));

    String bloqueToJson(List<BloqueModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class BloqueModel {

  
  int     id_bloque;
  int     id_encuesta;
  String  nombre;
  String  icono;
  int     estado;
  String  updated_at; 
   
    BloqueModel({

      this.id_bloque,this.id_encuesta,this.nombre,this.icono,this.estado,this.updated_at

    });


     // El from json es para mostrare los datos de la base de datos local

  factory BloqueModel.fromJson(Map<String, dynamic> json) => BloqueModel(


    id_bloque       : json["id_encuesta"],
    id_encuesta     : json['id_proyecto'],
    nombre          : json['titulo'],
    icono           : json['descripcion'],
    estado          : json['estado'],
    updated_at      : json['updated_at']       

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toJson(){

    return {
    
      'id_bloque'     : id_bloque,     
      'id_encuesta'   : id_encuesta,      
      'nombre'        : nombre,   
      'icono'         : icono,         
      'estado'        : estado,
      'updated_at'    : updated_at

    };


  }


}