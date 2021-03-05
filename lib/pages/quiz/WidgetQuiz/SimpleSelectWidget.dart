import 'package:flutter/material.dart';

class SimpleSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Container(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [

                      Padding(
                        padding:  EdgeInsets.only(top: 20),
                        child: Text(
                          'Seleccione una opción',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            fontSize: 16
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context,index){

                            return RadioListTile(
                              value: index,
                              groupValue: 1,
                              subtitle: Text('Index $index'),
                              onChanged: (value){
                                print('Presionado : $value');
                              }
                            );
                          }
                          ),
                      ),



                    ],
                  ),
                )
              ),
            );
  }
}