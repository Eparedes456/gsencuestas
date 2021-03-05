import 'dart:convert';

List<OpcionesModel> opcionesFromJson(String str) =>
    List<OpcionesModel>.from(json.decode(str).map((x) => OpcionesModel.fromJson(x)));

    String opcionesToJson(List<OpcionesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class OpcionesModel {

  int     id_opcion;
  int     id_pregunta;
  String  valor;
  String  label;
  int     orden;
  String  estado;
  String  updated_at;  
   
    OpcionesModel({

      this.id_opcion,this.id_pregunta,this.valor,this.label,this.orden,this.estado,this.updated_at

    });


     // El from json es para mostrare los datos de la base de datos local

  factory OpcionesModel.fromJson(Map<String, dynamic> json) => OpcionesModel(

    id_opcion     : json["id_opcion"],
    id_pregunta   : json["id_pregunta"],
    valor         : json['valor'],
    label         : json['label'],
    orden         : json['orden'],
    estado        : json['estado'],
    updated_at    : json['updated_at']       

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toJson(){

    return {

      'id_opcion'     : id_opcion,
      'id_pregunta'   : id_pregunta,
      'valor'         : valor,
      'label'         : label,
      'orden'         : orden,
      'estado'        : estado,
      'updated_at'    : updated_at


    };


  }


}