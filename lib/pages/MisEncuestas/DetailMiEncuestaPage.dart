import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/DetalleFicha/DetalleFichaController.dart';
import 'dart:io' show Platform;

import 'package:gsencuesta/pages/Maps/GoogleMaps.dart';

class DetailMiEncuestaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetalleFichaController>(
      init: DetalleFichaController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Detalle Ficha'),
          leading: IconButton(
            icon: Platform.isAndroid
                ? Icon(Icons.arrow_back)
                : Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (_.estado != "F" && _.estado != "P") {
                Get.back(result: "SI");
              } else {
                Get.back();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  width: double.infinity,
                  //height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Container(
                        height: 115,
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(7),bottomLeft: Radius.circular(7)),
                          child: Image(
                            image: AssetImage('assets/images/encuesta.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),*/

                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //Expanded(child: Text('Nº FICHA:',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.bold),)),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Nº FICHA:',
                                          style: TextStyle(
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        //Text('${_.idFicha}')
                                      ],
                                    ),
                                  ),
                                  Expanded(child: Text('${_.idFicha}')),
                                  Expanded(
                                      child: Text('ESTADO:',
                                          style: TextStyle(
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.bold))),
                                  Container(
                                    height: 25,
                                    //width: 200,
                                    decoration: BoxDecoration(
                                        color: _.estado == "F"
                                            ? Colors.redAccent
                                            : _.estado == "P"
                                                ? Colors.yellow[700]
                                                : Colors.grey,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Center(
                                        child: _.estado == "F"
                                            ? Text(
                                                'Finalizado',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : _.estado == "P"
                                                ? Text('Pendiente',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                                : Text('Sincronizado',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text('F.Inicio:',
                                          style: TextStyle(
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      child: Text(
                                    '${_.fechaInicio}',
                                    style: TextStyle(fontSize: 12),
                                  )),
                                  Expanded(
                                      child: Text('H.Inicio:',
                                          style: TextStyle(
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.bold))),
                                  Expanded(child: Text('${_.hora_inicio}')),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text('F.Fin:',
                                          style: TextStyle(
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      child: Text('${_.fechaFin}',
                                          style: TextStyle(fontSize: 12))),
                                  Expanded(
                                      child: Text('H.Fin:',
                                          style: TextStyle(
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.bold))),
                                  Expanded(child: Text('${_.hora_fin}')),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              _.retornoEncuesta == true
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text('F.Retorno:',
                                                style: TextStyle(
                                                    color: Colors.green[700],
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            child: Text('${_.fecha_retorno}',
                                                style:
                                                    TextStyle(fontSize: 12))),
                                        Expanded(
                                            child: Text('H.Retorno:',
                                                style: TextStyle(
                                                    color: Colors.green[700],
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Expanded(
                                            child: Text('${_.hora_retorno}')),
                                      ],
                                    )
                                  : Container(),
                              _.retornoEncuesta == true
                                  ? SizedBox(
                                      height: 5,
                                    )
                                  : Container(),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      //height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Nombres:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(child: Text('${_.nombreCompleto}'))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Nº Documento:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(child: Text('${_.numDocumento}'))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Sexo:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                _.sexo == "M"
                                    ? Expanded(child: Text('Masculino'))
                                    : Expanded(child: Text('Femenino'))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Dirección:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(child: Text('${_.direccion}'))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Container(
                      height: 30,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: Text(
                          'DATOS DEL ENCUESTADO',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      //height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Proyecto:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(child: Text('${_.nombreProyecto}'))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Nombre:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(child: Text('${_.nombreEncuesta}'))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Nº de preguntas:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(child: Text('${_.nroPreguntas}'))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Descripción:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                      height: 100,
                                      child: Text(
                                        '${_.descripcionEncuesta}',
                                        textAlign: TextAlign.justify,
                                      )),
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Ver encuesta realizada:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: MaterialButton(
                                    height: 30,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.orange,
                                    onPressed: () {
                                      _.navigateToVer();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 3.5),
                                          child: Icon(
                                            FontAwesomeIcons.clipboard,
                                            size: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          'Pulse aqui',
                                          style: TextStyle(fontSize: 13),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Container(
                      height: 30,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: Text(
                          'DATOS DE LA ENCUESTA',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      //height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  'observación:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                      //height: 100,
                                      child: Text(
                                    '${_.observacionFicha}',
                                    textAlign: TextAlign.justify,
                                  )),
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Ver imagenes:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: MaterialButton(
                                    height: 30,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.blue,
                                    onPressed: () {
                                      _.navigateToImage();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 3.5),
                                          child: Icon(
                                            FontAwesomeIcons.image,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          'Pulse aqui',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Container(
                      height: 30,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: Text(
                          'Datos ADICIONALES',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      //height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Latitud:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(child: Text('${_.latitud}'))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Longitud:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(child: Text('${_.longitud}'))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Ver recorrido:',
                                  style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    _.navigateToMaps();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 0, right: 0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Image(
                                                height: 50,
                                                image: AssetImage(
                                                    'assets/images/googlemaps.png'),
                                              ),
                                              Text('Google Maps')
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Container(
                      height: 30,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: Text(
                          'TRACKING',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _.estado == "P"
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton.icon(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.green,
                              onPressed: () {
                                //_.sendDataToServer();
                                _.navigateToRetomarEncuesta();
                              },
                              icon: Icon(
                                FontAwesomeIcons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: Text(
                                'Retomar ficha',
                                style: TextStyle(color: Colors.white),
                              )),
                          FlatButton.icon(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.redAccent,
                              onPressed: () {
                                _.modalDelete();
                              },
                              icon: Icon(
                                FontAwesomeIcons.trash,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    )
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _.estado == "S"
                              ? Container()
                              : FlatButton.icon(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.green,
                                  onPressed: () {
                                    _.sendDataToServer();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.upload,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'Subir data',
                                    style: TextStyle(color: Colors.white),
                                  )),
                          _.estado == "S"
                              ? Container()
                              : FlatButton.icon(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    _.modalDelete();
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.trash,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'Eliminar',
                                    style: TextStyle(color: Colors.white),
                                  )),
                        ],
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
