import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Profile/ProfileController.dart';
import 'package:gsencuesta/pages/Login/LoginPage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (_)=> Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Perfil'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding:  EdgeInsets.only(left: 20,right: 20,top: 20),
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
                            _.userName,
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

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  Container(
                    
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding:  EdgeInsets.only(left: 5,right: 5,top: 8),
                          child: Row(
                            children: [

                              Expanded(child: Text('15')),
                              Expanded(child: Icon(Icons.east))

                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        Padding(
                          padding:  EdgeInsets.only(left: 5),
                          child: Text(
                            'Encuestas realizadas',
                            style: TextStyle(
                              color: Color.fromRGBO(67, 81, 99, 1),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                        SizedBox(height: 8,),

                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: (){

                      _.navigateToEditProfile();

                    },
                    child: Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Icon(
                            Icons.account_circle,
                            size: 35,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8,),
                          Text(
                            'Editar Datos',
                            style: TextStyle(
                              color: Color.fromRGBO(67, 81, 99, 1),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700
                            ),
                          )


                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){

                      /*Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (BuildContext context) => LoginPage()), 
                        (route) => false
                      );*/

                      _.logout();

                    },
                    child: Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Icon(
                            Icons.power_settings_new,
                            size: 35,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8,),
                          Text(
                            'Cerrar Sesion',
                            style: TextStyle(
                              color: Color.fromRGBO(67, 81, 99, 1),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700
                            ),
                          )


                        ],
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20,),

              Padding(
                padding:  EdgeInsets.only(left: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text('Leyenda: '),

                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.amber[600],
                    ),

                    Text('Pendiente'),
                    

                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.green,
                    ),

                    Text('Subido')
                    
                  ],
                ),
              ),

              SizedBox(height: 20,),

              Padding(
                padding:  EdgeInsets.only(left: 20),
                child: Text(
                  'Encuestas realizadas',
                  style: TextStyle(
                    color: Color.fromRGBO(67, 81, 99, 1),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount:  5,
                  itemBuilder: (context,index){

                    return Stack(
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

                                          Row(
                                            children: [

                                              Expanded(
                                                child: Text(
                                                  'Nombre de la encuesta',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),

                                              CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.green,
                                              )
                                            ],
                                          ),


                                          Text(
                                            'eadable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for  will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).',
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
                                    imageUrl: 'https://t2.ev.ltmcdn.com/es/posts/8/3/1/fotos_de_paisajes_naturales_138_orig.jpg',
                                    placeholder: (context, url) => Image(image: AssetImage('assets/images/loading.gif'),),
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
                              )

                            ],
                          );

                  },
                ),
              )

              /*Container(
                  height: size.height,
                  child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context,index){

                          return Padding(
                            padding:  EdgeInsets.only(left: 20,right: 20),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12,),
                                  Padding(
                                    padding:  EdgeInsets.only(left: 10,right: 10),
                                    child: Row(
                                      children: [

                                        Container(
                                          height: 80,
                                          width: 80,
                                          //color: Colors.black,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage('https://vancouver.ca/images/cov/feature/corp-plan-landing.jpg')
                                              ,fit: BoxFit.cover
                                            )
                                          ),
                                        ),
                                        SizedBox(width: 12,),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Text(
                                                'Titulo de la encuesta',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700
                                                ),
                                              ),

                                              Text(
                                                'Titulo de la s aasasassadadf sdsasdfasdfasdfasdadsfsdfsdfdfsdf',
                                                style: TextStyle(
                                                  color: Colors.grey
                                                ),
                                                textAlign: TextAlign.justify,
                                              )

                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12,),

                                ],
                              ),
                            ),
                          );

                        }
                      ),
                ),*/


            ],
          ),
        ),
        
      ),
    );
  }
}