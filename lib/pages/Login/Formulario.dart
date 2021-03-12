import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/controller/Login/LoginController.dart';


class Formulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (_) => Container(

        height: MediaQuery.of(context).size.height * 0.48,
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding:  EdgeInsets.only(top: 0),
                child: Text(
                  'Ingrese sus datos',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w800,
                    fontSize: 20
                  ),
                ),
              ),

              SizedBox(height: 20,),
              
              TextField(
                controller: _.username,
                decoration: InputDecoration(
                  hintText: 'Usuario',
                  suffixIcon: Icon(Icons.person)
                ),
              ),
              SizedBox(height: 20,),
              
              TextField(
                obscureText: true,
                controller: _.password,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  suffixIcon: Icon(Icons.visibility)
                ),
              ),

              SizedBox(height: 40,),

              GestureDetector(
                onTap: (){
                  print('holi');
                  //_.navigateToTabs();
                  _.login();
                  //_.loginApi();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(10, 143, 119, 1),
                    borderRadius: BorderRadius.circular(25)
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
              )

            ],
          ),
        ),
        
      ),
    );
  }
}