import 'package:flutter/material.dart';


class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Padding(
          padding:  EdgeInsets.only(top: 8),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              //height: ,
              width: MediaQuery.of(context).size.width*0.65,
              
              child: Image(
                image: AssetImage('assets/images/splash.png'),
                fit: BoxFit.cover,
              ),

            ),
          ),
        )

      ],
      
    );
  }
}