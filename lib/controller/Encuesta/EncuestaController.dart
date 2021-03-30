import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Ficha/FichasModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/pages/quiz/QuizPage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:intl/intl.dart';

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
    print(data);

   

    loadData(data);



    

  }

  ApiServices apiConexion= new ApiServices();

  String _imagePortada = "";
  String get imagePortada => _imagePortada;

  String _titulo = "";
  String get titulo => _titulo;

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

  List<PreguntaModel> _listPregunta = [];
  List<PreguntaModel> get listPregunta => _listPregunta;

  TextEditingController insertEncuestadoController = new TextEditingController();

  String idEncuestado;


  loadData(EncuestaModel encuesta)async{

    _imagePortada   = encuesta.logo;
    _descripcion    = encuesta.descripcion;
    _titulo         = encuesta.titulo;
    _fechaFin       = encuesta.fechaFin;
    _fechaInicio    = encuesta.fechaInicio;
    _idEncuesta     = encuesta.idEncuesta.toString();

    //loadingModal();
    
    await getPreguntas(encuesta.idEncuesta.toString());

    

    update();

  }

  getPreguntas(String idEncuesta)async{

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
              color: Colors.green,
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

      List response = await apiConexion.findEncuestado(insertEncuestadoController.text);

      //print(response);       

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

    }

  }

  showEncuestadoModal(dynamic data){

    var idEncuestado2    = data[0]["idEncuestado"];
    var nombreCompleto  =  data[0]["nombre"] + " " + data[0]["apellidoPaterno"] + " " + data[0]["apellidoMaterno"];

    Get.dialog(

      AlertDialog(

        title: Text('Encuestado encontrado'),
        content: ListTile(

          leading: Icon(Icons.people,size: 16,),
          trailing: Icon(Icons.arrow_forward,size: 16,),
          title: Text('$nombreCompleto',style: TextStyle(fontSize: 14),),
          onTap: (){

            idEncuestado = idEncuestado2.toString();
            print(idEncuestado);

            confirmationModal(idEncuestado);
          },

        )

      )

    );


  }

  confirmationModal(String id){

    Get.dialog(

      AlertDialog(
        title: Text('Notificacón'),
        content: Text('¿Esta seguro que desea continuar?'),
        actions: [

          FlatButton(

            onPressed: (){

              navigateToQuiz(id);

            },

            child: Text('Iniciar'),


          ),

          FlatButton(

            onPressed: (){

              Get.back();

            },

            child: Text('Cancelar'),


          ),

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

      )

    );


  }


  //  creamos la ficha en la bse de datos y si logras insertar exitosamente entonces navegamos a la pagina de las preguntas y  opciones.

  navigateToQuiz(String idEncuestado)async{

    
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(now);
    
    print(formattedDate);
    

    var ficha = await DBProvider.db.insertNewFicha( int.parse(idEncuesta) , int.parse(idEncuestado), formattedDate);

    //print(ficha);

    List<FichasModel> listDbLocal  =  await DBProvider.db.getAllFichas();

    print(listDbLocal);

     int idFicha = listDbLocal[0].idFicha;

    Get.to(

      QuizPage(),
      arguments: {

        'idEncuesta'      : idEncuesta,
        'tituloEncuesta'  : titulo,
        'idEncuestado'    : idEncuestado,
        'idFicha'         : idFicha.toString()

      }
      
      

    );

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