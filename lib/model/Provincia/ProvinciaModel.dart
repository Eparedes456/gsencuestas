import 'dart:convert';

ProvinciaModel provinciaFromJson(String str){

  final jsonData = json.decode(str);
  return ProvinciaModel.fromMap(jsonData);

}

String provinciaToJson( ProvinciaModel data ){
  final dyn = data.toMap();
  return json.encode(dyn);
}


class ProvinciaModel {
  int idProvincia;
  String codigoDepartamento;
  String codigoProvincia;
  String descripcion;
  String estado; 
   
    ProvinciaModel({
      this.idProvincia,this.codigoDepartamento,this.codigoProvincia,this.descripcion,this.estado
    });


     // El from json es para mostrare los datos de la base de datos local

  factory ProvinciaModel.fromMap(Map<String, dynamic> json) => ProvinciaModel(

    idProvincia             : json["id"],
    codigoDepartamento      : json["codigoDepartamento"],
    codigoProvincia         : json["codigoProvincia"],
    descripcion             : json["descripcion"],
    estado                  : json["estado"]         
  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
      'idProvincia'         : idProvincia,
      'codigoDepartamento'  : codigoDepartamento,
      'codigoProvincia'     : codigoProvincia,
      'descripcion'         : descripcion,
      'estado'              : estado      
    };
  }


}