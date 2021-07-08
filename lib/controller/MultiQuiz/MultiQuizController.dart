
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Opciones/OpcionesModel.dart';
import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';

class MultiQuizController extends GetxController{

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var listDataEncuesta = Get.arguments;
    idEncuesta = listDataEncuesta["idEncuesta"];
    _tituloEncuesta = listDataEncuesta["tituloEncuesta"];
    idFicha = listDataEncuesta["idFicha"];
    idEncuestado = listDataEncuesta["idEncuestado"];
    this.getPreguntas(idEncuesta);
  }

  var idEncuesta;
  var idEncuestado;
  var idFicha;
  String _tituloEncuesta = "";

  int _currentPage = 0;
  int get currentPage => _currentPage;

  List<PreguntaModel> _preguntas = [];
  List<PreguntaModel> get preguntas => _preguntas;

  List<OpcionesModel> _opcionesPreguntas = [];
  List<OpcionesModel> get opcionesPreguntas => _opcionesPreguntas;

  List<InputTextfield> _controllerInput = [];
  List<InputTextfield> get controllerInput => _controllerInput;
  String bloque;

  final PageController pageController = PageController(
    initialPage: 0,
  );

  getPreguntas(String idEncuesta)async{
    
    _opcionesPreguntas = [];
    _preguntas = await DBProvider.db.consultPreguntaxEncuesta(idEncuesta);
    print(_preguntas);

    preguntas.asMap().forEach((index, element) {
      controllerInput.add(InputTextfield(
          element.id_pregunta.toString(),
          TextEditingController(),
          element.bind_name,
          index,
          element.tipo_pregunta,
          element.calculation));
    });

    var allOpciones = await DBProvider.db.getAllOpciones();

    print(allOpciones);

    for (var i = 0; i < _preguntas.length; i++) {
      print(_preguntas[i].id_pregunta);
      var idPregunta = _preguntas[i].id_pregunta;

      //_opcionesPreguntas = await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

      var opciones =
          await DBProvider.db.getOpcionesxPregunta(idPregunta.toString());

      opciones.forEach((element) {
        _opcionesPreguntas.add(OpcionesModel(
            idPreguntaGrupoOpcion: element["idPreguntaGrupoOpcion"],
            idOpcion: element["id_opcion"],
            idPregunta: idPregunta,
            valor: element["valor"],
            label: element["label"],
            orden: element["orden"],
            estado: element["estado"].toString(),
            createdAt: element["createdAt"],
            updated_at: element["updatedAt"],
            selected: false));
      });
    }
    print(_opcionesPreguntas);

    //_isLoadingData = true;

    //}

    update();
  }




  onPageChanged(int index){
    _currentPage = index;
    update();
  }
  

  nextPregunta(){
    
    pageController.animateToPage(_currentPage++, duration: Duration(milliseconds: 250), curve: Curves.easeIn);

  }

  backPregunta(){
    pageController.animateToPage(_currentPage--, duration: Duration(milliseconds: 250), curve: Curves.easeIn);
    print(_currentPage);

  }




  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}

class InputTextfield {
  String idPregunta;
  TextEditingController controller;
  String name;
  int index;
  String tipo_pregunta;
  String calculation;
  InputTextfield(this.idPregunta, this.controller, this.name, this.index,
      this.tipo_pregunta, this.calculation);
}