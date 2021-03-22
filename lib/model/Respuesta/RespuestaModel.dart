import 'dart:convert';

List<RespuestaModel> respuestaFromJson(String str) =>
    List<RespuestaModel>.from(json.decode(str).map((x) => RespuestaModel.fromJson(x)));

    String respuestaToJson(List<RespuestaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class RespuestaModel {

  
  int     id_respuesta;
  int     idsOpcion;
  int     id_ficha;
  String  valor;
  int     estado;
  String  createdAt;
  String  updatedAt;
  
   
    RespuestaModel({

      this.id_respuesta,this.idsOpcion,this.id_ficha,this.valor,this.estado, this.createdAt ,this.updatedAt

    });


     // El from json es para mostrare los datos de la base de datos local

  factory RespuestaModel.fromJson(Map<String, dynamic> json) => RespuestaModel(


    id_respuesta            : json["id_respuesta"],
    idsOpcion               : json['idsOpcion'],
    id_ficha                : json['id_ficha'],
    valor                   : json['valor'],
    estado                  : json['estado'],
    createdAt               : json['createdAt'],
    updatedAt               : json['updatedAt'], 
           

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toJson(){

    return {
    
      'id_respuesta'             : id_respuesta,
      'idsOpcion'                : idsOpcion,
      'id_ficha'                 : id_ficha,
      'valor'                    : valor,
      'estado'                   : estado,
      'createdAt'                : createdAt,
      'updatedAt'               : updatedAt,
     

    };


  }


}