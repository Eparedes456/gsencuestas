
import 'package:flutter/material.dart';

class TextFieldPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 5,
          child: Column(
            children: [

              Padding(
                padding:  EdgeInsets.only(top: 20,left: 10,right: 10),
                child: Text(
                  'its posible be the big man in this worldsasasasasasasa?',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    fontSize: 16
                  ),
                ),
              ),

              SizedBox( height: 20,),

              Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Ingrese su respuesta'
                  ),
                ),
              
              ),

              SizedBox( height: 20,),



            ],
          ),
        )
      ),
    );
  }
}