import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar datos'),
      ),

      body: SingleChildScrollView(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 30,),

            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://organicthemes.com/demo/profile/files/2018/05/profile-pic.jpg'),
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Text('Nombre Completo'),
            ),

            Padding(
              padding:  EdgeInsets.only(left: 20,right: 20,top: 8),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  hintText: 'Nombre del personal'
                ),
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Text('Apellidos'),
            ),

            Padding(
              padding:  EdgeInsets.only(left: 20,right: 20,top: 8),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  hintText: 'Apellido materno y paterno'
                ),
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Text('Genero'),
            ),

            Padding(
              padding:  EdgeInsets.only(top: 8),
              child: Row(),
            )
            



          ],
        )

      ),
      
    );
  }
}