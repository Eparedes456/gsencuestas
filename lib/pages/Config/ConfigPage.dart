import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Config/ConfigController.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfigController>(
      init: ConfigController(),
      builder: (_) =>  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Configuración',style: TextStyle(fontFamily: 'Poppins'),),
          leading: Container(),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [

              buildCard('Descargar data',FontAwesomeIcons.cloudDownloadAlt,false,_),
              buildCard('Subir data',FontAwesomeIcons.cloudUploadAlt,true,_),
              //buildCard('Cambiar rango Gps',FontAwesomeIcons.locationArrow)

            ],
          ),
        ),
      ),
    );
  }
}


buildCard(String contenido,IconData icon, bool upload,ConfigController _){

  return Padding(
    padding: EdgeInsets.only(left: 10,right: 10,top: 20),
    child: Card(
      child: Padding(
        padding:  EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
        child: ListTile(
          title: Text(contenido),
          leading: Icon(icon),
          trailing: upload ? Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color:  _.cantidadFinalizadas.length > 0 ? Color.fromRGBO(0, 102, 84, 1) : Colors.white
            ),
            child: Center(
              child: Text(_.cantidadFinalizadas,style: TextStyle(
                color: Colors.white
              ),),
            ),
          ) : Container(
            height: 5,width: 5,
          ),
          onTap: (){

            if(upload){

              _.modal(false);

            }else{


            }

          },
        )
      ),
    ),
  );

}