import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/MisEncuestas/MisEncuestasController.dart';

class MisEncuestas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MisEncuestasController>(
      init: MisEncuestasController(),
      builder:(_)=> Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Mis Encuestas'),
          centerTitle: true,
          leading: Container(),
          actions: [

            PopupMenuButton(
              onSelected: (value){

                print(value);
                _.updateScreen(value);

              },
              itemBuilder: (BuildContext context){

                return <PopupMenuEntry>[

                  PopupMenuItem(

                    child:Text('Pendiente'),
                    value: "P",
                    
                    
                  ),

                  PopupMenuItem(
                    child: Text('Finalizado'),
                    value: "F",
                    
                  ),
                  
                  PopupMenuItem(
                    child: Text('Sincronizado'),
                    value: "S",
                    
                  ),

                  PopupMenuItem(
                    child: Text('Todos'),
                    value: "T",
                    
                  ),


                ];


              },
            )

          ],
        ),

        body: ListView.builder(
          itemCount: _.listMisEncuestas.length,
          itemBuilder: (BuildContext context,index){

            return Column(
                            children: [

                              SizedBox(height: 20,),

                              Padding(
                                padding:  EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  //margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  //height: 170,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child:Row(
                                      children: [
                                        
                                        Container(
                                          height: 130,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                            child: _.listMisEncuestas[index].imagen == "" ||  _.listMisEncuestas[index].imagen  == null ? Image(image: AssetImage('assets/images/encuesta.png'),fit: BoxFit.cover,) :CachedNetworkImage(
                                    
                                              imageUrl: 'https://t2.ev.ltmcdn.com/es/posts/8/3/1/fotos_de_paisajes_naturales_138_orig.jpg',
                                              placeholder: (context, url) => Image(
                                              image: AssetImage('assets/images/loading.gif'),),
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

                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Padding(
                                                padding:  EdgeInsets.only(left: 10,right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              
                                                  children: [

                                                    Expanded(
                                                      child: Text(
                                                        '${_.listMisEncuestas[index].nombreProyecto}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ),
                                                    
                                                    Container(
                                                      height: 25,
                                                      width: 90,
                                                      decoration: BoxDecoration(
                                                        color:   _.listMisEncuestas[index].estadoFicha == "F" ? Colors.redAccent :   _.listMisEncuestas[index].estadoFicha == "P" ? Colors.yellow[700]  : Colors.grey,
                                                        borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          _.listMisEncuestas[index].estadoFicha == "F" ? "Finalizado" : _.listMisEncuestas[index].estadoFicha == "P" ? "Pendiente" :'Sincronizado',
                                                          style: TextStyle(
                                                            color: Colors.white
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),

                                              Padding(
                                                padding:  EdgeInsets.only(left: 10,top: 8),
                                                child: Text(
                                                  '${_.listMisEncuestas[index].nombreEncuesta}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600]
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 8,),

                                              Padding(
                                                padding:  EdgeInsets.only(left: 10),
                                                child: Row(
                                                  children: [

                                                    Text(
                                                      'Nª preguntas:',
                                                      style: TextStyle(
                                                        color: Colors.grey[600]
                                                      ),
                                                    ),

                                                    SizedBox(width: 8,),

                                                    Text('15')

                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: 8,),

                                              Padding(
                                                padding:  EdgeInsets.only(left: 10),
                                                child: Row(
                                                children: [

                                                  Icon(Icons.calendar_today,size: 20,),
                                                  SizedBox(width: 8,),

                                                  Text(

                                                   '${_.listMisEncuestas[index].fechaInicio}'
                                                  )

                                                ],
                                            ),
                                              ),

                                            ],
                                          ),
                                        )

                                      ],

                                  ),
                                  
                                  
                                  /*Padding(
                                    padding:  EdgeInsets.fromLTRB(100,20,20,20),
                                    child: ListView(
                                      children: [


                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             
                                              children: [

                                                Text('Estado :'),
                                                
                                                Container(
                                                  height: 30,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Sincronizado',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                )



                                              ],
                                            ),

                                            SizedBox(height: 8,),

                                            Row(
                                              children: [

                                                Text(
                                                    'Nombre del proyecto',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                ),
                                                

                                                
                                              ],
                                            ),

                                            Text(
                                              'Nombre de la encuesta',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600]
                                              ),
                                            ),

                                            SizedBox(height: 8,),

                                            Row(
                                              children: [

                                                Text(
                                                  'Nª preguntas:',
                                                  style: TextStyle(
                                                    color: Colors.grey[600]
                                                  ),
                                                ),
                                                SizedBox(width: 8,),

                                                Text('15')

                                              ],
                                            ),

                                            SizedBox(height: 8,),
                                            
                                            Row(
                                              children: [

                                                Text(
                                                  'Fecha de inicio:',
                                                  style: TextStyle(
                                                    color: Colors.grey[600]
                                                  ),
                                                ),
                                                SizedBox(width: 8,),

                                                Text('11/12/2012')

                                              ],
                                            ),
                                            

                                          ],
                                        ),

                                      ], 
                                    ),
                                  ),*/
                                ),
                              ),

                              /*Positioned(
                                left: 10,
                                top: 30,
                                bottom: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    //height: 80,
                                    width: 90,
                                    imageUrl: 'https://t2.ev.ltmcdn.com/es/posts/8/3/1/fotos_de_paisajes_naturales_138_orig.jpg',
                                    placeholder: (context, url) => Image(
                                      image: AssetImage('assets/images/loading.gif'),),
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
                              )*/

                            ],
                          );

          }
        )

        
        
      ),
    );
  }
}