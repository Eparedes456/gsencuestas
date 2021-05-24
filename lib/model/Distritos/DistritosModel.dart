import 'dart:convert';

DistritoModel distritoFromJson(String str){

  final jsonData = json.decode(str);
  return DistritoModel.fromMap(jsonData);

}

String distritoToJson( DistritoModel data ){
  final dyn = data.toMap();
  return json.encode(dyn);
}


class DistritoModel {
  int idDistrito;
  String codigoDepartamento;
  String codigoProvincia;
  String codigoDistrito;
  String descripcion;
  String estado;
   
    DistritoModel({
      this.idDistrito,this.codigoDepartamento,this.codigoProvincia,
      this.codigoDistrito,this.descripcion,this.estado
    });


     // El from json es para mostrare los datos de la base de datos local

  factory DistritoModel.fromMap(Map<String, dynamic> json) => DistritoModel(

    idDistrito            : json["id"],
    codigoDepartamento    : json["codigoDepartamento"],
    codigoProvincia       : json["codigoProvincia"],
    codigoDistrito        : json["codigoDistrito"],
    descripcion           : json["descripcion"],
    estado                : json["estado"]         
  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
      'idDistrito'          : idDistrito,
      'codigoDepartamento'  : codigoDepartamento,
      'codigoProvincia'     : codigoProvincia,
      'codigoDistrito'      : codigoDistrito,
      'descripcion'         : descripcion,
      'estado'              : estado      
    };
  }


}