
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

                /*Padding(
                  padding: EdgeInsets.only(left: 22,right: 22),
                  child: Text('Agregue imagenes del lugar'),
                ),*/

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

                SizedBox(height: 10,),

                _.listMultimedia.length > 0 ?Container(
                  height: 300,
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
                                    Container(
                                      height: 102,
                                      width: 120,
                                      
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          
                                        ),
                                        color: Colors.black
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          
                                        ),
                                        child: Image.memory(showImage64,fit: BoxFit.fill)
                                      ),
                                    ),

                                    Text('Imagen ' + index.toString()),

                                    IconButton(
                                      icon: Icon(Icons.delete,color: Colors.redAccent,), 
                                      onPressed: (){}
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
                ):Container(),

                

                /*Padding(
                    padding:  EdgeInsets.only(left: 10,right: 10,top: 20),
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          _.pickImage();
                        },
                        child: _.imagepath == null ? Container(
                          height: 200,
                          width: 800,
                          //color: Colors.black,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/no-image.png'),
                              fit: BoxFit.cover
                            )
                          ),
                        ): Container(
                          height: 300,
                          width: double.infinity,
                          child: Image.file(_.imagepath,fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                ),*/

                /*Padding(
                  padding: EdgeInsets.only(left:20,right: 20,top: 20),
                  child: Text('Por favor tome fotos del lugar donde se esta relizando la encuesta.'),
                ),*/

                

                SizedBox(height: 20,),

                Padding(
                  padding:  EdgeInsets.only(left: 40,right: 40),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: MaterialButton(
                      onPressed: (){
                        print('Guardando');
                        _.saveFicha();
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

                SizedBox(height: 20,),

                

              ],
            ),
          ),
          
        ),
      ),
    );
  }
}


