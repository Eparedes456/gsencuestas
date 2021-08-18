import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/MisEncuestas/MisEncuestasController.dart';
import 'package:gsencuesta/pages/MisEncuestas/DetailMiEncuestaPage.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MisEncuestas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MisEncuestasController>(
      init: MisEncuestasController(),
      //id: 'misencuestas',
      builder:(_)=> WillPopScope(
        onWillPop: (){
          _.exit();
        },
        child: Scaffold(
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
                SizedBox(height: 20,),

                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Text('No se encontraron encuestas.'),
                )

              ],
            )
          ): _.haydata == true && _.isLoading == false ?
          
          
          ListView.builder(
            itemCount: _.listMisEncuestas.length,
            itemBuilder: (BuildContext context,index){

              String idFicha = _.listMisEncuestas[index].idFicha;

              final dateTime = DateTime.parse(_.listMisEncuestas[index].fechaInicio);
              final format = DateFormat('dd-MM-yyyy');
              final clockString = format.format(dateTime); 
             

              return Padding(
                padding:  EdgeInsets.only(bottom: 10,top: 10),
                child: Column(
                                children: [

                                  //SizedBox(height: 20,),

                                  Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    actions: [
                                      
                                      _.listMisEncuestas[index].estadoFicha == "F" || _.listMisEncuestas[index].estadoFicha == "P" ? IconSlideAction(
                                        caption: 'Eliminar',
                                        color: Colors.redAccent,
                                        icon: Icons.delete,
                                        onTap: (){

                                          _.modalDelete(_.listMisEncuestas[index].idFicha);

                                        }
                                      ): null,
                                      

                                    ],
                                    secondaryActions: [
                                      _.listMisEncuestas[index].estadoFicha == "P" ? IconSlideAction(
                                        iconWidget: Icon(Icons.edit,color: Colors.white,),
                                        foregroundColor: Colors.white,
                                        caption: 'Retomar',
                                        color: Colors.yellow[800],
                                        onTap: (){

                                          _.navigateToRetomarEncuesta(_.listMisEncuestas[index].idFicha.toString(), _.listMisEncuestas[index].idEncuesta, _.listMisEncuestas[index].nombreEncuesta ) ;

                                        },
                                        //icon: Icons.edit,
                                      ) : null,

                                      IconSlideAction(
                                        caption: 'Detalle',
                                        foregroundColor: Colors.white,
                                        color: Color.fromRGBO(20, 183, 201, 1),   //20, 183, 201 mas oscuro   108, 230, 244 => claro
                                        icon: FontAwesomeIcons.eye,
                                        onTap: (){
                                          _.navigateToDetail(idFicha);
                                          
                                        }
                                      ),

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
                                                
                                                Padding(
                                                  padding:  EdgeInsets.only(left: 5),
                                                  child: Container(
                                                    height: 130,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10)
                                                      //borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                                                    ),
                                                    child: CircularPercentIndicator(
                                                              radius: 60,
                                                              lineWidth: 5,
                                                              animation: true,
                                                              animationDuration: 500,
                                                              percent: _.listMisEncuestas[index].percent,
                                                              center: Text(
                                                                _.listMisEncuestas[index].porcentaje + '%',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16
                                                                ),
                                                              ),
                                                              progressColor:  Colors.green,
                                                            )
                                                    
                                                    /*Center(
                                                      child: Icon(Icons.content_paste,size: 30,color: Colors.white),
                                                    ),*/
                                                    
                                                    
                                                    
                                                    /*ClipRRect(
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
                                                    ),*/
                                                  ),
                                                ),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                      Padding(
                                                        padding:  EdgeInsets.only(left: 10,right: 10,top: 10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      
                                                          children: [

                                                            Expanded(
                                                              child: Text(
                                                                '${_.listMisEncuestas[index].nombreEncuesta}',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 13
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            
                                                            Padding(
                                                              padding:  EdgeInsets.only(bottom: 6),
                                                              child: Container(
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
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),

                                                      

                                                    
                                                      Padding(
                                                        padding:  EdgeInsets.only(left: 10,top: 0),
                                                        child: Text(
                                                          '${_.listMisEncuestas[index].nombreProyecto}',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[600]
                                                          ),
                                                        ),
                                                      ),

                                                      

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

                                                      Padding(
                                                        padding:  EdgeInsets.only(left: 10),
                                                        child: Row(
                                                        children: [

                                                          Icon(Icons.account_circle,size: 12,),
                                                          SizedBox(width: 8,),

                                                          Text(

                                                           '${_.listMisEncuestas[index].nombreEncuestado}',
                                                           style: TextStyle(
                                                            fontSize: 12,
                                                            color:Colors.grey[600]
                                                           ),
                                                          )

                                                        ],
                                                    ),
                                                      ),

                                                      Padding(
                                                        padding:  EdgeInsets.only(left: 10,bottom: 0),
                                                        child: Row(
                                                        children: [

                                                          Icon(Icons.calendar_today,size: 12,),
                                                          SizedBox(width: 8,),

                                                          Text(
                                                            clockString,
                                                           //'${_.listMisEncuestas[index].fechaInicio}',
                                                           style: TextStyle(
                                                             fontSize: 12,
                                                             color: Colors.grey[600]
                                                           ),
                                                          )

                                                        ],
                                                    ),
                                                      ),

                                                      Padding(
                                                        padding:  EdgeInsets.only(left: 10,bottom: 10),
                                                        child: Text(
                                                          'Se respondió ${_.listMisEncuestas[index].preguntasRespondidas} de ${_.listMisEncuestas[index].totalPreguntas} preguntas',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[600]
                                                          ),
                                                        ),
                                                      )

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
      ),
    );
  }
}