import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Profile/ProfileController.dart';
import 'package:gsencuesta/pages/Login/LoginPage.dart';
import 'package:gsencuesta/pages/MisEncuestas/MisEncuestasPage.dart';

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
        body: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding:  EdgeInsets.only(left: 20,right: 20,top: 20),
                  child: Row(
                    children: [
                      

                      CircleAvatar(
                        radius: 30,
                        backgroundImage:  _.photoBase64 == null || _.photoBase64 == "" ? AssetImage('assets/images/nouserimage.jpg') : MemoryImage(_.photoBase64)  //NetworkImage('https://static01.nyt.com/images/2017/05/07/arts/07GAL-GADOTweb/07GAL-GADOTweb-articleLarge.jpg?quality=75&auto=webp&disable=upscale'),
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
                    
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        
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

                                  Expanded(child: Text(_.encuestasFinalizadas)),
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
                    ),

                    /*GestureDetector(
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
                    ),*/

                    GestureDetector(
                      onTap: (){
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
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: Text('Datos adicionales',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 12,),
                

                Expanded(
                  child: Padding(
                    padding:  EdgeInsets.only(left: 8,right: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 12,),
                            ListTile(
                              leading: Icon(Icons.person_outline,color: Color.fromRGBO(0, 102, 84, 1),),
                              title: Text(
                                'Perfil',
                                style: TextStyle(fontSize: 14),
                              ),
                              subtitle: Text('${_.perfil}',style: TextStyle(fontSize: 12),),
                              
                            ),
                            SizedBox(height: 12,),
                            ListTile(
                              leading: Icon(Icons.badge,color: Color.fromRGBO(0, 102, 84, 1),),
                              title: Text(
                                'Nro de documento',
                                style: TextStyle(fontSize: 14),
                              ),
                              subtitle: Text('${_.nroDocumento}',style: TextStyle(fontSize: 12),),
                              
                            ),
                            Divider(),
                            SizedBox(height: 12,),
                            ListTile(
                              leading: Icon(Icons.email,color: Color.fromRGBO(0, 102, 84, 1),),
                              title: Text(
                                'Correo electronico',
                                style: TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                _.correoElectronico == "" || _.correoElectronico == null || _.correoElectronico =="null" ? 'No registrado' :'${_.correoElectronico}',
                                style: TextStyle(fontSize: 12),
                              ),
                              
                            ),
                            
                            Divider(),
                            SizedBox(height: 12,),
                            ListTile(
                              leading: Icon(Icons.calendar_today,color: Color.fromRGBO(0, 102, 84, 1),),
                              title: Text(
                                'Fecha alta',
                                style: TextStyle(fontSize: 14),
                              ),
                              subtitle: Text('${_.fechaAlta}',style: TextStyle(fontSize: 12),),
                              
                            ),
                            Divider(),
                          ],
                        ),
                      ),
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