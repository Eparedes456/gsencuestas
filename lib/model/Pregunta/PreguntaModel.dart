import 'dart:convert';

PreguntaModel proyectoFromJson(String str){

  final jsonData = json.decode(str);
  return PreguntaModel.fromMap(jsonData);

}

String proyectoToJson( PreguntaModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}

class PreguntaModel {

  
  int     id_pregunta;
  int     id_bloque;
  int     idEncuesta;
  String  enunciado;
  String  tipo_pregunta;
  String  apariencia;
  String     requerido;
  String  requerido_msj;
  String     readonly;
  String  defecto;
  String  calculation;
  String  restriccion;
  String  restriccion_msj;
  String  relevant;
  String  choice_filter;
  String  bind_name;
  
  String  bind_type;
  String  bind_field_length;
  String  bind_field_placeholder;
  int     orden;
  String  estado;
  String  updated_at;
  String created_at;
  int    index1;
  String bloqueDescripcion;
   
    PreguntaModel({

      this.id_pregunta,this.id_bloque,this.idEncuesta,this.enunciado,this.tipo_pregunta,this.apariencia,this.requerido,this.requerido_msj,this.readonly,this.defecto,
      this.calculation,this.restriccion,this.restriccion_msj,this.relevant,this.choice_filter,this.bind_name,this.bind_type,this.bind_field_length,this.bind_field_placeholder,
      this.orden,this.estado,this.updated_at,this.created_at,this.index1, this.bloqueDescripcion

    });


     // El from json es para mostrare los datos de la base de datos local

  factory PreguntaModel.fromMap(Map<String, dynamic> json) => PreguntaModel(


    id_pregunta             : json["idPregunta"],
    id_bloque               : json['id_bloque'],
    idEncuesta             : json['idEncuesta'],
    enunciado               : json['enunciado'],
    tipo_pregunta           : json['tipo_pregunta'],
    apariencia              : json['apariencia'],
    requerido               : json['requerido'],
    readonly                : json['readonly'],
    defecto                 : json['defecto'],
    calculation             : json['calculation'],
    restriccion             : json['restriccion'],
    restriccion_msj         : json['restriccion_msj'], 
    relevant                : json['relevant'],
    choice_filter           : json['choice_filter'],
    bind_name               : json['bind_name'],
    bind_type               : json['bind_type'],
    bind_field_length       : json['bind_field_length'],
    bind_field_placeholder  : json['bind_field_placeholder'],
    orden                   : json['orden'],
    estado                  : json['estado'],
    updated_at              : json['updatedAt'],
    created_at              : json['createdAt'],         
    index1                  : json['index1'],
    bloqueDescripcion       : json['bloqueDescripcion']  
  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
    
      'idPregunta'             : id_pregunta,
      'id_bloque'               : id_bloque,
      'idEncuesta'             : idEncuesta,
      'enunciado'               : enunciado,
      'tipo_pregunta'           : tipo_pregunta,
      'apariencia'              : apariencia,
      'requerido'               : requerido,
      'readonly'                : readonly,
      'defecto'                 : defecto,
      'calculation'             : calculation,
      'restriccion'             : restriccion,
      'restriccion_msj'         : restriccion_msj, 
      'relevant'                : relevant,
      'choice_filter'           : choice_filter,
      'bind_name'               : bind_name,
      'bind_type'               : bind_type,
      'bind_field_length'       : bind_field_length,
      'bind_field_placeholder'  : bind_field_placeholder,
      'orden'                   : orden,
      'estado'                  : estado,       
      'updated_at'              : updated_at,
      'created_at'              : created_at,
      'index1'                  : index1,
      'bloqueDescripcion'       : bloqueDescripcion
    };


  }


}