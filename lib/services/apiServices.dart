import 'package:dio/dio.dart';


class ApiServices {

  final base_url = "https://test.regionsanmartin.gob.pe:6443/gsencuesta/api/v1/";

  var dio = Dio();
  /* Funcion get */

  getProyectos()async{

    Response response = await dio.get(base_url + "/proyecto");

    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');
      //print(response.data);

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

  getEncuestasxProyecto(String idProyecto)async{

    Response response = await dio.get(base_url + "encuesta/byProyecto/$idProyecto");

    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');
      //print(response.data);

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

  getPreguntasxEncuesta(String idEncuesta)async{

    Response response = await dio.get(base_url + "encuesta/$idEncuesta");
    if(response.statusCode == 200){

      print('Respuesta de servidor exitosa!');
      //print(response.data);

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