import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/controller/Login/LoginController.dart';


class Formulario extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (_) => Container(

        //height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [

            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0
            )

          ]
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20,right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                        padding:  EdgeInsets.only(left: 10,right: 10,top: 10),
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            
                            width: size.width*0.5,
                            child: Image(
                              image: AssetImage('assets/images/logo_gsencuestas.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )
                      ),

              /*Padding(
                padding:  EdgeInsets.only(top: 10),
                child: Text(
                  'Ingrese sus datos',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w800,
                    fontSize: 20
                  ),
                ),
              ),*/

              SizedBox(height: 10,),
              
              TextField(
                controller: _.username,
                decoration: InputDecoration(
                  hintText: 'Usuario',
                  suffixIcon: Icon(Icons.person)
                ),
              ),
              SizedBox(height: 20,),
              
              TextField(
                obscureText: _.show,
                controller: _.password,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  suffixIcon: GestureDetector(
                    child: Icon(
                      _.show ?  Icons.visibility : Icons.visibility_off
                    ),
                    onTap: (){
                      _.ver();
                    },
                  )
                ),
              ),

              SizedBox(height: 40,),

              GestureDetector(
                onTap: (){
                  
                  //_.navigateToTabs();
                  _.login();
                  //_.loginApi();
                },
                child: Container(
                  width: size.width*0.7,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(10, 143, 119, 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    'Ingresar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins'
                    ),
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
              SizedBox(height: 20,),

            ],
          ),
        ),
        
      ),
    );
  }
}