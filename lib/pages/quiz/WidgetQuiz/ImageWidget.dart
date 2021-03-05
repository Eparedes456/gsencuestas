

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Quiz/QuizController.dart';
import 'package:get/get.dart';

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      init: QuizController(),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Container(
          width: double.infinity,
          child: Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding:  EdgeInsets.only(top: 20,left: 10,right: 10),
                  child: Text(
                    'Sube imagenes',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      fontSize: 16
                    ),
                  ),
                ),

                SizedBox( height: 20,),

                Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10),
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        _.pickImage();
                      },
                      child: _.imagepath == null ? Container(
                        height: 300,
                        width: double.infinity,
                        //color: Colors.black,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://superwalter.com.ar/wp-content/uploads/2020/10/no-photo-available.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ) : Container(
                        height: 300,
                        width: double.infinity,
                        child: Image.file(_.imagepath,fit: BoxFit.contain,),
                      ),
                    ),
                  ),
                ),

                SizedBox( height: 20,),



              ],
            ),
          )
        ),
      ),
    );
  }
}