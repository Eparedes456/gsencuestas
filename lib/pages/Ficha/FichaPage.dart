
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Ficha/FichaController.dart';

class FichaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FichaController>(
      init: FichaController(),
      builder: (_) => WillPopScope(
        onWillPop: (){
          _.cannotBack();
        },
        child: Scaffold(

          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text('Ficha'),
            centerTitle: true,
            leading: Container(),
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding:  EdgeInsets.only(left: 22,right: 20,top: 12,),
                  child: Text('Observación'),
                ),

                Padding(
                  padding: EdgeInsets.only(left:20,right: 20,top: 12),
                  child: TextField(
                    controller: _.controllerobservacion,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      //labelText: 'Observación',
                      hintText: 'Digite la observación'
                    ),
                  ),
                ),

                SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    child: MaterialButton(
                      color: Colors.grey[350],
                      onPressed: (){
                        _.showModalImage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Icon(Icons.image),
                          Text('Agregue una imagen o foto'),
                          Icon(Icons.add)

                        ],
                      ),
                    )
                  ),
                ),

                SizedBox(height:8,),

                _.listMultimedia.length > 0 ?
                  Container(
                    height: MediaQuery.of(context).size.height/2.2,
                    child: ListView.builder(
                      itemCount: _.listMultimedia.length,
                      itemBuilder: (context, index){
                
                        Uint8List showImage64;
                        showImage64 = base64Decode(_.listMultimedia[index].tipo );
                
                
                        return Padding(
                          padding:  EdgeInsets.only(left: 10,right: 10),
                          child: Container(
                
                            height: 110,
                            child: Card(
                              elevation: 2,
                              child: Column(
                                children: [
                
                                  
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 86,
                                          width: 100,
                                          
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              
                                            ),
                                            color: Colors.black
                                          ),
                                          child: ClipRRect(
                                            /*borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              
                                            ),*/
                                            child: Image.memory(showImage64,fit: BoxFit.fill)
                                          ),
                                        ),
                                      ),
                
                                      //Text('Imagen ' + (index + 1).toString()),

                                      Expanded(
                                        child: TextField(
                                          controller: _.controllerInput[index].controller,
                                          decoration: InputDecoration(
                                            hintText: 'nombre de la foto'
                                          ),
                                        )
                                      ),
                                      
                                      /*GestureDetector(
                                        onTap: (){
                                          _.cambiarnombreFoto(_.listMultimedia[index].idMultimedia.toString(),"");
                                        },
                                        child: Icon(Icons.save,color: Color.fromRGBO(0, 102, 84, 1),), 
                                      ),*/
                                      GestureDetector(
                                        onTap: (){
                                          _.deleteImage(_.listMultimedia[index].idMultimedia.toString());
                                        },
                                        child: Icon(Icons.delete,color: Colors.redAccent,),
                                      )

                                      
                                    ],
                                  ),
                
                                  
                
                                ],
                              ),
                            ),
                          ),
                        );
                
                      }
                    ),
                  )
                :Container(),


                SizedBox(height: 1,) ,

                Padding(
                  padding:  EdgeInsets.only(left: 40,right: 40),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: MaterialButton(
                      onPressed: (){
                        
                        _.validarRequerimientos();
                        //_.saveFicha();
                      },
                      child: Center(
                        child: Text(
                          'Guardar Ficha',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 5,),

                

              ],
            ),
          ),
          
        ),
      ),
    );
  }
}


