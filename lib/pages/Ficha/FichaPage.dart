
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

              

              

              SizedBox(height: 20,),

              Padding(
                padding: EdgeInsets.only(left:20,right: 20),
                child: Text('Por favor tomese un selfie, como se muestra en la siguiente imagen.'),
              ),

              Padding(
                padding: EdgeInsets.only(left:20,right: 20,top: 12),
                child: TextField(
                  controller: _.controllerobservacion,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    labelText: 'Observación'
                  ),
                ),
              ),

              Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10,top: 20),
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        _.pickImage();
                      },
                      child: _.imagepath == null ? Container(
                        height: 200,
                        width: 800,
                        //color: Colors.black,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/no-image.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ): Container(
                        height: 300,
                        width: double.infinity,
                        child: Image.file(_.imagepath,fit: BoxFit.cover,),
                      ),
                    ),
                  ),
              ),

              Padding(
                padding: EdgeInsets.only(left:20,right: 20,top: 20),
                child: Text('Por favor tome fotos del lugar donde se esta relizando la encuesta.'),
              ),

              Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10,top: 20),
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        _.pickImage();
                      },
                      child: _.imagepath == null ? Container(
                        height: 200,
                        width: 800,
                        //color: Colors.black,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/no-image.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ):Container(
                        height: 300,
                        width: double.infinity,
                        child: Image.file(_.imagepath,fit: BoxFit.contain,),
                      ), 
                    ),
                  ),
              ),

              Padding(
                  padding:  EdgeInsets.only(left: 10,right: 10,top: 20),
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                        _.pickImage();
                      },
                      child: _.imagepath == null ? Container(
                        height: 200,
                        width: 800,
                        //color: Colors.black,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/no-image.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ) : Container(
                        height: 300,
                        width: double.infinity,
                        child: Image.file(_.imagepath,fit: BoxFit.contain,),
                      ),
                    ),
                  ),
              ),

              SizedBox(height: 20,),

              Padding(
                padding:  EdgeInsets.only(left: 40,right: 40),
                child: Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: MaterialButton(
                    onPressed: (){
                      print('Guardando');
                      _.saveFicha();
                    },
                    child: Center(
                      child: Text(
                        'Guardar Ficha',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              

            ],
          ),
        ),
        
      ),
    );
  }
}


