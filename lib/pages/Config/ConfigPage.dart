import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Configuración',style: TextStyle(fontFamily: 'Poppins'),),
        leading: Container(),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            buildCard('Descargar data',FontAwesomeIcons.cloudDownloadAlt),
            buildCard('Subir data',FontAwesomeIcons.cloudUploadAlt),
            buildCard('Cambiar rango Gps',FontAwesomeIcons.locationArrow)

          ],
        ),
      ),
    );
  }
}


buildCard(String contenido,IconData icon){

  return Padding(
    padding: EdgeInsets.only(left: 10,right: 10,top: 20),
    child: Card(
      child: Padding(
        padding:  EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
        child: ListTile(
          title: Text(contenido),
          leading: Icon(icon),
        )
      ),
    ),
  );

}