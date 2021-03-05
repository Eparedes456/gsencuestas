import 'dart:convert';

List<RespuestaModel> respuestaFromJson(String str) =>
    List<RespuestaModel>.from(json.decode(str).map((x) => RespuestaModel.fromJson(x)));

    String respuestaToJson(List<RespuestaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class RespuestaModel {

  
  int     id_respuesta;
  int     id_pregunta;
  int     id_ficha;
  String  valor;
  int     estado;
  String  updated_at;
  
   
    RespuestaModel({

      this.id_respuesta,this.id_pregunta,this.id_ficha,this.valor,this.estado,this.updated_at

    });


     // El from json es para mostrare los datos de la base de datos local

  factory RespuestaModel.fromJson(Map<String, dynamic> json) => RespuestaModel(


    id_respuesta            : json["id_respuesta"],
    id_pregunta             : json['id_pregunta'],
    id_ficha                : json['id_ficha'],
    valor                   : json['valor'],
    estado                  : json['estado'],
    updated_at              : json['updated_at'], 
           

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toJson(){

    return {
    
      'id_respuesta'             : id_respuesta,
      'id_pregunta'              : id_pregunta,
      'id_ficha'                 : id_ficha,
      'valor'                    : valor,
      'estado'                   : estado,
      'updated_at'               : updated_at,
     

    };


  }


}