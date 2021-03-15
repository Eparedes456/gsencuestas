import 'dart:convert';

OpcionesModel opcionFromJson(String str){

  final jsonData = json.decode(str);
  return OpcionesModel.fromMap(jsonData);

}

String opcionToJson( OpcionesModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}


class OpcionesModel {


  int     id_opcion;
  int     idPreguntaGrupoOpcion;
  int     idPregunta;
  String  valor;
  String  label;
  int     orden;
  String    estado;
  String  createdAt;  
  String  updated_at;
  
   
    OpcionesModel({

      this.id_opcion,this.idPreguntaGrupoOpcion,this.idPregunta,this.valor,this.label,this.orden,this.estado,this.createdAt,
      this.updated_at

    });


     // El from json es para mostrare los datos de la base de datos local

  factory OpcionesModel.fromMap(Map<String, dynamic> json) => OpcionesModel(

    id_opcion               : json["idOpcion"],
    idPreguntaGrupoOpcion   : json["idPreguntaGrupoOpcion"],
    idPregunta              : json["idPregunta"],
    valor                   : json['valor'],
    label                   : json['label'],
    orden                   : json['orden'],
    estado                  : json['estado'],
    createdAt               : json['createdAt'] ,
    updated_at              : json['updatedAt']       

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
      
      'id_opcion'             : id_opcion,
      'idPreguntaGrupoOpcion' : idPreguntaGrupoOpcion,
      'idPregunta'            : idPregunta,
      'valor'                 : valor,
      'label'                 : label,
      'orden'                 : orden,
      'estado'                : estado,
      'createdAt'             : createdAt,
      'updated_at'            : updated_at


    };


  }


}