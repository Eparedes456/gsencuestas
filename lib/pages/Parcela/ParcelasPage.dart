import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Parcela/Parcela1Controller.dart';

class ParcelaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Parcela1Controller>(
      init: Parcela1Controller(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Lista de parcelas'),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(0, 102, 84, 1),
          onPressed: (){
            //_.newParcela();
            _.showModalSearch();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
    
  }
}