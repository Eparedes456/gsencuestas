import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/controller/Login/RegisterController.dart';

class RegisterUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Registrarme'),
        ),
        body: SingleChildScrollView(

          child: Form(
            key: _.loginFormKey,
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


                SizedBox(height: 10,),


                Padding(
                  padding:  EdgeInsets.only(left: 20,right: 20),
                  child: Form(
                    child: Column(
                      children: [

                        TextFormField(
                          controller: _.nombreController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Nombre'
                          ),
                          validator: (value){
                            if(value.length < 3){
                              return "El nombre tiene que ser mayor a 3 caracteres";
                            }
                          },
                        ),
                        SizedBox(height: 20,),

                        TextFormField(
                          controller: _.apellidoPaternoController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Apellidos paterno'
                          ),
                          validator: (value){
                            if(value.length < 3){
                              return "El apellido paterno tiene que ser mayor a 3 caracteres";
                            }
                          },
                        ),
                        SizedBox(height: 20,),

                        TextFormField(
                          controller: _.apellidoMaternoController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Apellidos materno'
                          ),
                          validator: (value){
                            if(value.length < 3){
                              return "El apellido materno tiene que ser mayor a 3 caracteres";
                            }
                          },
                        ),
                        SizedBox(height: 20,),

                        TextFormField(
                          controller: _.dniController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Número  de documento'
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: false
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 8,
                          validator: (value){
                            if(value.length > 8){
                              return "Ingrese el número de documento máximo 8 caracteres";
                            }else if( value.length < 8){
                              return "Ingrese el número de documento máximo 8 caracteres";
                            }
                          },
                        ),
                        SizedBox(height: 20,),


                        TextFormField(
                          controller: _.correoController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Correo electrónico'
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value.isEmail){

                            }else{
                              return "No es un correo valido";
                            }
                          },
                        ),
                        SizedBox(height: 20,),
                        
                        TextFormField(
                          controller: _.usuarioController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Usuario'
                          ),
                          validator: (value){
                            if(value.length < 3){
                              return "El nombre de usuario tiene que ser mayor a 3 caracteres";
                            }
                          },
                        ),
                        SizedBox(height: 20,),
                        
                        TextFormField(
                          controller: _.contrasenaController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Contraseña'
                          ),
                          validator: (value){
                            if(value.length < 3){
                              return "La contraseñña tiene que ser mayor a 3 caracteres";
                            }
                          },
                        ),
                        //SizedBox(height: 20,),
                        
                        
                        SizedBox(height: 40,),

                        GestureDetector(
                          onTap: (){
                            _.saveUsuario();
                          },
                          child: Container(
                            height: 45,
                            width: double.infinity,
                           
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(10, 143, 119, 1),
                              borderRadius: BorderRadius.circular(20)
                            ),

                            child: Center(
                              child: Text('Registrar',style: TextStyle(color: Colors.white,fontFamily: 'Poppins',fontSize: 16),),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),

                      ],
                    ),
                  ),
                )

              ],

            ),
          ),

        ),
        
      ),
    );
  }
}