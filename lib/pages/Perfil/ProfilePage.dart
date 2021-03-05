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
        body: SingleChildScrollView(
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
                            'Encuestas respondidas',
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

                  Container(
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

                  GestureDetector(
                    onTap: (){

                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (BuildContext context) => LoginPage()), 
                        (route) => false
                      );

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
                padding:  EdgeInsets.only(left: 20),
                child: Text(
                  'Encuestas ya respondidas',
                  style: TextStyle(
                    color: Color.fromRGBO(67, 81, 99, 1),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),

              Container(
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
                ),


            ],
          ),
        ),
        
      ),
    );
  }
}