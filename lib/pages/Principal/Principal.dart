import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Principal/PrincipalController.dart';
import 'package:gsencuesta/model/Proyecto/ProyectoModel.dart';


class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return GetBuilder<PrincipalController>(
      init: PrincipalController(),
      builder: (_) => Scaffold(
        
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(  
                  height: size.height*0.3,
                  width: double.infinity,
                  //color: Color.fromRGBO(0, 102, 84, 1),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [

                        Color.fromRGBO(10, 143, 119, 1),
                        Color.fromRGBO(25, 189, 159, 1),
                        Color.fromRGBO(0, 102, 84, 1)

                      ]
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SafeArea(child: Container(),),
                      Center(
                        child: Container(
                          
                          height: 40,
                          child: Image.asset('assets/images/logo_gsencuesta_inverse.png')
                        ),
                      ),

                      Padding(
                        padding:  EdgeInsets.only(left: 20,top: 20),
                        child: Text(
                          'Busca las encuesta que tenemos para ti',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins'
                          ),
                        ),
                      ),

                      SizedBox(height: 20,),

                      Padding(
                        padding:  EdgeInsets.only(left: 20,right: 20),
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                              ),
                              hintText: 'Buscar',
                              hintStyle: TextStyle(
                                fontSize: 14
                              ),
                              suffixIcon: Icon(Icons.search)
                            ),
                          )
                        ),
                      )


                    ],
                  ),
              ),
              SizedBox(height: 20,),

              _.isLoading == false?  Expanded(
                 
                  child: Center(

                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                    
                  ),
              ):

              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: _.proyectos.length,
                    itemBuilder: (BuildContext context, index){

                      var proyectoId = _.proyectos[index].idProyecto;
                      //return Text('hola');
                      return buildCard(
                        _, 
                        context, 
                        Color.fromRGBO(67, 197, 217, 1), 
                        _.proyectos[index].nombre,
                        _.proyectos[index].nombre, 
                        _.proyectos[index].logo, 
                        _.proyectos[index].nombre,
                        proyectoId.toString(),
                        _.proyectos[index]
                      );

                    }
                  ),
              )
              


            ],
          ),
        )
        
        
        
      ),
    );
  }
}






buildCard(PrincipalController _ , BuildContext context, Color color, String titulo, String subtitle, String  imageUrl,String name,String idProyecto, ProyectoModel proyectoData){
  return Padding(
    padding:  EdgeInsets.only(left: 20,right: 20,bottom: 20),
    child: Stack(
      children: [

        GestureDetector(
          onTap: (){
            _.navigateToProyecto(proyectoData);
            print(idProyecto);
            print(proyectoData);
            //print("holi");

          },
          child: Stack(
            children: [

              Container(
                width: double.infinity,
                height: 218.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.6),
                  //color: Colors.black87,
                ),
                child: ClipRRect(
                  borderRadius:  BorderRadius.circular(9.6),
                  child: CachedNetworkImage(
                    
                    imageUrl: "$imageUrl",
                    
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

                  ),
                ),
              ),

              Positioned(
                bottom: 19.2,
                left: 19.2,
                right: 19.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaY: 19.2,sigmaX: 19.2
                    ),
                    child: Container(
                      //height: 36,
                      padding: EdgeInsets.only(
                        left: 16.72,right: 14.4
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$name',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                        ),
                      ),
                    ),
                  ),
                )
              )


            ],
          )
        ),




      



      ],
    )
  );

}

