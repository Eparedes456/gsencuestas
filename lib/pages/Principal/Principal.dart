import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Principal/PrincipalController.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';
import 'package:gsencuesta/pages/Practica/Practica.dart';

class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<PrincipalController>(
      init: PrincipalController(),
      builder: (_) => WillPopScope(
        onWillPop: () {
          _.exit();
        },
        child: Scaffold(
            body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //height: size.height*0.3,

                width: double.infinity,
                color: Color.fromRGBO(0, 102, 84, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SafeArea(child: Container(),),
                    SafeArea(
                      child: Center(
                        child: Container(
                            width: size.width * 0.6,
                            child: Image.asset(
                                'assets/images/logo_gsencuesta_inverse.png')),
                      ),
                    ),

                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 8, right: 10),
                        child: Text(
                          'Navega en las encuestas que tienes asignados',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.22,
                //color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: _.isLoading == true
                      ? Container()
                      /*Center(
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                    )*/
                      : _.haydata == false
                          ? Center(child: Text('No tiene proyectos asignados'))
                          : Row(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _.proyectos.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        var proyectoId =
                                            _.proyectos[index].idProyecto;
                                        var name = _.proyectos[index].nombre;
                                        ProyectoModel proyectoData =
                                            _.proyectos[index];

                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 10, bottom: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              //_.navigateToProyecto(proyectoData);
                                              _.loadEncuestas(proyectoId, name);
                                              if (name ==
                                                  "Encuestas estáticas") {
                                                _.validarEcuestaDiEst(
                                                    true, false, 0, "");
                                              } else {
                                                _.validarEcuestaDiEst(false,
                                                    true, proyectoId, name);
                                              }
                                            },
                                            child: Stack(
                                              children: [
                                                TweenAnimationBuilder(
                                                  builder:
                                                      (context, value, child) {
                                                    return Transform.translate(
                                                      offset: Offset(
                                                          value * 50, 0.0),
                                                      child: child,
                                                    );
                                                  },
                                                  tween: Tween(
                                                      begin: 1.0, end: 0.0),
                                                  curve: Curves.bounceOut,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  child: Container(
                                                    height: 170,
                                                    width: size.width * 0.55,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9.6),
                                                      //color: Colors.black87,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9.6),
                                                      child: CachedNetworkImage(
                                                        imageUrl: proyectoId ==
                                                                3000
                                                            ? "https://www.upo.es/diario/wp-content/uploads/2020/11/the-conversation_20201116-750x459.jpg"
                                                            : "https://dev.regionsanmartin.gob.pe/gsencuesta/api/v1/recurso/proyecto/$proyectoId", //"$imageUrl",

                                                        placeholder: (context,
                                                                url) =>
                                                            Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        /*errorWidget: (context, url, error) => Center(

                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [

                                                    Icon(Icons.error,color: Colors.red,),
                                                    SizedBox(height: 8,),
                                                    Text('Lo sentimos no pudimos cargar la imagen')
                                                  ],
                                                )
                                              ),*/
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image(
                                                          image: name ==
                                                                  "Encuestas estáticas"
                                                              ? AssetImage(
                                                                  'assets/images/encuesta.png')
                                                              : AssetImage(
                                                                  'assets/images/noimage2.png'),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: 19.2,
                                                    left: 19.2,
                                                    right: 19.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.8),
                                                      child: BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaY: 19.2,
                                                                sigmaX: 19.2),
                                                        child: Container(
                                                          //height: 36,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16.72,
                                                                  right: 14.4),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '$name',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                ),
              ),
              _.isLoading == true
                  ? Container()
                  : SizedBox(
                      height: 8,
                    ),
              _.isLoading == true
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Lista de encuestas',
                        style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1),fontWeight: FontWeight.bold),
                      ),
                    ),
              _.isLoading == true
                  ? Expanded(
                      child: Center(
                          child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green),
                    )))
                  : _.presionadoEstatica == false &&
                          _.presionadoDinamica == false
                      ? Expanded(
                          child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Color.fromRGBO(0, 102, 84, 1),
                                size: 50,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 8),
                                child: Text(
                                  'Presione en la parte superior para mostrar las encuestas correspondientes.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ))
                      : _.presionadoEstatica == false &&
                              _.presionadoDinamica == true
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: _.listEncuesta.length,
                                  itemBuilder: (context, index) {
                                    print(_.listEncuesta[index].idEncuesta);
                                    print(
                                        'https://dev.regionsanmartin.gob.pe/gsencuesta/api/v1/recurso/encuesta/${_.listEncuesta[index].idEncuesta}');
                                    return GestureDetector(
                                      onTap: () {
                                        _.navigateToEncuesta(_.listEncuesta[index]);
                                        //Get.to(Practica());
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                40, 5, 20.0, 5),
                                            height: 170,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  100, 20, 20, 20),
                                              child: ListView(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        _.listEncuesta[index]
                                                            .titulo,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        _.listEncuesta[index]
                                                            .descripcion,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600]),
                                                        textAlign:
                                                            TextAlign.justify,
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  width: 110,
                                                  imageUrl:
                                                      "https://dev.regionsanmartin.gob.pe/gsencuesta/api/v1/recurso/encuesta/${_.listEncuesta[index].idEncuesta}", //'${_.encuestas[index].logo}',
                                                  placeholder: (context, url) =>
                                                      Image(
                                                    image: AssetImage(
                                                        'assets/images/loading.gif'),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image(
                                                    image: AssetImage(
                                                        'assets/images/noimage2.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : Expanded(
                              child: ListView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 0),
                                  child: Card(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: ListTile(
                                          title: Text('Gestión de Parcelas'),
                                          subtitle: Text(
                                              'Administración de las Parcelas por encuestado, permite registrar nuevas coordenadas y crear polígonos por parcela'),
                                          leading: Icon(Icons.map),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey,
                                          ),
                                          onTap: () {
                                            _.navigateToParcela();
                                          },
                                        )),
                                  ),
                                )
                              ],
                            ))
            ],
          ),
        )),
      ),
    );
  }
}

buildCard(
    PrincipalController _,
    BuildContext context,
    Color color,
    String titulo,
    String subtitle,
    String imageUrl,
    String name,
    String idProyecto,
    ProyectoModel proyectoData) {
  return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Stack(
        children: [
          GestureDetector(
              onTap: () {
                _.navigateToProyecto(proyectoData);
                print(idProyecto);
                print(proyectoData);
                //print("holi");
              },
              child: Stack(
                children: [
                  TweenAnimationBuilder(
                    tween: Tween(begin: 1.0, end: 0.0),
                    curve: Curves.bounceOut,
                    duration: Duration(seconds: 1),
                    child: Container(
                      width: double.infinity,
                      height: 218.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.6),
                        //color: Colors.black87,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9.6),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://dev.regionsanmartin.gob.pe/gsencuesta/api/v1/recurso/proyecto/$idProyecto", //"$imageUrl",

                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Lo sentimos no pudimos cargar la imagen')
                            ],
                          )),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(value * 50, 0.0),
                        child: child,
                      );
                    },
                  ),
                  Positioned(
                      bottom: 19.2,
                      left: 19.2,
                      right: 19.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 19.2, sigmaX: 19.2),
                          child: Container(
                            //height: 36,
                            padding: EdgeInsets.only(left: 16.72, right: 14.4),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$name',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ))
                ],
              )),
        ],
      ));
}
