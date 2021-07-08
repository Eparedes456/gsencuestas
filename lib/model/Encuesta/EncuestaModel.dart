import 'dart:convert';

EncuestaModel proyectoFromJson(String str) {
  final jsonData = json.decode(str);
  return EncuestaModel.fromMap(jsonData);
}

String proyectoToJson(EncuestaModel data) {
  final dyn = data.toMap();

  return json.encode(dyn);
}

class EncuestaModel {
  int idEncuesta;
  String idProyecto;
  String titulo;
  String descripcion;
  String url_guia;
  String expira;
  String fechaInicio;
  String fechaFin;
  String logo;
  String dinamico;
  String esquema;
  String estado;
  String createdAt;
  String updatedAt;
  String idFicha = "";
  String publicado;
  String sourceMultimedia;
  String requeridoObservacion;
  String requeridoMultimedia;
  String esRetomado;
  String encuestadoIngresoManual;
  String tipoVista;
  

  EncuestaModel({
    this.idEncuesta,
      this.idProyecto,
      this.titulo,
      this.descripcion,
      this.url_guia,
      this.expira,
      this.fechaInicio,
      this.fechaFin,
      this.logo,
      this.dinamico,
      this.esquema,
      this.estado,
      this.createdAt,
      this.updatedAt,
      this.idFicha,
      this.publicado,
      this.sourceMultimedia,
      this.requeridoObservacion,
      this.requeridoMultimedia,
      this.esRetomado,
      this.encuestadoIngresoManual,
      this.tipoVista
  });

  factory EncuestaModel.fromMap(Map<String, dynamic> json) => EncuestaModel(
      idEncuesta: json['idEncuesta'],
      idProyecto: json["idProyecto"],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      url_guia: json['url_guia'],
      expira: json['expira'],
      fechaInicio: json['fechaInicio'],
      fechaFin: json['fechaFin'],
      logo: json['logo'],
      dinamico: json['dinamico'],
      esquema: json['esquema'],
      estado: json['estado'],
      publicado: json['publicado'].toString(),
      sourceMultimedia: json['sourceMultimedia'],
      requeridoObservacion: json['requeridoObservacion'].toString(),
      requeridoMultimedia: json['requeridoMultimedia'].toString(),
      esRetomado: json['esRetomado'].toString(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      encuestadoIngresoManual: json["encuestadoIngresoManual"],
      tipoVista: json["tipoVista"]
  );
      

  Map<String, dynamic> toMap() {
    return {
      'idEncuesta': idEncuesta,
      'idProyecto': idProyecto,
      'titulo': titulo,
      'descripcion': descripcion,
      'url_guia': url_guia,
      'expira': expira,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
      'logo': logo,
      'dinamico': dinamico,
      'esquema': esquema,
      'estado': estado,
      'publicado': publicado,
      'sourceMultimedia': sourceMultimedia,
      'requeridoObservacion': requeridoObservacion,
      'requeridoMultimedia': requeridoMultimedia,
      'esRetomado': esRetomado,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'encuestadoIngresoManual': encuestadoIngresoManual,
      'tipoVista':  tipoVista
    };
  }
}
