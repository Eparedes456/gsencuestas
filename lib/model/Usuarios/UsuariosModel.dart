import 'dart:convert';





//List<UsuarioModel> usuarioFromJson(String str) => List<UsuarioModel>.from(json.decode(str).map((x) => UsuarioModel.fromJson(x)));

//String employeeToJson(List<UsuarioModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

UsuarioModel usuarioFromJson(String str){

  final jsonData = json.decode(str);
  return UsuarioModel.fromMap(jsonData);

}

String usuarioToJson( UsuarioModel data ){

  final dyn = data.toMap();

  return json.encode(dyn);

}



class UsuarioModel{

  
  int idUsuario;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String dni;
  String email; 
  String username;
  String password;
  String foto;
  String fechaAlta;
  String perfil;
  String estado;
  String createdAt;
  
  

  UsuarioModel(
      {
        this.idUsuario,this.nombre,this.apellidoPaterno,this.apellidoMaterno,this.dni,this.email,this.username,this.password,
        this.foto, this.fechaAlta,this.perfil,this.estado,this.createdAt
        
      }
  );

  factory UsuarioModel.fromMap(Map<String, dynamic> json) => UsuarioModel(

    
    idUsuario           : json['idUsuario'],
    nombre              : json['nombre'],
    apellidoPaterno     : json['apellidoPaterno'],
    apellidoMaterno     : json['apellidoMaterno'],
    dni                 : json['dni'],
    email               : json['email'],
    username            : json['username'],
    password            : json['password'],
    foto                : json['foto'],
    estado              : json['estado'],
    fechaAlta           : json['fechaAlta'],
    perfil              : json['perfil'],
    createdAt           : json['createdAt'],
    
  );

  Map<String,dynamic> toMap(){

    return{

      
      'idUsuario'           : idUsuario,
      'nombre'              : nombre,
      'apellidoPaterno'     : apellidoPaterno,
      'apellidoMaterno'     : apellidoMaterno,
      'dni'                 : dni,
      'email'               : email,
      'username'            : username,
      'password'            : password,
      'foto'                : foto,
      'estado'              : estado,
      'fechaAlta'           : fechaAlta,
      'perfil'              : perfil,
      'createdAt'           : createdAt,
         

    };


  }

}


