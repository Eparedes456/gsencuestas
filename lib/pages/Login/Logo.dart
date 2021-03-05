import 'package:flutter/material.dart';


class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Padding(
          padding:  EdgeInsets.only(top: 0),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              height: 180,
              width: 200,
              //color: Colors.indigo,
              /*decoration: BoxDecoration(
                color: Colors.indigo,
                image: DecorationImage(
                  image: NetworkImage('https://img.icons8.com/clouds/2x/survey.png'),
                  fit: BoxFit.cover
                )
              ),*/
              child: Image(
                image: AssetImage('assets/images/survey-logo.png'),
                fit: BoxFit.contain,
              ),

            ),
          ),
        )

      ],
      
    );
  }
}