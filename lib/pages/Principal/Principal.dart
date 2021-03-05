import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Principal/PrincipalController.dart';


class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return GetBuilder<PrincipalController>(
      init: PrincipalController(),
      builder: (_) => Scaffold(
        /*appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: Container(
            height: 40,
            child: Image.asset('assets/images/logo_gsencuesta_inverse.png')
          ),
          centerTitle: true,
          elevation: 0,
        ),*/
        drawer: Drawer(
          child: menu(_),
        ),

        body: SingleChildScrollView(
          child: Column(
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
              SizedBox(height: 30,),

              Container(
                height: size.height,
                child: ListView.builder(
                  itemCount: _.proyectos.length,
                  itemBuilder: (BuildContext context, index){

                    
                    //return Text('hola');
                    return buildCard(
                      _, 
                      context, 
                      Color.fromRGBO(67, 197, 217, 1), 
                      _.proyectos[index].nombre,
                      _.proyectos[index].nombre, 
                      _.proyectos[index].logo, 
                      _.proyectos[index].nombre,
                    );

                  }
                ),
                /*child: ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: [

                    buildCard(
                      _, 
                      context, 
                      Color.fromRGBO(67, 197, 217, 1),
                      'Ficha de Cacao','Encuesta relacionado a las parcelas y plagas.',
                      'https://concepto.de/wp-content/uploads/2018/08/cacao-e1533849112880.jpg',
                      'Proyecto De Alto Rendimiento cacao para eel mundo desde Tarapoto , San Martin.'
                    ),

                    buildCard(
                      _, 
                      context, 
                      Color.fromRGBO(67, 197, 217, 1),
                      'Ficha de Cacao','Encuesta relacionado a las parcelas y plagas.',
                      'https://cdn.shopify.com/s/files/1/0152/8230/7158/files/spanishfruitsanddelicacies01_e642f6b8-40b3-450a-bc5d-97ea052ab52b_1024x1024.jpg?v=1566818066',
                      'Proyecto Naranja'
                    ),

                    buildCard(
                      _, 
                      context, 
                      Color.fromRGBO(67, 197, 217, 1),
                      'Ficha de Cacao','Encuesta relacionado a las parcelas y plagas.',
                      'https://www.caracteristicas.co/wp-content/uploads/2018/09/cafe-2-e1578772193199.jpg',
                      'Proyecto Cafe'
                    ),

                  ],
                ),*/
              )
            ],
          ),
        )
        
      ),
    );
  }
}



menu( PrincipalController controller){

  return ListView(

    children: [

      Padding(
        padding:  EdgeInsets.only(left: 20,right: 20),
        child: Row(
          children: [
            

            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('https://static01.nyt.com/images/2017/05/07/arts/07GAL-GADOTweb/07GAL-GADOTweb-articleLarge.jpg?quality=75&auto=webp&disable=upscale'),
            ),

            Expanded(
              child: Column(
                children: [
                  
                  Text(
                    'Haltham Mohamed',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 102, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Poppins'
                    ),
                  ),
                  SizedBox(height: 8,),

                  Text(
                    'DRASAM',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700
                    ),
                  )

                ],
              ),
            )

          ],
        ),
      ),

      Padding(
        padding:  EdgeInsets.only(top: 30),
        child: Container(
          height: 5,
          color: Colors.grey[200],
        ),
      ),

      ListTile(
        leading: Icon(Icons.person),
        title: Text('Perfil'),
        onTap: (){

          controller.navigateToProfile();

        },
      ),

      ListTile(
        leading: Icon(FontAwesomeIcons.clipboard),
        title: Text('Encuestas'),
        onTap: (){

          controller.navigateToProfile();

        },
      ),

      ListTile(
        leading: Icon(FontAwesomeIcons.cocktail),
        title: Text('Reportes'),
        onTap: (){

          controller.navigateToProfile();

        },
      ),

      ListTile(
        leading: Icon(Icons.person),
        title: Text('Configuración'),
        onTap: (){

          controller.navigateToProfile();

        },
      ),

      ListTile(
        leading: Icon(Icons.sensor_door),
        title: Text('Cerrar Sesion'),
      ),
      

    ],

  );

}



buildCard(PrincipalController _ , BuildContext context, Color color, String titulo, String subtitle, String  imageUrl,String name){
  return Padding(
    padding:  EdgeInsets.only(left: 20,right: 20,bottom: 20),
    child: GestureDetector(
      onTap: (){

         _.navigateToProyecto();

      },
      child: Container(
        width: double.infinity,
        height: 218.4,
        //color: Colors.black87,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.6),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage('$imageUrl'),
          )
        ),
        child: Stack(
          children: [

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
        ),
      )
    ),
  );

}