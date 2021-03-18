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

              SelectEncuestado(),

              /*Padding(
                padding: EdgeInsets.only(left:20,right: 20),
                child: DropDownField(
                  controller: _.encuestadoSelected,
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: 'Seleccione al encuestado',
                  enabled: true,
                  items: _.ciudades,
                  onValueChanged: (valor){

                    

                  },
                ),
              ),*/


              SizedBox(height: 20,),

              Padding(
                padding: EdgeInsets.only(left:20,right: 20),
                child: Text('Por favor tomese un selfie, como se muestra en la siguiente imagen.'),
              ),

              Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10),
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        //_.pickImage();
                      },
                      child: /*_.imagepath == null ?*/ Container(
                        height: 200,
                        width: double.infinity,
                        //color: Colors.black,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://superwalter.com.ar/wp-content/uploads/2020/10/no-photo-available.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ) 
                    ),
                  ),
              ),

              Padding(
                padding: EdgeInsets.only(left:20,right: 20),
                child: Text('Por favor tome fotos del lugar donde se esta relizando la encuesta.'),
              ),

              Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10,top: 20),
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        //_.pickImage();
                      },
                      child: /*_.imagepath == null ?*/ Container(
                        height: 200,
                        width: double.infinity,
                        //color: Colors.black,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://superwalter.com.ar/wp-content/uploads/2020/10/no-photo-available.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ) 
                    ),
                  ),
              ),

              Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10,top: 20),
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        //_.pickImage();
                      },
                      child: /*_.imagepath == null ?*/ Container(
                        height: 200,
                        width: double.infinity,
                        //color: Colors.black,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://superwalter.com.ar/wp-content/uploads/2020/10/no-photo-available.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ) 
                    ),
                  ),
              ),

              SizedBox(height: 20,)

              

            ],
          ),
        ),
        
      ),
    );
  }
}



class SelectEncuestado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FichaController>(
      init: FichaController(),
      id: 'encuestados',
      builder:(_)=> Padding(
        padding: EdgeInsets.only(left:20,right: 20),
        child: DropDownField(
          controller: _.encuestadoSelected,
          hintStyle: TextStyle(fontSize: 14),
          hintText: 'Seleccione al encuestado',
          enabled: true,
          items: _.encuestadolist,
          onValueChanged: (valor){                  

          },
        ),
      ),
    );
  }
}