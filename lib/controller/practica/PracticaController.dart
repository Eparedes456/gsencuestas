import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'dart:convert';

import 'package:gsencuesta/model/Pregunta/PreguntaModel.dart';

class PracticaController extends GetxController{

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    this.loadData();
  }

  List<PreguntaModel> _listPregunta = [];
  List<PreguntaModel> get listPregunta => _listPregunta;

  List<InputTextfield> _controllerInput = [];

  List<InputTextfield> get controllerInput => _controllerInput;

  loadData()async{

    var data = [
      {
        "createdAt": "2021-04-20T22:08:12.889+0000",
        "updatedAt": "2021-05-25T20:51:02.125+0000",
        "idPregunta": 36,
        "enunciado": "Ingrese tu nombre",
        "tipo_pregunta": "TEXT",
        "apariencia": null,
        "requerido": true,
        "requerido_msj": "-",
        "readonly": false,
        "defecto": "-",
        "calculation": "",
        "restriccion": null,
        "restriccion_msj": null,
        "relevant": null,
        "choice_filter": null,
        "name": "nombre",
        "bindType": "text",
        "bindFieldLength": 3,
        "bindFieldPlaceholder": "-",
        "orden": 1,
        "estado": true,
        "userCreated": null,
        "userUpdated": null,
        "encuesta": null,
        "index" : 2
      },
      {
          "createdAt": "2021-04-20T22:08:12.889+0000",
          "updatedAt": "2021-05-25T20:51:02.125+0000",
          "idPregunta": 32,
          "enunciado": "Ingrese la cantidad de moscas hembra",
          "tipo_pregunta": "INTEGER",
          "apariencia": null,
          "requerido": true,
          "requerido_msj": "-",
          "readonly": false,
          "defecto": "-",
          "calculation": "",
          "restriccion": null,
          "restriccion_msj": null,
          "relevant": null,
          "choice_filter": null,
          "name": "hembra",
          "bindType": "number",
          "bindFieldLength": 3,
          "bindFieldPlaceholder": "-",
          "orden": 1,
          "estado": true,
          "userCreated": null,
          "userUpdated": null,
          "encuesta": null,
          "index" : 1
      },
      {
          "createdAt": "2021-04-20T22:08:12.889+0000",
        "updatedAt": "2021-05-25T20:51:02.125+0000",
        "idPregunta": 33,
        "enunciado": "Ingrese la cantidad de moscas macho",
        "tipo_pregunta": "INTEGER",
        "apariencia": null,
        "requerido": true,
        "requerido_msj": "-",
        "readonly": false,
        "defecto": "-",
        "calculation": "",
        "restriccion": null,
        "restriccion_msj": null,
        "relevant": null,
        "choice_filter": null,
        "name": "macho",
        "bindType": "number",
        "bindFieldLength": 3,
        "bindFieldPlaceholder": "-",
        "orden": 1,
        "estado": true,
        "userCreated": null,
        "userUpdated": null,
        "encuesta": null,
        "index" : 2
      },
      {
          "createdAt": "2021-04-20T22:08:12.889+0000",
        "updatedAt": "2021-05-25T20:51:02.125+0000",
        "idPregunta": 34,
        "enunciado": "Total de moscas",
        "tipo_pregunta": "NOTE",
        "apariencia": null,
        "requerido": true,
        "requerido_msj": "-",
        "readonly": false,
        "defecto": "-",
        "calculation": "hembra+macho",
        "restriccion": null,
        "restriccion_msj": null,
        "relevant": null,
        "choice_filter": null,
        "name": "totalmoscas",
        "bindType": "number",
        "bindFieldLength": 3,
        "bindFieldPlaceholder": "-",
        "orden": 1,
        "estado": true,
        "userCreated": null,
        "userUpdated": null,
        "encuesta": null,
        "index" : 3
      },
      {
        "createdAt": "2021-04-20T22:08:12.889+0000",
        "updatedAt": "2021-05-25T20:51:02.125+0000",
        "idPregunta": 35,
        "enunciado": "Ingrese el precio del cafe",
        "tipo_pregunta": "INTEGER",
        "apariencia": null,
        "requerido": true,
        "requerido_msj": "-",
        "readonly": false,
        "defecto": "-",
        "calculation": "",
        "restriccion": null,
        "restriccion_msj": null,
        "relevant": null,
        "choice_filter": null,
        "name": "precio",
        "bindType": "number",
        "bindFieldLength": 3,
        "bindFieldPlaceholder": "-",
        "orden": 1,
        "estado": true,
        "userCreated": null,
        "userUpdated": null,
        "encuesta": null,
        "index" : 2
      },
      {
        "createdAt": "2021-04-20T22:08:12.889+0000",
        "updatedAt": "2021-05-25T20:51:02.125+0000",
        "idPregunta": 36,
        "enunciado": "Ingrese el precio del cafe",
        "tipo_pregunta": "INTEGER",
        "apariencia": null,
        "requerido": true,
        "requerido_msj": "-",
        "readonly": false,
        "defecto": "-",
        "calculation": "",
        "restriccion": null,
        "restriccion_msj": null,
        "relevant": null,
        "choice_filter": null,
        "name": "cantidad",
        "bindType": "number",
        "bindFieldLength": 3,
        "bindFieldPlaceholder": "-",
        "orden": 1,
        "estado": true,
        "userCreated": null,
        "userUpdated": null,
        "encuesta": null,
        "index" : 2
      },
      {
        "createdAt": "2021-04-20T22:08:12.889+0000",
        "updatedAt": "2021-05-25T20:51:02.125+0000",
        "idPregunta": 37,
        "enunciado": "Total en solas",
        "tipo_pregunta": "NOTE",
        "apariencia": null,
        "requerido": true,
        "requerido_msj": "-",
        "readonly": false,
        "defecto": "-",
        "calculation": "precio*cantidad",
        "restriccion": null,
        "restriccion_msj": null,
        "relevant": null,
        "choice_filter": null,
        "name": "totalsoles",
        "bindType": "number",
        "bindFieldLength": 3,
        "bindFieldPlaceholder": "-",
        "orden": 1,
        "estado": true,
        "userCreated": null,
        "userUpdated": null,
        "encuesta": null,
        "index" : 3
      },
    ];

    //print(data);
    data.asMap().forEach((index,element) { 
      _listPregunta.add(
        PreguntaModel(
          id_pregunta       : element["id_pregunta"],
          id_bloque         : element["id_bloque"],
          idEncuesta        : element["idEncuesta"],
          enunciado         : element["enunciado"],
          tipo_pregunta     : element["tipo_pregunta"],
          apariencia        : element["apariencia"],
          requerido         : element["requerido"].toString(),
          requerido_msj     : element["requerido_msj"],
          readonly          : element["readonly"].toString(),
          defecto           : element["defecto"],
          calculation       : element["calculation"],
          restriccion       : element["restriccion"], 
          restriccion_msj   : element["restriccion_msj"], 
          relevant          : element["relevant"], 
          choice_filter     : element["choice_filter"],
          bind_name         : element["name"], 
          bind_type         : element["bind_type"],
          bind_field_length : element["bind_field_length"],
          bind_field_placeholder  : element["bind_field_placeholder"],
          orden             : element["orden"], 
          estado            : element["estado"].toString(),
          updated_at        : element["updatedAt"],
          created_at        : element["createdAt"],
          index1             : index
        )
      );
    });

    
    print(listPregunta);

    listPregunta.asMap().forEach((index,element) { 
      
      if(element.tipo_pregunta == "INTEGER"){

        controllerInput.add(
          InputTextfield(
            element.id_pregunta.toString(),
            TextEditingController(),
            element.bind_name,
            index
          )

        );
        

      }else if(element.tipo_pregunta == "NOTE"){
        controllerInput.add(
          InputTextfield(
            element.id_pregunta.toString(),
            TextEditingController(text: "0"),
            element.bind_name,
            index
          )

        );
      }
      else if(element.tipo_pregunta == "TEXT"){
        controllerInput.add(
          InputTextfield(
            element.id_pregunta.toString(),
            TextEditingController(),
            element.bind_name,
            index
          )

        );
      }
      
      print(controllerInput);

    });


    update();
  
  }


  List<PreguntaModel> tempList = [];
  var total = 0;
  calcular()async{
    
    tempList =  _listPregunta.where((element) => element.tipo_pregunta.contains("NOTE")).toList();
    List<PreguntaModel> filtered2 =  _listPregunta.where((element) => element.tipo_pregunta.contains("INTEGER") || element.tipo_pregunta.contains("DECIMAL")).toList();
    print(filtered2);
    if(tempList.length > 0){
      //print('si hay');
      tempList.forEach((item) {
        var oper1 = item.calculation.indexOf('+');
        if(oper1 != -1){
          var part = item.calculation.split('+');
          total  = 0;
          part.asMap().forEach((index,partes) {
            
            List<PreguntaModel> filtered1 = _listPregunta.where((data) => data.bind_name.contains(partes)).toList();
            filtered2.asMap().forEach((index,element) { 
              if(filtered1[0].bind_name == controllerInput[index].name){
                var value1  = controllerInput[index].controller.text;
                if( value1 == "" || value1 == null){

                }else{
                  total = int.parse(value1)  + total;
                  print("Resultaod de la suma : $total");

                }
                controllerInput.forEach((element) { 
                  if(tempList[0].bind_name == element.name){
                    element.controller.text = total.toString();
                  }
                });

                
                
              }else{
                print('No es ${controllerInput[index].name}');
              }

            }); 
           
            
          });
        }else if(oper1  == -1){
          var oper2 = item.calculation.indexOf('*');
          if(oper2 != -1){
            var part = item.calculation.split('*');
            var total2  = 0;
            part.asMap().forEach((index,partes) {
              List<PreguntaModel> filtered1 = _listPregunta.where((data) => data.bind_name.contains(partes)).toList();
              _listPregunta.asMap().forEach((index,element) { 
                if(filtered1[0].bind_name == controllerInput[index].name){
                  var value1  = controllerInput[index].controller.text;
                  if( value1 == "" || value1 == null){

                  }else{
                    total2 = int.parse(value1)  * total2;
                    print("Resultaod de la multiplicación : $total2");

                  }
                  controllerInput.forEach((element) { 
                    if(tempList[0].bind_name == element.name){
                      element.controller.text = total2.toString();
                    }
                  });

                  
                  
                }else{
                  print('No es ${controllerInput[index].name}');
                }

              }); 


            });
          }
        }
        /*else if(oper1 == -1){
          var oper2 = item.calculation.indexOf('*');
          if(oper2 != -1){
            var part = item.calculation.split('*');
            total  = 0;
            part.asMap().forEach((index,partes) {
            
              List<PreguntaModel> filtered1 = _listPregunta.where((data) => data.bind_name.contains(partes)).toList();
              if(filtered1[0].bind_name == controllerInput[index].name){
                var value1  = controllerInput[index].controller.text;
                if( value1 == "" || value1 == null){

                }else{
                  total = int.parse(value1)  + total;
                  print("Resultaod de la suma : $total");

                }
                controllerInput.forEach((element) { 
                  if(tempList[0].bind_name == element.name){
                    element.controller.text = total.toString();
                  }
                });

              
              
              }else{
                print('No es ${controllerInput[index].name}');
              }
            });
          }

        }*/
      });
    }
    update();
    //total = 0;
    
  }
  
  operaSum(){
    
  }


}

class InputTextfield{

  String idPregunta;
  TextEditingController controller;
  String name;
  int    index;
  InputTextfield(this.idPregunta,this.controller,this.name,this.index);

}