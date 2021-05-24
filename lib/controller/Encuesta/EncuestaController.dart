import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Departamento/DepartamentoModel.dart';
import 'package:gsencuesta/model/Distritos/DistritosModel.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/MisEncuestas/MisEncuestasModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/model/Provincia/ProvinciaModel.dart';
import 'package:gsencuesta/pages/MisEncuestas/DetailMiEncuestaPage.dart';
import 'package:gsencuesta/pages/Retomar/RetomarEncuestaPage.dart';
import 'package:gsencuesta/pages/quiz/QuizPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';


class EncuestaController extends GetxController{


  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    var data = Get.arguments;
    _nombreProyecto = data[1];
    print(data[0]);

    loadData(data[0]);


  }

  ApiServices apiConexion= new ApiServices();

  String _imagePortada = "";
  String get imagePortada => _imagePortada;

  String _titulo = "";
  String get titulo => _titulo;
  
  String _nombreProyecto = "";
  String get nombreProyecto => _nombreProyecto;

  String _descripcion = "";
  String get descripcion =>_descripcion;

  String _fechaInicio = "";
  String get fechaInicio => _fechaInicio;

  String _fechaFin = "";
  String get fechaFin => _fechaFin;

  String _totalPreguntas = "";
  String get totalPreguntas => _totalPreguntas;

  String _idEncuesta = "";
  String get idEncuesta => _idEncuesta;

  String _nroTotalPreguntas = "";
  String get nroTotalPreguntas => _nroTotalPreguntas;
  
  Uint8List _photoBase64;
  Uint8List get photoBase64 => _photoBase64;
  
  List<PreguntaModel> _listPregunta = [];
  List<PreguntaModel> get listPregunta => _listPregunta;

  List<FichasModel> _listFichas = [];
  List<FichasModel> get listFichas => _listFichas;

  List<MisEncuestasModel> _listEncuesta = [];
  List<MisEncuestasModel> get listEncuesta => _listEncuesta;

  TextEditingController insertEncuestadoController = new TextEditingController();

  String idEncuestado;

  String _nombreEncuesta = "";
  String get nombreEncuesta => _nombreEncuesta;
  String _fechaEncuestaInicio = "";
  String get fechaEncuestaInicio => _fechaEncuestaInicio;

  bool _encuestasPendientes = false;
  bool get encuestasPendientes => _encuestasPendientes;

  


  loadData(EncuestaModel encuesta)async{

    _listFichas = [];
    _imagePortada   = encuesta.logo;
    _descripcion    = encuesta.descripcion;
    _titulo         = encuesta.titulo;
    _fechaFin       = encuesta.fechaFin;
    _fechaInicio    = encuesta.fechaInicio;
    _idEncuesta     = encuesta.idEncuesta.toString();

    //loadingModal();
  
    _listFichas = await DBProvider.db.fichasPendientes("P");

    print(_listFichas.length);

    if(_listFichas.length > 0){

      for( var element in _listFichas){

        var listdata = await DBProvider.db.getOnesEncuesta(element.idEncuesta.toString());
        var idEncuestado3 = element.idEncuestado.toString();
        List<EncuestadoModel> _listEncuestado = await DBProvider.db.getOneEncuestado(idEncuestado3);
        var nombreEncuestado = _listEncuestado[0].nombre.toString() + " " + _listEncuestado[0].apellidoPaterno.toString();
        listdata.forEach((item){

          _listEncuesta.add(
            MisEncuestasModel(
              idEncuesta        : item["idEncuesta"].toString(),
              idProyecto        : item["idProyecto"].toString(),
              nombreEncuestado  : nombreEncuestado,
              nombreEncuesta    : item["titulo"],
              fechaInicio       : item["fechaInicio"],
              idFicha           : element.idFicha.toString() 

            )
          );

        });


      }

      _encuestasPendientes = true;
      print(_listEncuesta.length);
    }else{

      _encuestasPendientes = false;

    }
    
    await getPreguntas(encuesta.idEncuesta.toString());

    

    update();

  }

  getPreguntas(String idEncuesta)async{

    ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

    if(conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

      var resultado = await apiConexion.getPreguntasxEncuesta(idEncuesta);  
      var  preguntas = resultado["pregunta"];

      preguntas.forEach((item){

        _listPregunta.add(

          PreguntaModel(

            id_pregunta       : item["idPregunta"],
            id_bloque         : item["id_bloque"],
            idEncuesta       : item["id_encuesta"],
            enunciado         : item["enunciado"],
            tipo_pregunta     : item["tipo_pregunta"],
            apariencia        : item["apariencia"],
            requerido         : item["requerido"].toString(),
            requerido_msj     : item["requerido_msj"],
            readonly          : item["readonly"].toString(),
            defecto           : item["defecto"],
            calculation       : item["calculation"],
            restriccion       : item["restriccion"],
            restriccion_msj   : item["restriccion_msj"],
            relevant          : item["relevant"],
            choice_filter     : item["choice_filter"], 
            bind_name         : item["bind_name"],
            bind_type         : item["bind_type"],
            bind_field_length : item["bind_field_length"],
            bind_field_placeholder  : item["bind_field_placeholder"],
            orden             : item["orden"],
            estado            : item["estado"].toString(),
            updated_at        : item["createdAt"],
            created_at        : item["updatedAt"]

          )

        );


      });

      

    }else{

      print("consulto bd local");

      _listPregunta = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
       
      print(_listPregunta.length);
      

    }

    

    //print(_listPregunta.length);
    

  }

  loadingModal(){

    Get.dialog(
      
      AlertDialog(

        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

            CircularProgressIndicator(),

            SizedBox(height: 12,),

            Text('Cargando....')


            
          ],
        ),

      )

    );


  }

  showModalSearch(){

    Get.dialog(

      AlertDialog(

        title: Text('Buscar encuestado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: insertEncuestadoController,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 13
                ),
                hintText: 'Ingrese el dni'
              ),
            ),
            SizedBox(height: 12,),

            FlatButton.icon(
              color: Color.fromRGBO(0, 102, 84, 1),
              onPressed: (){

                searchEncuestado();

              }, 
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              label: Text('Buscar',style: TextStyle(color: Colors.white),)
            )


          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),

      ),
      

    );


  }

  searchEncuestado()async{

    Get.back();

    loadMessage('Buscando...', true);

    if(insertEncuestadoController.text == ""){

      print('El campo es requerido para hacer la busqueda');
      Get.back();
      messageInfo('El campo es requerido para hacer la busqueda');


    }else{

      ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

      if(conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

        var response = await apiConexion.findEncuestado(insertEncuestadoController.text);
        if(response == 2){

          Get.back();

          messageInfo('Error 500, error de servidor comuniquese con el encargado del sistema');

        }else if( response != 2 && response != 1 && response != 3){

          print(response);
          
          if( response.length > 0 ){

            Get.back(); 
            showEncuestadoModal(response);

          }else{
          
          Get.back();
          messageInfo('El encuestado no se encuentra registrado');

          }
          

        }


      }else{

        print("Busco al encuestado en la bd local");

        var respuesta = await DBProvider.db.searchEncuestado(insertEncuestadoController.text);
        if(respuesta.length > 0){

          Get.back(); 
          showEncuestadoModal(respuesta);

        }else{
          
          Get.back();
          messageInfo('El encuestado no se encuentra registrado');

        }

      }

      

    }

  }

  showEncuestadoModal(dynamic data)async{

    print(data[0]["idEncuestado"]);
    var idEncuestado2   = data[0]["idEncuestado"].toString();
    var nombreCompleto  =  data[0]["nombre"] + " " + data[0]["apellidoPaterno"] + " " + data[0]["apellidoMaterno"];
    var foto            = data[0]["foto"];
    _photoBase64        = base64Decode(foto); 
    var idUbigeo        =  "220101,210203";  //data[0]["idUbigeo"];
    var dataUbi = idUbigeo.split(",");
  
    List<DepartamentoModel> showDepartamentos  =[];

    
    
    /*var codDepartamento = partes[0] + partes[1];
    var codProvincia = partes[2] + partes[3];
    var codDistritos = partes[4] + partes[5];*/
    print(dataUbi); 
    
    
    /*List<DepartamentoModel> dataDepartamento  = await DBProvider.db .getDepartamentos(codDepartamento.toString());
    List<ProvinciaModel> dataProvincia        = await DBProvider.db.getOneProvincia(codProvincia.toString(),codDepartamento.toString()); 
    List<ProvinciaModel> dataProvinciaa        = await DBProvider.db.getProvincia();
    List<DistritoModel> dataDistrito        = await DBProvider.db.getDistritos(codProvincia.toString(),codDepartamento.toString(),codDistritos.toString()); 
    print(dataDepartamento);
    print(dataProvinciaa);
    Get.dialog(

      AlertDialog(

        title: Text('Encuestado encontrado'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              //leading: Icon(Icons.people,size: 16,),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: MemoryImage(_photoBase64)
              ),
              //trailing: Icon(Icons.arrow_forward,size: 16,),
              title: Text('$nombreCompleto',style: TextStyle(fontSize: 14),),
              onTap: (){

                idEncuestado = idEncuestado2.toString();
                print(idEncuestado);

                confirmationModal(idEncuestado);
              },

            ),
            SizedBox(height: 8,),
            Text('Ambito  de intervención',style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Text('DEPARTAMENTO'),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Padding(
                  padding:  EdgeInsets.only(left: 8,right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(dataDepartamento[0].descripcion)),
                      Icon(Icons.unfold_more)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8,),
            Text('PROVINCIA'),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child:Center(
                child: Padding(
                  padding:  EdgeInsets.only(left: 8,right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(dataProvincia[0].descripcion)),
                      Icon(Icons.unfold_more)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8,),
            Text('DISTRITO'),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child:Center(
                child: Padding(
                  padding:  EdgeInsets.only(left: 8,right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(dataDistrito[0].descripcion)),
                      Icon(Icons.unfold_more)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8,),
            Text('CENTRO POBLADO'),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child:Center(
                child: Padding(
                  padding:  EdgeInsets.only(left: 8,right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('SAN MARTIN')),
                      Icon(Icons.unfold_more)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8,),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                height: 45,
                child: MaterialButton(
                  onPressed: (){

                  },
                  child: Text(
                    'Empezar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),

      )

    );*/


  }

  confirmationModal(String id){

    Get.dialog(

      AlertDialog(
        title: Text('Notificación'),
        content: Text('¿Esta seguro que desea continuar?'),
        actions: [

          Container(
            height: 40,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: Color.fromRGBO(0, 102, 84, 1),
              onPressed: (){
                navigateToQuiz(id);
              },
              child: Text('Empezar'),
              ),
          ),

          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(0, 102, 84, 1),
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: MaterialButton(
              onPressed: (){
                Get.back();
              },
              child: Text('Cancelar',style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1), ),),
            ),
          )

          /*FlatButton(

            onPressed: (){

              navigateToQuiz(id);

            },
            color: Color.fromRGBO(0, 102, 84, 1),
            child: Text('Empezar'),


          ),*/

         /*FlatButton(

            onPressed: (){

              Get.back();

            },
            color: Colors.grey,
            child: Text('Cancelar',style: TextStyle(color: Colors.white),),


          ),*/

        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      )

    );
    

  }

  messageInfo(String mensaje){

    Get.dialog(
      AlertDialog(

        title: Text('Notificación'),
        content: Text('$mensaje'),

      )

    );

  }

  loadMessage(String message, bool isLoading){

    Get.dialog(

      AlertDialog(

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            isLoading == true ? CircularProgressIndicator() : Container(),

            SizedBox(height: 20,),

            Text(message)

          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),

      )

    );


  }


  //  creamos la ficha en la bse de datos y si logras insertar exitosamente entonces navegamos a la pagina de las preguntas y  opciones.

  navigateToQuiz(String idEncuestado)async{

    
    DateTime now = DateTime.now();
    var utc = now.toUtc();
    
    String formatDate = DateFormat('yyyy-MM-ddHH:mm:ss').format(now);
    String hourFormat = DateFormat('HH:mm:ss').format(now);
    
    
    //String formattedDate = "2021-05-11T16:54:48.984Z"; //formatDate + "T" + hourFormat + ".0Z";
    //print(formattedDate);
    
    var part = utc.toString().split(" ");
    var fecha = part[0].toString();
    var hora =part[1].toString();
    print(part[1]);
    String formattedDate =fecha + "T" + hora;
  

 

    //print("formattedDate = "+formatDate);
    //print(fecha);
    //print(time);
    //String formattedDate = fecha + "T" + time + "z";
    //print(formatDate);
    //print(now);
 

    //print(formatDate + "T" + hourFormat + ".0Z");
    
    
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String latitud = position.latitude.toString();
    String longitud = position.longitude.toString();
    
    


    
    var ficha = await DBProvider.db.insertNewFicha( int.parse(idEncuesta) , int.parse(idEncuestado), formattedDate,latitud,longitud);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUsuario = await preferences.getString('idUsuario');
    List<FichasModel> listDbLocal  =  await DBProvider.db.getAllFichas( int.parse(idUsuario) );
    var getLastFichaid = await DBProvider.db.getLastFicha();
   
    int idFicha = getLastFichaid[0]["idFicha"];

    print("Ultima ficha insertada " + idFicha.toString());

    var result = await Get.to(

      QuizPage(),
      arguments: {

        'idEncuesta'      : idEncuesta,
        'tituloEncuesta'  : titulo,
        'idEncuestado'    : idEncuestado,
        'idFicha'         : idFicha.toString()

      }
      
      

    );

    if(result == "SI"){

      print('Actualizar la vista mostrando las encuestas pendientes');
      Get.back();
      Get.back();
      _listEncuesta = [];
      _encuestasPendientes = false;
      update();
      await pendientesEncuestas();


    }
    


  }


  pendientesEncuestas()async{

    _listFichas = [];
    _listFichas = await DBProvider.db.fichasPendientes("P");
    print(_listFichas.length);
    if(_listFichas.length > 0){

      for( var element in _listFichas){

        var listdata = await DBProvider.db.getOnesEncuesta(element.idEncuesta.toString());
        var idEncuestado3 = element.idEncuestado.toString();
        List<EncuestadoModel> _listEncuestado = await DBProvider.db.getOneEncuestado(idEncuestado3);
        var nombreEncuestado = _listEncuestado[0].nombre.toString() + " " + _listEncuestado[0].apellidoPaterno.toString();

        listdata.forEach((item){

          _listEncuesta.add(
            MisEncuestasModel(
              idEncuesta        : item["idEncuesta"].toString(),
              idProyecto        : item["idProyecto"].toString(),
              nombreEncuestado  : nombreEncuestado,
              nombreEncuesta    : item["titulo"],
              fechaInicio       : item["fechaInicio"],
              idFicha           : element.idFicha.toString() 

            )
          );

        });



      }

      _encuestasPendientes = true;

    }else{

      _encuestasPendientes = false;

    }

    update();


  }

  navigateToRetomarEncuesta(String idFicha, String  idEncuesta, String encuestaName)async{

    var data = {
      'idFicha'         : idFicha,
      'nombreEncuesta'  : encuestaName,
      'idEncuesta'      : idEncuesta
    };

    print(data);
     Get.to(
      RetomarEncuestaPage(),
      arguments: data
    
    );



  }

  modalDelete(String idFicha){

    Get.dialog(
      AlertDialog(
        title: Text('Notificación'),
        content: Text('¿Está seguro de eliminar esta ficha?'),
        actions: [

          Container(
            height: 40,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              color: Color.fromRGBO(0, 102, 84, 1),
              onPressed: (){
                deleteFicha(idFicha);
              },
              child: Text('Si'),
              ),
          ),
          
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(0, 102, 84, 1),
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: MaterialButton(
              onPressed: (){
                Get.back();
              },
              child: Text('Cancelar',style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1), ),),
            ),
          )

          

        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      ),
      
    );

  }

  deleteFicha(String id)async{

    var response = await DBProvider.db.deleteOneFicha(id);
    List<FichasModel> respuesta = await DBProvider.db.oneFicha(id);
    if(respuesta.length ==  0){

      print('se elimino el registro');
      Get.back();

      await refreshPage();
      
    }
  }

  refreshPage()async{


    _listEncuesta = [];
    _encuestasPendientes = false;
    
    await pendientesEncuestas();

    update();

  }




  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



}