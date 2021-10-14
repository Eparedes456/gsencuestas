

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/controller/VerEncuesta/VerEncuestaController.dart';

class VerImage extends StatelessWidget {
  final String idPregunta;
  final int i;
  const VerImage({Key key, this.idPregunta, this.i}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return GetBuilder<VerEncuestacontroller>(
      init: VerEncuestacontroller(),
      id: 'image',
      builder: (_) => Column(
        children: [
          SizedBox(height: 20,),
          
          for (var i = 0; i < _.imagenes.length; i++)...{
            
            if(_.imagenes[i].idPregunta == idPregunta)...{

              Container(
                height: 150,
                width: double.infinity,
                child:  Image(
                  image: MemoryImage(_.imagenes[i].file),
                ) //Text(_.imagenes[i].file.toString())   //Image.memory(_.imagenes[i].file,fit: BoxFit.contain,)   //MemoryImage(_.imagenes[i])   //Text(_.imagenes[i]),//Image.file(_.imagepath,fit: BoxFit.contain,),
              ),

            }

          }
          
          /*for (var i = 0; i < _.respuestas.length; i++)...{

            if(_.respuestas[i].tipoPregunta == "Imagen")...{
              
              if(_.respuestas[i].tipoPregunta)...{}
              
              Container(
                height: 150,
                width: double.infinity,
                child: Image.memory(_.imagenes[i],fit: BoxFit.contain,)   //MemoryImage(_.imagenes[i])   //Text(_.imagenes[i]),//Image.file(_.imagepath,fit: BoxFit.contain,),
              ),

            }
          }*/
        ],
      )
      
    );
  }
}