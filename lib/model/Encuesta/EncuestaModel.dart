import 'dart:convert';





List<EncuestaModel> employeeFromJson(String str) => List<EncuestaModel>.from(json.decode(str).map((x) => EncuestaModel.fromJson(x)));

String employeeToJson(List<EncuestaModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));



class EncuestaModel{

  String createdAt;
  String updatedAt;
  int idEncuesta;
  String titulo;
  String descripcion;
  String url_guia;
  bool expira;
  String fechaInicio; 
  String fechaFin;
  String logo;  
  bool dinamico;
  String esquema;
  bool estado;
  

  EncuestaModel(
      {
        this.createdAt,this.updatedAt,this.idEncuesta,this.titulo,this.descripcion,this.url_guia,this.expira,this.fechaInicio,this.fechaFin,this.logo,
        this.dinamico,this.esquema,this.estado,
        
      }
  );

  factory EncuestaModel.fromJson(Map<String, dynamic> json) => EncuestaModel(

    createdAt           : json['createdAt'],
    updatedAt           : json['updatedAt'],
    idEncuesta          : json['idEncuesta'],
    titulo              : json['titulo'],
    descripcion         : json['descripcion'],
    url_guia            : json['url_guia'],
    expira              : json['expira'],
    fechaInicio         : json['fechaInicio'],
    fechaFin            : json['fechaFin'],
    logo                : json['logo'],
    dinamico            : json['dinamico'],
    esquema             : json['esquema'],
    estado              : json['estado'],
  );

  Map<String,dynamic> toJson(){

    return{

      'createdAt'           : createdAt,
      'updateAt'            : updatedAt,
      'idEncuesta'          : idEncuesta,
      'titulo'              : titulo,
      'descripcion'         : descripcion,
      'url_guia'            : url_guia,
      'expira'              : expira,
      'fechaInicio'         : fechaInicio,
      'fechaFin'            : fechaFin,
      'logo'                : logo,
      'dinamico'            : dinamico,
      'esquema'             : esquema,
      'estado'              : estado   

    };


  }

    







}


