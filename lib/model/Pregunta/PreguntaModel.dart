import 'dart:convert';

List<PreguntaModel> preguntaFromJson(String str) =>
    List<PreguntaModel>.from(json.decode(str).map((x) => PreguntaModel.fromJson(x)));

    String preguntaToJson(List<PreguntaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class PreguntaModel {

  
  int     id_pregunta;
  int     id_bloque;
  int     id_encuesta;
  String  enunciado;
  String  tipo_pregunta;
  String  apariencia;
  int     requerido;
  String  requerido_msj;
  int     readonly;
  String  defecto;
  String  calculation;
  String  constraint;
  String  constraint_msj;
  String  relevant;
  String  choice_filter;
  String  bind_name;
  
  String  bind_type;
  String  bind_field_length;
  String  bind_field_placeholder;
  int     orden;
  int     estado;
  String  updated_at;
   
    PreguntaModel({

      this.id_pregunta,this.id_bloque,this.id_encuesta,this.enunciado,this.tipo_pregunta,this.apariencia,this.requerido,this.requerido_msj,this.readonly,this.defecto,
      this.calculation,this.constraint,this.constraint_msj,this.relevant,this.choice_filter,this.bind_name,this.bind_type,this.bind_field_length,this.bind_field_placeholder,
      this.orden,this.estado,this.updated_at

    });


     // El from json es para mostrare los datos de la base de datos local

  factory PreguntaModel.fromJson(Map<String, dynamic> json) => PreguntaModel(


    id_pregunta             : json["id_encuesta"],
    id_bloque               : json['id_bloque'],
    id_encuesta             : json['id_proyecto'],
    enunciado               : json['enunciado'],
    tipo_pregunta           : json['tipo_pregunta'],
    apariencia              : json['apariencia'],
    requerido               : json['requerido'],
    readonly                : json['readonly'],
    defecto                 : json['defecto'],
    calculation             : json['calculation'],
    constraint              : json['constraint'],
    constraint_msj          : json['constraint_msj'], 
    relevant                : json['relevant'],
    choice_filter           : json['choice_filter'],
    bind_name               : json['bind_name'],
    bind_type               : json['bind_type'],
    bind_field_length       : json['bind_field_length'],
    bind_field_placeholder  : json['bind_field_placeholder'],
    orden                   : json['orden'],
    estado                  : json['estado'],
    updated_at              : json['updated_at']        

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toJson(){

    return {
    
      'id_pregunta'             : id_pregunta,
      'id_bloque'               : id_bloque,
      'id_encuesta'             : id_encuesta,
      'enunciado'               : enunciado,
      'tipo_pregunta'           : tipo_pregunta,
      'apariencia'              : apariencia,
      'requerido'               : requerido,
      'readonly'                : readonly,
      'defecto'                 : defecto,
      'calculation'             : calculation,
      'constraint'              : constraint,
      'constraint_msj'          : constraint_msj, 
      'relevant'                : relevant,
      'choice_filter'           : choice_filter,
      'bind_name'               : bind_name,
      'bind_type'               : bind_type,
      'bind_field_length'       : bind_field_length,
      'bind_field_placeholder'  : bind_field_placeholder,
      'orden'                   : orden,
      'estado'                  : estado,       
      'updated_at'              : updated_at

    };


  }


}