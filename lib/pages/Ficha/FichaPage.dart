import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Ficha/FichaController.dart';

class FichaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FichaController>(
      init: FichaController(),
      builder: (_) => Scaffold(

        appBar: AppBar(
          title: Text('Ficha'),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding:  EdgeInsets.only(left: 20,right: 20,top: 10),
                child: Text('Estamos a punto de terminar la ficha, requerimos los siguientes datos'),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 8),
                child: Text('Encuestado'),

              ),

              Padding(
                padding: EdgeInsets.only(left:20,right: 20),
                child: DropDownField(
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: 'Seleccione al encuestado',
                ),
              )

              

            ],
          ),
        ),
        
      ),
    );
  }
}