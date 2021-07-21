import 'dart:convert';
import 'dart:typed_data';

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
          title: Text(
            'Lista de encuestados con',
            style: TextStyle(
              fontSize: 18
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(0.0,20.0),
            child: Column(
              children: [
                Text('Parcelas',style: TextStyle(color: Colors.white,fontSize: 18),),
                SizedBox(height: 12,)
              ],
            ),
          ),
        ),

        body: _.loading == true && _.hayParcela ==  false  ? Center(child: CircularProgressIndicator(),) 
        
        
        :    _.loading == false && _.hayParcela == true ? ListView.builder(
          itemCount: _.listParcela.length,
          itemBuilder: (context,i){

            Uint8List _photoBase64;
            if(_.listParcela[i].foto !=null){
              _photoBase64 = base64Decode(_.listParcela[i].foto);
            }
            
            
            return Column(
              children: [

                Padding(
                  padding:  EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: _.listParcela[i].foto == null || _.listParcela[i].foto == "null" || _.listParcela[i].foto == "" ? AssetImage('assets/images/nouserimage.jpg') : MemoryImage(_photoBase64),
                    ),
                    title: Text(
                      _.listParcela[i].nombre +  " " + _.listParcela[i].apellidoPaterno + " " + _.listParcela[i].apellidoMaterno,
                      style: TextStyle(
                        fontSize: 14
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Direccion : ${_.listParcela[i].direccion}',style: TextStyle(fontSize: 12),),
                        Text('telefono : ${_.listParcela[i].telefono}',style: TextStyle(fontSize: 12),)
                      ],
                    ),
                    onTap: (){
                      print(_.listParcela[i].idEncuestado);
                      _.navigateToBeneficiarioParcela(_.listParcela[i].idEncuestado.toString());
                    },
                  
                  ),
                ),
                Divider()
              ],
            );
          }
        ): Center(child: Text('No hay encuestados asigandos a este usuario'),),
      ),
    );
    
  }
}