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


  int     idOpcion;
  String  idPreguntaGrupoOpcion;
  int     idPregunta;
  String  valor;
  String  label;
  int     orden;
  String  estado;
  String  createdAt;  
  String  updated_at;
  bool    selected;
  String requiereDescripcion;
  
   
    OpcionesModel({

      this.idOpcion,this.idPreguntaGrupoOpcion,this.idPregunta,this.valor,this.label,this.orden,this.estado,this.createdAt,
      this.updated_at,this.selected,this.requiereDescripcion

    });


     // El from json es para mostrare los datos de la base de datos local

  factory OpcionesModel.fromMap(Map<String, dynamic> json) => OpcionesModel(

    idOpcion                : json["idOpcion"],
    idPreguntaGrupoOpcion   : json["idPreguntaGrupoOpcion"]  ,
    idPregunta              : json["idPregunta"],
    valor                   : json['valor'],
    label                   : json['label'],
    orden                   : json['orden'],
    estado                  : json['estado'],
    createdAt               : json['createdAt'] ,
    updated_at              : json['updatedAt'],
    selected                : false,
    requiereDescripcion     : json['requiereDescripcion']                   

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
      
      'id_opcion'             : idOpcion,
      'idPreguntaGrupoOpcion' : idPreguntaGrupoOpcion,
      'idPregunta'            : idPregunta,
      'valor'                 : valor,
      'label'                 : label,
      'orden'                 : orden,
      'estado'                : estado,
      'createdAt'             : createdAt,
      'updated_at'            : updated_at,
      'requiereDescripcion'   : requiereDescripcion

    };


  }


}