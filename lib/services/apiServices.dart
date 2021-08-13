import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  //final base_url = "https://test.regionsanmartin.gob.pe:6443/gsencuesta/api/v1/";
  final base_url_dev = "https://dev.regionsanmartin.gob.pe/gsencuesta/api/v1/";
  //final base_url_dev = "https://test.regionsanmartin.gob.pe:6443/gsencuesta/api/v1/";

  var dio = Dio();
  /* Funcion get */

  getParametroUsuario() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "parametro/actualizacion_usuario");
    var response = await http
        .get( url /*base_url_dev + "parametro/actualizacion_usuario"*/, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
      print(response);
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');
      return 1;
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
      return 2;
    }
  }

  getParametroMaestro() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var idInstitucion = preferences.getString('idInstitucion');
    var url =Uri.parse(base_url_dev + "parametro/byInstitucion/$idInstitucion");

    var response = await http
        .get(url /*base_url_dev + "parametro/byInstitucion/$idInstitucion"*/, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
      print(response);
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');
      return 1;
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
      return 2;
    }
  }

  getProyectos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "proyecto");
    //var response = await dio.get(base_url + "/proyecto");
    var response = await http.get( url /*base_url_dev + "proyecto"*/, headers: {
      'Content-Type': 'application/json',
      //'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
      print(response);
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');
      print(response.body);

      return 1;
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
      return 2;
    } else {
      print('la ruta que usted especifica no existe');
      return 3;
    }
  }

  getEncuestasxProyecto(String idProyecto) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "encuesta/byProyecto/$idProyecto");
    var response = await http
        .get(url, headers: {
      'Content-Type': 'application/json',
      //'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
      //print(response.data);
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');

      return 1;
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
      return 2;
    } else {
      print('la ruta que usted especifica no existe');
      return 3;
    }
  }

  getPreguntasxEncuesta(String idEncuesta) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "encuesta/$idEncuesta");
    var response =
        await http.get(url, headers: {
      'Content-Type': 'application/json',
      //'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
      //print(response.data);
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');

      return 1;
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
      return 2;
    } else {
      print('la ruta que usted especifica no existe');
      return 3;
    }
  }

  /* onsultar a la tabla parametros para descargar la tabla usuarios  */

  consultarParametros() async {
    Response response = await dio.get(base_url_dev + "parametros");
    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
      print(response.data);

      return response.data;
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');

      return 1;
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
      return 2;
    } else {
      print('la ruta que usted especifica no existe');
      return 3;
    }
  }

  getAllUsers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "usuario");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      //'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    
    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
      print(response);
      var decodedData = json.decode(utf8.decode(response.bodyBytes));
      return decodedData;
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');

      return 1;
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
      return 2;
    } else {
      print('la ruta que usted especifica no existe');
      return 3;
    }
  }

  ingresar(String username, String password) async {
    var uri = "https://dev.regionsanmartin.gob.pe/gsencuesta/api/auth";
    //var uri = "https://test.regionsanmartin.gob.pe:6443/gsencuesta/api/auth";
    Map dataSend = {"password": password, "username": username};
    String body = json.encode(dataSend);
    var url =Uri.parse(uri);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print(response.body);
      final decodedData = json.decode(response.body);

      return decodedData;
    } else if (response.statusCode == 500) {
      print('Error de servidor');

      return 1;
    } else if (response.statusCode == 401) {
      print('Error de token , sesion expirada');
      return 0;
    } else {
      final decodedData = json.decode(response.body);

      return decodedData;
    }
  }

  /* Servicio a buscar a un encuestado por número de DNI */

  getAllEncuestado() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "encuestado");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      //'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
      //print(response.data);
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');

      return 1;
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
      return 2;
    } else {
      print('la ruta que usted especifica no existe');
      return 3;
    }
  }

  getAllEncuestado2() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "encuestado/lista_detalle_encuestado");
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      //'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
      //print(response.data);
      var decodedData = json.decode(utf8.decode(response.bodyBytes));
      //print(decodedData);
      return decodedData["items"];
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');

      return 1;
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
      return 2;
    } else {
      print('la ruta que usted especifica no existe');
      return 3;
    }
  }

  insertFicha(dynamic data) async {
    SharedPreferences preferencia = await SharedPreferences.getInstance();

    var token = preferencia.getString('token');
    var url =Uri.parse(base_url_dev + "ficha");
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }
  }

  /* Buscar al encuestado por nombre */

  findEncuestado(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "encuestado?query=$data");
    var response =
        await http.get(url, headers: {
      'Content-Type': 'application/json',
      //'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }
  }

  /* Enviar las fichas realizadas */

  sendFichaToServer(Map data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');

    var sendData = json.encode(data);
    var url =Uri.parse(base_url_dev + "ficha/create_all");
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          //'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: sendData);

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }
  }

  /*Ubigeo servicios api */

  getDepartamentos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "ubigeo/departamento");
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));
      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }
  }

  getProvincias(String codigoDepartamento) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "ubigeo/provincia/$codigoDepartamento");
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));
      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }
  }

  getDistritos(String codProvincia, String codigoDepartamento) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "ubigeo/distrito?codigoDepartamento=$codigoDepartamento&codigoProvincia=$codProvincia");
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));
      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }
  }
  /* */

  saveUser(Map data) async {
    var sendData = json.encode(data);
    var url =Uri.parse(base_url_dev + "usuario");
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          //'Accept': 'application/json',
        },
        body: sendData);

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      return decodedData;
    } else if (response.statusCode == 500) {
      return 3;
    }
  }

  /* Parcelas */

  saveParcela(Map data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "parcela");
    var sendData = json.encode(data);
    print(sendData);

    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          //'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: sendData);

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }
  }

  buscarReniec(String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "reniec/$data");
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }
  }

  getAllParcelas() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "parcela");
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }
  }

  getVersionsApp()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url =Uri.parse(base_url_dev + "versiones");
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var decodedData = json.decode(utf8.decode(response.bodyBytes));

      return decodedData;
    } else if (response.statusCode == 401) {
      return 1;
    } else if (response.statusCode == 500) {
      return 2;
    } else {
      return 3;
    }


  }



  /* Funcion Post */

  testPost() async {
    Response response = await dio.post(base_url_dev, data: {"id": 4});

    if (response.statusCode == 200) {
      print('Respuesta de servidor exitosa!');
    } else if (response.statusCode == 500) {
      print('Error de servidor,consulte con el encargado del sistema');
    } else if (response.statusCode == 401) {
      print('Estimado usuario su sesion a expirado.');
    } else {
      print('la ruta que usted especifica no existe');
    }
  }
}
