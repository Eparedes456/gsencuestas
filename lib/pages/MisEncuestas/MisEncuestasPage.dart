import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/MisEncuestas/MisEncuestasController.dart';
import 'package:gsencuesta/pages/MisEncuestas/DetailMiEncuestaPage.dart';

class MisEncuestas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MisEncuestasController>(
      init: MisEncuestasController(),
      //id: 'misencuestas',
      builder:(_)=> Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Mis Encuestas'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.cached),
            onPressed: (){

              _.refreshPage();

            },
          ),
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

        body: _.haydata == false && _.isLoading == false ? Center(
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
              SizedBox(height: 12,),

              Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Text('No se encontraron encuestas que realizastes.'),
              )

            ],
          )
        ): _.haydata == true && _.isLoading == false ?
        
        
        ListView.builder(
          itemCount: _.listMisEncuestas.length,
          itemBuilder: (BuildContext context,index){

            String idFicha = _.listMisEncuestas[index].idFicha;
            print("Data :$idFicha ");

            return Padding(
              padding:  EdgeInsets.only(bottom: 10,top: 10),
              child: Column(
                              children: [

                                //SizedBox(height: 20,),

                                Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  actions: [
                                    
                                    IconSlideAction(
                                      caption: 'Detalle',
                                      color: Colors.blueAccent,
                                      icon: FontAwesomeIcons.eye,
                                      onTap: (){
                                        _.navigateToDetail(idFicha);
                                        
                                      }
                                    )

                                  ],
                                  secondaryActions: [

                                    _.listMisEncuestas[index].estadoFicha == "F" || _.listMisEncuestas[index].estadoFicha == "P" ? IconSlideAction(
                                      caption: 'Eliminar',
                                      color: Colors.redAccent,
                                      icon: Icons.delete,
                                      onTap: (){

                                        _.modalDelete();

                                      }
                                    ): null

                                  ],
                                  child: Padding(
                                    padding:  EdgeInsets.only(left: 10,right: 10),
                                    child: GestureDetector(
                                      onTap: (){

                                        _.navigateToDetail(idFicha);

                                      },
                                      child: Container(
                                       
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child:Row(
                                            children: [
                                              
                                              Container(
                                                height: 130,
                                                width: 70,
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
                                                              '${_.listMisEncuestas[index].nombreEncuestado}',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'Poppins',
                                                                fontSize: 13
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
                                                                  color: Colors.white,
                                                                  fontSize: 12
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
                                                          fontSize: 12,
                                                          color: Colors.grey[600]
                                                        ),
                                                      ),
                                                    ),

                                                  
                                                    Padding(
                                                      padding:  EdgeInsets.only(left: 10,top: 8),
                                                      child: Text(
                                                        '${_.listMisEncuestas[index].nombreProyecto}',
                                                        style: TextStyle(
                                                          fontSize: 12,
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
                                                              color: Colors.grey[600],
                                                              fontSize: 12
                                                            ),
                                                          ),

                                                          SizedBox(width: 8,),

                                                          Text('${_.nroTotalPreguntas}',style: TextStyle(fontSize: 12),)

                                                        ],
                                                      ),
                                                    ),

                                                    SizedBox(height: 8,),

                                                    Padding(
                                                      padding:  EdgeInsets.only(left: 10),
                                                      child: Row(
                                                      children: [

                                                        Icon(Icons.calendar_today,size: 12,),
                                                        SizedBox(width: 8,),

                                                        Text(

                                                         '${_.listMisEncuestas[index].fechaInicio}',
                                                         style: TextStyle(
                                                           fontSize: 12
                                                         ),
                                                        )

                                                      ],
                                                  ),
                                                    ),

                                                  ],
                                                ),
                                              )

                                            ],

                                        ),
                                        
                                      ),
                                    ),
                                  ),
                                ),

                       
                                

                                

                              ],
                            ),
            );
                          

          }
        ): Center(
          child: CircularProgressIndicator(),
        )

        
        
      ),
    );
  }
}