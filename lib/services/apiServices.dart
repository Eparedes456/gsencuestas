import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class ApiServices {

  final base_url = "https://test.regionsanmartin.gob.pe:6443/gsencuesta/api/v1/";

  var dio = Dio();
  /* Funcion get */

  getProyectos()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');

    //var response = await dio.get(base_url + "/proyecto");
    var response = await http.get(
      base_url + "proyecto",
      headers: {

        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'

      }
    );

    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');
      print(response);
      var decodedData = json.decode( utf8.decode(response.bodyBytes) );

      return decodedData;

    }else if(response.statusCode == 500){

      print('Error de servidor,consulte con el encargado del sistema');
      print(response.body);

      return 1;

    }else if(response.statusCode == 401){

      print('Estimado usuario su sesion a expirado.');
      return 2;

    }else{

      print('la ruta que usted especifica no existe');
      return 3;

    }


  }

  getEncuestasxProyecto(String idProyecto)async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');

   
    var response = await http.get(
      base_url + "encuesta/byProyecto/$idProyecto",
      headers: {

        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'

      }
    );

    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');
      //print(response.data);
      var decodedData = json.decode( utf8.decode(response.bodyBytes));

      return decodedData;

    }else if(response.statusCode == 500){

      print('Error de servidor,consulte con el encargado del sistema');

      return 1;

    }else if(response.statusCode == 401){

      print('Estimado usuario su sesion a expirado.');
      return 2;

    }else{

      print('la ruta que usted especifica no existe');
      return 3;

    }
    
  }

  getPreguntasxEncuesta(String idEncuesta)async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');


    var response = await http.get(
      base_url + "encuesta/$idEncuesta",
      headers: {

        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'

      }
    );
    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');
      //print(response.data);
      var decodedData = json.decode( utf8.decode( response.bodyBytes) );

      return decodedData;
      

    }else if(response.statusCode == 500){

      print('Error de servidor,consulte con el encargado del sistema');

      return 1;

    }else if(response.statusCode == 401){

      print('Estimado usuario su sesion a expirado.');
      return 2;

    }else{

      print('la ruta que usted especifica no existe');
      return 3;

    }

  }

  /* onsultar a la tabla parametros para descargar la tabla usuarios  */

  consultarParametros()async{

    Response response = await dio.get(base_url + "parametros");
    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');
      print(response.data);

      return response.data;

    }else if(response.statusCode == 500){

      print('Error de servidor,consulte con el encargado del sistema');

      return 1;

    }else if(response.statusCode == 401){

      print('Estimado usuario su sesion a expirado.');
      return 2;

    }else{

      print('la ruta que usted especifica no existe');
      return 3;

    }

  }


  getAllUsers()async{

    Response response = await dio.get(base_url + "usuario");
    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');
      print(response.data);

      return response.data;

    }else if(response.statusCode == 500){

      print('Error de servidor,consulte con el encargado del sistema');

      return 1;

    }else if(response.statusCode == 401){

      print('Estimado usuario su sesion a expirado.');
      return 2;

    }else{

      print('la ruta que usted especifica no existe');
      return 3;

    }


  }

  ingresar(String username, String password)async{
    var uri = "https://test.regionsanmartin.gob.pe:6443/gsencuesta/api/auth";

    Map dataSend = {
        "password"  : password,
        "username"  : username
    };
    String body = json.encode(dataSend);

    var response = await http.post(

      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body:body,

    );

    if(response.statusCode == 200){

      print(response.body);
      final decodedData = json.decode(response.body);

      return decodedData;

    }else if(response.statusCode == 500){

      print('Error de servidor');

      return 1;

    }else if(response.statusCode == 401){

      print('Error de token , sesion expirada');
      return 0;

    }else{

      final decodedData = json.decode(response.body);

      return decodedData;

    }


  }

  /* Servicio a buscar a un encuestado por número de DNI */

  getAllEncuestado(String nrDocumento)async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');

    var response = await http.get(
      base_url + "encuestado",
      headers: {

        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'

      }
    );
    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');
      //print(response.data);
      var decodedData = json.decode(response.body);

      return decodedData;
      

    }else if(response.statusCode == 500){

      print('Error de servidor,consulte con el encargado del sistema');

      return 1;

    }else if(response.statusCode == 401){

      print('Estimado usuario su sesion a expirado.');
      return 2;

    }else{

      print('la ruta que usted especifica no existe');
      return 3;

    }


  }


  insertFicha(dynamic data)async{

    SharedPreferences preferencia = await SharedPreferences.getInstance();

    var token = preferencia.getString('token');

    var response = await http.post(

      base_url + 'ficha',
      headers: {

        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'

      },
    );

    if(response.statusCode == 200){


      var decodedData = json.decode( utf8.decode(response.bodyBytes));

      return decodedData;


    }else if(response.statusCode == 401){

      return 1;

    }else if( response.statusCode == 500){

      return 2;

    }else{

      return 3;

    }




  }

  /* Buscar al encuestado por nombre */

  findEncuestado(String data)async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');

    var response = await http.get(
      base_url + "encuestado?query=$data",
      headers: {

        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'

      }
    );

    if(response.statusCode == 200){

      var decodedData = json.decode(response.body);

      return decodedData;

    }else if(response.statusCode == 401){

      return 1;
      
    }else if(response.statusCode == 500){

      return 2;

    }else{

      return 3;

    }



  }



  /* Funcion Post */

  testPost()async{

    Response response = await dio.post(base_url,data: { "id" : 4 });

    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');

    }else if(response.statusCode == 500){

      print('Error de servidor,consulte con el encargado del sistema');

    }else if(response.statusCode == 401){

      print('Estimado usuario su sesion a expirado.');

    }else{

      print('la ruta que usted especifica no existe');

    }


  }



}