import 'dart:convert';

List<OpcionesModel> opcionesFromJson(String str) =>
    List<OpcionesModel>.from(json.decode(str).map((x) => OpcionesModel.fromJson(x)));

    String opcionesToJson(List<OpcionesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class OpcionesModel {

  int     idPreguntaGrupoOpcion;
  int     idGrupoOpcion;
  int     id_opcion;
  int     id_pregunta;
  String  valor;
  String  label;
  int     orden;
  bool    estado;
  String  createdAt;  
  String  updated_at;
  
   
    OpcionesModel({

      this.idPreguntaGrupoOpcion,this.idGrupoOpcion,this.id_opcion,this.id_pregunta,this.valor,this.label,this.orden,this.estado,this.createdAt,
      this.updated_at

    });


     // El from json es para mostrare los datos de la base de datos local

  factory OpcionesModel.fromJson(Map<String, dynamic> json) => OpcionesModel(

    idPreguntaGrupoOpcion   : json["idPreguntaGrupoOpcion"],
    idGrupoOpcion           : json["idGrupoOpcion"],
    id_opcion               : json["idOpcion"],
    id_pregunta             : json["idPregunta"],
    valor                   : json['valor'],
    label                   : json['label'],
    orden                   : json['orden'],
    estado                  : json['estado'],
    createdAt               : json['createdAt'] ,
    updated_at              : json['updatedAt']       

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toJson(){

    return {
      
      'idPreguntaGrupoOpcion' : idPreguntaGrupoOpcion,
      'idGruoOpcion'          : idGrupoOpcion,
      'id_opcion'             : id_opcion,
      'id_pregunta'           : id_pregunta,
      'valor'                 : valor,
      'label'                 : label,
      'orden'                 : orden,
      'estado'                : estado,
      'createdAt'             : createdAt,
      'updated_at'            : updated_at


    };


  }


}