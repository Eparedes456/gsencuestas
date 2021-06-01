import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/practica/PracticaController.dart';

class Practica extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticaController>(
      init: PracticaController(),
      builder:  (_) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Practica'),
        ),
        body:ListView.builder(
          itemCount: _.listPregunta.length,
          itemBuilder: (contex,i){

            if(_.listPregunta[i].tipo_pregunta == "IMPUTABLE"){

              return Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20,left: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _.listPregunta[i].enunciado,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                    fontSize: 16
                                  ),
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  color: Colors.red
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox( height: 20,),

                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: TextField(
                            controller: _.controllerInput[i].controller,
                          /*maxLength:  maxLength == null || int.parse(maxLength) == 0 ? 100 : int.parse(maxLength),
                          controller: _.controllerInput[index].controller,
                          decoration: InputDecoration(
                            hintText: placeholder == "-" || placeholder == null ? 'Ingrese su respuesta' : placeholder
                          ),
                          keyboardType: typeData == "number" ? TextInputType.phone  : TextInputType.text,
                          inputFormatters: typeData == "number"?  <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ] : null*/
                          ),
                                      
                        ),
                      ],
                    ),
                  ),
                )
              );

            }else{

              return Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Container(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20,left: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _.listPregunta[i].enunciado,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                    fontSize: 16
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text((() {
                              if(_.listPregunta[i].tipo_pregunta =="CALCULO"){

                                var data = _.listPregunta[i].calculation;
                                var part =data.split("+");
                                var result = "sin calcular";
                                var var1 = "0";
                                var var2 = "0";
                                print(part);
                                for (var i = 0; i < _.controllerInput.length; i++) {
                                  print(_.controllerInput[i].name);
                                  
                                  part.forEach((element) {
                                    
                                    if(element == _.controllerInput[i].name){
                                      print("ejecutar la suma");
                                      var1 = _.controllerInput[i].controller.text;
                                    }else{
                                      var2 = _.controllerInput[i].controller.text;
                                    }
                                    result = (int.parse(var1) + int.parse(var2)).toString() ;
                                    
                                  });

                                  
                                }
                                return "$result";
                              }
                              return "anything but true";
                            })())
                          ),
                        )
                      ],
                    )
                  )
                )
              );

            }

            
          }
        )
        
      ),
    );
  }
}