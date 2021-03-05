import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Login/LoginController.dart';
import 'package:gsencuesta/pages/Login/CustomClip.dart';
import 'package:gsencuesta/pages/Login/Formulario.dart';
import 'package:gsencuesta/pages/Login/Logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (_) => Scaffold(
        backgroundColor: Colors.grey[200],

        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.grey[200]
            ),
            child: Stack(
              children: [

                ClipPath(
                  clipper: CustomClip(),
                  child: Container(
                    height: MediaQuery.of(context).size.height *0.6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [

                          Color.fromRGBO(10, 143, 119, 1),
                          Color.fromRGBO(25, 189, 159, 1),
                          Color.fromRGBO(0, 102, 84, 1)

                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                      )
                    ),
                  ),
                ),

                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Logo(),

                      Padding(
                        padding:  EdgeInsets.only(left: 10,right: 10),
                        child: Text(
                          'GsEncuestas',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 30
                          ),
                        ),
                      ),

                      Formulario(),
                      SizedBox(height: 30,),

                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Text(
                          'Aún no cuenta con un usuario?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'
                          ),
                        )
                      ),
                      SizedBox(height: 10,),

                      GestureDetector(
                        onTap: (){

                          _.navigateToRegisterUser();

                        },
                        child: Text(
                          'Registrarme',
                          style: TextStyle(
                            color: Color.fromRGBO(10, 143, 119, 1),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 18
                          ),
                        ),
                      )

                    ],
                  )
                )

              ],
            )
          ),
        )
        
        
        
        
        
        
        
        
        
        /*SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(child: Container()),
              SizedBox(height: 80,),

              Container(
                height: 200,
                width: 200,
                //color: Colors.black,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://w7.pngwing.com/pngs/210/793/png-transparent-computer-icons-bs-player-media-player-survey-miscellaneous-text-logo.png')
                    ,fit: BoxFit.cover
                  )
                ),
              ),

              SizedBox(height: 30,),

              Padding(
                padding:  EdgeInsets.only(left: 20,right: 20),
                child: Form(
                  child: Column(
                    children: [

                      TextField(
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          hintText: 'Ingrese su usuario'
                        ),
                      ),

                      SizedBox(height: 20,),

                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.visibility,size: 20,),
                          ),
                          hintText: 'Contraseña'
                        ),
                      )

                    ],
                  ),
                ),
              ),

              Padding(
                padding:  EdgeInsets.only(left: 10,right: 10,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: Row(
                        children: [

                          Checkbox(
                            value: false,
                            onChanged: (value){},
                          ),

                          Text(
                            'Recuerdame',
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          )
                        ],
                      )
                    ),

                    Text(
                        'Olvido su contraseña?',
                        style: TextStyle(
                          color: Colors.green[600]
                        ),
                    )
                    
                    

                  ],
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){

                  _.navigateToTabs();

                },
                child: Container(
                  height: 40,
                  width: size.width*0.7,
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.black,
                    gradient: LinearGradient(
                      
                      colors: [

                        Color.fromRGBO(10, 143, 119, 1),
                        Color.fromRGBO(25, 189, 159, 1),
                        Color.fromRGBO(0, 102, 84, 1)

                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,

                    )
                  ),
                  child: Center(
                    child: Text('Login'),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              GestureDetector(
                onTap: (){
                  _.navigateToRegisterUser();
                },
                child: Container(
                  height: 40,
                  width: size.width*0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:Border.all(
                      color:  Color.fromRGBO(0, 102, 84, 1)
                    )
                  ),
                  child: Center(
                    child: Text('Registrarse',style: TextStyle(color: Color.fromRGBO(0, 102, 84, 1) ),),
                  ),
                ),
              ),

            ],
          ),
        )*/


      ),
    );
  }
}