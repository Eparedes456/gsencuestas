import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Proyecto/ProyectoController.dart';


class ProyectoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProyectoController>(
      init: ProyectoController(),
      builder: (_) {
        
        if(_.isLoadingData == false){

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );

        }else{

          return Scaffold(

              backgroundColor: Colors.grey[200],
              body: Column(
                children: [
                  
                  Stack(
                    children: [

                      Container(
                        height: MediaQuery.of(context).size.height*0.4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [

                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0,2.0),
                              blurRadius: 6.0,
                            )

                          ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                          child: CachedNetworkImage(

                            imageUrl:  "https://dev.regionsanmartin.gob.pe/gsencuesta/api/v1/recurso/proyecto/${_.idProyecto}",  //'${_.imagen}',
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Center(

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Icon(Icons.error,color: Colors.red,),
                                  SizedBox(height: 8,),
                                  Text('Lo sentimos no pudimos cargar la imagen')
                                ],
                              )
                            ),
                            fit: BoxFit.cover,

                          )
                          
                          
                          
                          
                          
                        ),
                      ),

                      Row(

                        children: [

                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 10.0,vertical: 40),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.8),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaY: 19.2,sigmaX: 19.2
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 40,
                                  //color: Colors.white,
                                  child: Center(
                                    child: IconButton(
                                      icon:  Platform.isAndroid ?  Icon(Icons.arrow_back) : Icon(Icons.arrow_back_ios),
                                      color: Colors.white,
                                      iconSize: 30,
                                      onPressed: (){

                                        Navigator.of(context).pop();

                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],

                      ),

                      Positioned(
                        left: 10,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Padding(
                              padding:  EdgeInsets.only(left: 20,right: 20),
                              child: ClipRRect(
                                
                                borderRadius: BorderRadius.circular(4.8),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaY: 19.2,sigmaX: 19.2
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.only(left: 8,right: 8),
                                    child: Text(
                                      _.nombreProyecto,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            

                          ],
                        ),
                      )

                    ],
                  ),

                  Expanded(
                    child:  _.isLoading == true && _.hayEncuestas == false? Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                        //backgroundColor: Colors.green,
                      ),
                    ): _.isLoading == false && _.hayEncuestas == false?
                    
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            height: 200,
                            child: Image(
                              image: AssetImage('assets/images/noencuesta.png'),
                            ),
                          ),
                          SizedBox(height: 20,),

                          Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Text('No se encontraron encuestas.'),
                          )

                        ],
                      )
                    )
                    
                    :ListView.builder(

                      itemCount: _.encuestas.length,
                      itemBuilder: (context,index){
                        print(_.encuestas[index].idEncuesta);
                        print('https://dev.regionsanmartin.gob.pe/gsencuesta/api/v1/recurso/encuesta/${_.encuestas[index].idEncuesta}');
                        return GestureDetector(
                          onTap: (){

                            _.navigateToEncuesta(_.encuestas[index]);

                          },
                          child: Stack(
                            children: [

                              Container(
                                margin: EdgeInsets.fromLTRB(40, 5, 20.0, 5),
                                height: 170,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.fromLTRB(100,20,20,20),
                                  child: ListView(
                                    children: [


                                      Column(
                                        children: [

                                          Text(
                                            _.encuestas[index].titulo,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),


                                          Text(
                                            _.encuestas[index].descripcion,
                                            style: TextStyle(
                                              color: Colors.grey[600]
                                            ),
                                            textAlign: TextAlign.justify,
                                            
                                          ),

                                          

                                        ],
                                      ),

                                    ], 
                                  ),
                                ),
                              ),

                              Positioned(
                                left: 20,
                                top: 15,
                                bottom: 15,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(

                                    width: 110,
                                    imageUrl: "https://dev.regionsanmartin.gob.pe/gsencuesta/api/v1/recurso/encuesta/${_.encuestas[index].idEncuesta}",    //'${_.encuestas[index].logo}',
                                    placeholder: (context, url) => Image(image: AssetImage('assets/images/loading.gif'),),
                                    errorWidget: (context, url, error) => Image(
                                      image: AssetImage('assets/images/noimage2.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    
                                    /*Center(

                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Icon(Icons.error,color: Colors.red,),
                                          SizedBox(height: 8,),
                                          Text('Lo sentimos no pudimos cargar la imagen')
                                        ],
                                      )
                                    ),*/
                                    fit: BoxFit.cover,

                                  )
                                  
                                 
                                  
                                ),
                              )

                            ],
                          ),
                        );

                      }
                      
                    ),
                  )

                ],
              ),
              
            );
          
      }

      } 
    );
  }
}