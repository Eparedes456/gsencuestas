import 'package:flutter/material.dart';

class MultipleSelectPage extends StatelessWidget {
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
                          'its posible be the big man in this world?',
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

                            return Row(
                              children: [
                                
                                Checkbox(
                                  value: true,
                                  onChanged: (value){
                                     print(value);
                                  },
                                 
                                ),
                                
                                Text('Respuesta $index')
                              ],
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