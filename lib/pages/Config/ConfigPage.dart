import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Config/ConfigController.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfigController>(
      init: ConfigController(),
      builder: (_) =>  WillPopScope(
        onWillPop: (){
          _.exit();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Herramientas',style: TextStyle(fontFamily: 'Poppins'),),
            leading: Container(),
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //buildCard('Descargar data',FontAwesomeIcons.cloudDownloadAlt,false,_),
                buildCard('Subir encuestas',"" ,FontAwesomeIcons.cloudUploadAlt,true,_,"1"),
                buildCard('Descargar actualizaciones y datos adicionales',"" ,FontAwesomeIcons.cloudDownloadAlt,false,_,"2"),
                /*Padding(
                  padding:  EdgeInsets.only(left: 20,top: 10),
                  child: Text('DRASAM',style: TextStyle(
                    fontSize: 18
                  ),),
                ),*/
                //buildCard("Gestión de Parcelas","Administración de las Parcelas por encuestado, permite registrar nuevas coordenadas y crear polígonos por parcela" ,Icons.map, false, _,"")
                //buildCard('Cambiar rango Gps',FontAwesomeIcons.locationArrow)

              ],
            ),
          ),
        ),
      ),
    );
  }
}


buildCard(String contenido,String subtitle ,IconData icon, bool upload,ConfigController _, String estado){

  return Padding(
    padding: EdgeInsets.only(left: 10,right: 10,top: 20),
    child: Card(
      child: Padding(
        padding:  EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
        child: ListTile(
          title: Text(contenido),
          subtitle: Text(subtitle),
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
          ) : Icon(Icons.arrow_forward_ios,color: Colors.grey,),
          onTap: (){

            if(upload){

              if(_.cantidadFinalizadas == "" || _.cantidadFinalizadas == "0"){

                _.modal(false,false);

              }else{
                _.modal(false,true);

              }
              

            }else{
              if(estado == ""){
                _.navigateToParcela();
              }else{
                print('hola');
                //_.downloadAllDataToServer();
                _.mostrarMensajeModal();
              }

              

            }

          },
        )
      ),
    ),
  );

}