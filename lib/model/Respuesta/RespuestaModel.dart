import 'dart:convert';

RespuestaModel respuestaFromJson(String str){

  final jsonData = json.decode(str);
  return RespuestaModel.fromMap(jsonData);

}

String respuestaToJson( RespuestaModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}


class RespuestaModel {

  
  int     idRespuesta;
  int     idPregunta;
  int     idFicha;
  String  idsOpcion;
  String  valor;
  String  estado;
  String  tipoPregunta;
   
    RespuestaModel({

      this.idRespuesta,this.idPregunta ,this.idFicha ,this.idsOpcion ,this.valor,this.estado,this.tipoPregunta

    });


     // El from json es para mostrare los datos de la base de datos local

  factory RespuestaModel.fromMap(Map<String, dynamic> json) => RespuestaModel(


    idRespuesta             : json["idRespuesta"],
    idPregunta              : json["idPregunta"],
    idFicha                 : json['idFicha'],
    idsOpcion               : json['idsOpcion'].toString(),
    valor                   : json['valor'],
    estado                  : json['estado'].toString(),
    tipoPregunta            : json['tipoPregunta'].toString() 

  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
    
      'idRespuesta'             : idRespuesta,
      'idPregunta'              : idPregunta,
      'idFicha'                 : idFicha,
      'idsOpcion'               : idsOpcion,
      'valor'                   : valor,
      'estado'                  : estado,
      'tipoPregunta'            : tipoPregunta

    };


  }


}