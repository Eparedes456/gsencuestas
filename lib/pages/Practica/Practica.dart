import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/practica/PracticaController.dart';

class Practica extends StatelessWidget {
  const Practica({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PracticaController>(
      init: PracticaController(),
      builder: (_)=> Scaffold(
        body: Center(child:Text('HOLA')),
        
      ),
    );
  }
}