import 'package:flutter/material.dart';

class RegisterUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarme'),
      ),
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding:  EdgeInsets.only(left: 20,top: 20),
              child: Text(
                'Ingrese sus datos',
                style: TextStyle(
                  color: Color.fromRGBO(67, 81, 99, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 20
                ),
              ),
            ),

            Padding(

              padding: EdgeInsets.only(left: 20,right: 20,top: 12),
              child: Text(
                'Para poder acceder a la aplicación es necesario que tenga una cuenta, necesitamos los siguientes datos basicos que se muestra a continuación.',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.justify,
              ),

            ),


            SizedBox(height: 20,),


            Padding(
              padding:  EdgeInsets.only(left: 20,right: 20),
              child: Form(
                child: Column(
                  children: [

                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Nombre y apellidos'
                      ),
                    ),
                    SizedBox(height: 20,),
                    
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Usuario'
                      ),
                    ),
                    SizedBox(height: 20,),
                    
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Contraseña'
                      ),
                    ),
                    SizedBox(height: 20,),
                    
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Oficina'
                      ),
                    ),
                    SizedBox(height: 40,),

                    Container(
                      height: 45,
                      width: double.infinity,
                     
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(10, 143, 119, 1),
                        borderRadius: BorderRadius.circular(20)
                      ),

                      child: Center(
                        child: Text('Registrar',style: TextStyle(color: Colors.white,fontFamily: 'Poppins',fontSize: 16),),
                      ),
                    )

                  ],
                ),
              ),
            )

          ],

        ),

      ),
      
    );
  }
}