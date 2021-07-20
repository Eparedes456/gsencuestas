

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/controller/RetomarController/RetomarController.dart';

class ImageRetonarPage extends StatelessWidget {
  final String idPregunta;
  final int i;
  const ImageRetonarPage({Key key, this.idPregunta, this.i}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetommarController>(
      init: RetommarController(),
      id: 'image',
      builder: (_) => Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              GestureDetector(
                onTap: (){
                  _.pickImage("CAMARA",idPregunta,i);
                },
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.camera,color: Colors.grey,),
                        SizedBox(width: 8,),
                        Text('Cámara'),
                      ],
                    ),
                  )
                ),
              ),

              SizedBox(width: 20,),

              GestureDetector(
                onTap: (){
                  _.pickImage("GALERIA",idPregunta,i);
                },
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
              
                        Icon(Icons.collections,color: Colors.grey,),
                        SizedBox(width: 8,),
                        Text('Galería'),
                      ],
                    ),
                  )
                ),
              )

            ],
          ),
          SizedBox(height: 20,),
         
          
          for (var i = 0; i < _.imagenes.length; i++)...{
            if(_.imagenes[i].idPregunta == idPregunta)...{

              Container(
                height: 150,
                width: double.infinity,
                child: Image.memory(_.imagenes[i].file,fit:BoxFit.contain) //Image.file(_.files[i].file,fit: BoxFit.contain,),
              )

            }
          }

          /*_.imagepath == null ? Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/noimage2.png'),
                fit: BoxFit.cover
              )
            ),

          ): Container(
            height: 150,
            width: double.infinity,
            
            child: Image.file(_.imagepath,fit: BoxFit.contain,),
          ),*/

        ],
      )
      
      /*Padding(
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Container(
          width: double.infinity,
          child: Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding:  EdgeInsets.only(top: 20,left: 10,right: 10),
                  child: Text(
                    'Sube imagenes',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      fontSize: 16
                    ),
                  ),
                ),

                SizedBox( height: 20,),

                Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10),
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        _.
                        ();
                      },
                      child: _.imagepath == null ? Container(
                        height: 300,
                        width: double.infinity,
                        //color: Colors.black,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://superwalter.com.ar/wp-content/uploads/2020/10/no-photo-available.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ) : Container(
                        height: 300,
                        width: double.infinity,
                        child: Image.file(_.imagepath,fit: BoxFit.contain,),
                      ),
                    ),
                  ),
                ),

                SizedBox( height: 20,),



              ],
            ),
          )
        ),
      ),*/
    );
  }
}