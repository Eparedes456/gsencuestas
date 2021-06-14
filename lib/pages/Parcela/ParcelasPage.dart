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
            'Lista de beneficiarios con',
            style: TextStyle(
              fontSize: 18
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: (){
                _.showModalSearch();
              }
            )
          ],
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
        
        
        :  _.loading == false && _.hayParcela == true ? ListView.builder(
          itemCount: _.listParcela.length,
          itemBuilder: (context,i){
            
            
            return Column(
              children: [

                Padding(
                  padding:  EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: MemoryImage(_.listParcela[i].foto),
                    ),
                    title: Text(
                      _.listParcela[i].nombreCompleto,
                      style: TextStyle(
                        fontSize: 14
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Descripcion : ${_.listParcela[i].descripcion}',style: TextStyle(fontSize: 12),),
                        Text('Area : ${_.listParcela[i].area} m2',style: TextStyle(fontSize: 12),)
                      ],
                    ),
                    onTap: (){
                      _.navigateToBeneficiarioParcela(_.listParcela[i].idSeccion.toString(), _.listParcela);
                    },
                    /*trailing: IconButton(
                      icon: Icon(Icons.more_vert), 
                      onPressed: (){
                        _.bottomSheet();
                      }
                    ),*/
                  ),
                ),
                Divider()
              ],
            );
          }
        ): Center(child: Text('No hay parcelas registradas'),),

        /*floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(0, 102, 84, 1),
          onPressed: (){
            //_.newParcela();
            _.showModalSearch();
          },
          child: Icon(Icons.add),
        ),*/
      ),
    );
    
  }
}