import 'dart:convert';

DepartamentoModel departamentoFromJson(String str){

  final jsonData = json.decode(str);
  return DepartamentoModel.fromMap(jsonData);

}

String departamentoToJson( DepartamentoModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}


class DepartamentoModel {

  
  int     idDepartamento;
  String  codigoDepartamento;
  String  descripcion;
  String  estado;
   
    DepartamentoModel({
      this.idDepartamento,this.codigoDepartamento,this.descripcion,this.estado
    });


     // El from json es para mostrare los datos de la base de datos local

  factory DepartamentoModel.fromMap(Map<String, dynamic> json) => DepartamentoModel(

    idDepartamento          : json["id"],
    codigoDepartamento      : json["codigoDepartamento"],
    descripcion             : json["descripcion"],
    estado                  : json["estado"]         
  );


  //  El toJson es para insertar los datos a la base de dato local

  Map<String,dynamic> toMap(){

    return {
      'idDepartamento'      : idDepartamento,
      'codigoDepartamento'  : codigoDepartamento,
      'descripcion'         : descripcion,
      'estado'              : estado      
    };


  }


}