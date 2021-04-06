import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/DetalleFicha/DetalleFichaController.dart';


class DetailMiEncuestaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetalleFichaController>(
      init: DetalleFichaController(),
      builder:(_)=> Scaffold(
        
        appBar: AppBar(
          centerTitle: true,
          title: Text('Detalle Ficha'),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 20,),

              Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Container(
                  width: double.infinity,
                  //height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        height: 130,
                        width: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: AssetImage('assets/images/encuesta.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      Expanded(
                        child: Padding(
                          padding:  EdgeInsets.only(left: 10,right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Expanded(child: Text('Nº FICHA:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                  
                                  Expanded(child: Text('${_.idFicha}'))
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Expanded(child: Text('F. INICIO:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold))),
                                 
                                  Expanded(child: Text('${_.fechaInicio}'))
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Expanded(child: Text('F. FIN:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold))),
                                 
                                  Expanded(child: Text('${_.fechaFin}'))
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Expanded(child: Text('ESTADO:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold))),
                                  
                                   Expanded(
                                     child: Container(
                                        height: 25,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          color:  _.estado == "F" ? Colors.redAccent : _.estado == "P"? Colors.yellow[700] : Colors.grey,
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Center(
                                          child: _.estado == "F" ? Text('Finalizado',style: TextStyle(color: Colors.white),) : _.estado == "P" ? Text('Pendiente',style: TextStyle(color: Colors.white)) :Text('Sincronizado',style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                   ),
                                  
                                ],
                              ),

                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),

              SizedBox(height: 30,),

              Stack(
                children: [

                  

                  Padding(
                    padding:  EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Container(
                      //height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(child: Text('Nombres:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                Expanded(child: Text('${_.nombreCompleto}'))
                              ],
                            ),

                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(child: Text('Nº Documento:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                Expanded(child: Text('${_.numDocumento}'))
                              ],
                            ),

                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(child: Text('Sexo:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                _.sexo == "M"? Expanded(child: Text('Masculino')):Expanded(child: Text('Femenino'))
                              ],
                            ),

                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(child: Text('Dirección:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                Expanded(child: Text('${_.direccion}'))
                              ],
                            ),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(left: 10),
                    child: Container(
                      height: 30,
                      width: 200,
                      
                      decoration: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child: Text(
                          'DATOS DEL ENCUESTADO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),

            

              SizedBox(height: 20,),

              Stack(
                children: [

                  

                  Padding(
                    padding:  EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Container(
                      //height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(child: Text('Proyecto:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                Expanded(child: Text('${_.nombreProyecto}'))
                              ],
                            ),

                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(child: Text('Nombre:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                Expanded(child: Text('${_.nombreEncuesta}'))
                              ],
                            ),

                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(child: Text('Nº de preguntas:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                Expanded(child: Text('24'))
                              ],
                            ),

                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(child: Text('Descripción:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                Expanded(child: Text('${_.descripcionEncuesta}'))
                              ],
                            ),

                            //SizedBox(height: 8,),
                            /*Padding(
                              padding: EdgeInsets.only(left:10,right: 10),
                              child: Text('${_.descripcionEncuesta}'),
                            ),*/

                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(left: 10),
                    child: Container(
                      height: 30,
                      width: 200,
                      
                      decoration: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child: Text(
                          'DATOS DE LA ENCUESTA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),

              SizedBox(height: 20,),

              _.estado == "P"? Center(
                child: FlatButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Colors.green,
                        onPressed: (){

                          //_.sendDataToServer();

                        },
                        icon: Icon(FontAwesomeIcons.edit,color: Colors.white,size: 18,),
                        label: Text('Retomar ficha',style: TextStyle(color: Colors.white),)
                      ),
              )  :Center(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      
                      FlatButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Colors.green,
                        onPressed: (){

                          _.sendDataToServer();

                        },
                        icon: Icon(FontAwesomeIcons.upload,color: Colors.white,size: 18,),
                        label: Text('Subir data',style: TextStyle(color: Colors.white),)
                      ),

                      

                      _.estado == "S" ? Container() :FlatButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Colors.redAccent,
                        onPressed: (){

                          _.modalDelete();

                        },
                        icon: Icon(FontAwesomeIcons.trash,color: Colors.white,size: 18,),
                        label: Text('Eliminar',style: TextStyle(color: Colors.white),)
                      ),
                      

                      FlatButton.icon(

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Colors.blue,
                        onPressed: (){

                          

                        },
                        icon: Icon(FontAwesomeIcons.mapMarked,color: Colors.white,size: 18,),
                        label: Text('Ver tracking',style: TextStyle(color: Colors.white),)
                      )

                    ],
                  ),

                ),
              

              




            ],
          ),
        ),
        
      ),
    );
  }
}