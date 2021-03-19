import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/model/Encuesta/EncuestaModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';
import 'package:gsencuesta/pages/quiz/QuizPage.dart';
import 'package:gsencuesta/services/apiServices.dart';

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


  navigateToQuiz(){

    Get.to(

      QuizPage(),
      arguments: {

        'idEncuesta'      : idEncuesta,
        'tituloEncuesta'  : titulo

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