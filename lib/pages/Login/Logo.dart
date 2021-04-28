import 'package:flutter/material.dart';


class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Padding(
          padding:  EdgeInsets.only(top: 20),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              //height: 160,
              width: 280,
              
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