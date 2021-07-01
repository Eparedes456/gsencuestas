import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AboutPage extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Acerca de la Aplicación'),
        leading: Container(),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 8,),

            Padding(
              padding:  EdgeInsets.only(left: 10,right: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GSEncuesta',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 102, 84, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        'Aplicativo para la toma de muestras de campo en tiempo real, rápida y flexible; no requiere conexión a internet,permite crear encuestas de diferentes estructuras y tipos de datos, incorporando características como la georreferenciación.',
                        textAlign: TextAlign.justify,
                      )
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20,),
            Padding(
              padding:  EdgeInsets.only(left: 18,right: 10),
              child: Text(
                'Caracteristicas',
                style: TextStyle(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),
            SizedBox(height: 20,),

            Row(
              children: [

                Container(
                  height : 90,
                  width: size.width*0.3,
                  padding: EdgeInsets.only(left: 10,top: 10),
                  
                  child: Image.asset('assets/images/survey-logo.png'),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top: 10,left: 10),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Encuestas dinámicas y estáticas',style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),

            Row(
              children: [

                Container(
                  height : 90,
                  width: size.width*0.3,
                  padding: EdgeInsets.only(left: 10,top: 10),
                  
                  child: Image.asset('assets/images/noconecction.png'),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top: 10,left: 10),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Toma de datos sin conexión a internet',style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),

            Row(
              children: [

                Container(
                  height : 90,
                  width: size.width*0.3,
                  padding: EdgeInsets.only(left: 10,top: 10),
                  
                  child: Image.asset('assets/images/sincronizar.png'),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top: 10,left: 10),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Sincronización de datos a la nube.',style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),

            Row(
              children: [

                Container(
                  height : 90,
                  width: size.width*0.3,
                  padding: EdgeInsets.only(left: 10,top: 10),
                  
                  child: Image.asset('assets/images/googlemaps.png'),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top: 10,left: 10),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Encuestas gerreferenciadas.',style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),

            SizedBox(height: 20,),

            Padding(
              padding:  EdgeInsets.only(left: 18,right: 10),
              child: Text(
                'Equipo de desarrollo',
                style: TextStyle(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),

            SizedBox(height: 10,),

            Stack(
              children: [

                Padding(
                  padding: EdgeInsets.only(top:10,left: 40,right: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60,top: 10),
                          child: Text('LINYGN DEL AGUILA ESCUDERO',style: TextStyle(),),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: 60,top: 0),
                          child: Text('Analista Programador / Team Lider',style: TextStyle(color: Colors.grey),),
                        ),
                        
                      ],
                    )
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.only(left: 5),
                  child: Container(
                    height: size.height*0.13,
                    width: 90,
                    child: Image(
                        image: AssetImage('assets/images/userDev.png'),
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 10,),

            Stack(
              children: [

                

                Padding(
                  padding:   EdgeInsets.only(top: 10,left: 20,right: 10),
                  child: Container(
                    //height: 60,
                    
                    width:  double.infinity  ,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10,right: MediaQuery.of(context).size.width *0.25),
                          child: Text('ANGEL LABAJOS CARO',style: TextStyle(),),
                        ),
                        
                        Padding(
                          padding:  EdgeInsets.only(right:  MediaQuery.of(context).size.width *0.25),
                          child: Text('Analista Programador',style: TextStyle(color: Colors.grey),),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                
                

                Padding(
                  padding:  EdgeInsets.only(left: size.width*0.75,right: 5),
                  child: Container(
                    height: size.height*0.13,
                    width: 90,
                    child: Image(
                        image: AssetImage('assets/images/userDev2.png'),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 10,),

            Stack(
              children: [

                Padding(
                  padding: EdgeInsets.only(top:10,left: 40,right: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60,top: 10),
                          child: Text('ERICK PAREDES RAMÍREZ',style: TextStyle(),),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: 60,top: 0),
                          child: Text('Analista Programador',style: TextStyle(color: Colors.grey),),
                        ),
                      ],
                    )
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.only(left: 5),
                  child: Container(
                    height: size.height*0.13,
                    width: 90,
                    child: Image(
                        image: AssetImage('assets/images/userDev3.png'),
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 10,),

            Stack(
              children: [
                Padding(
                  padding:   EdgeInsets.only(top: 10,left: 20,right: 10),
                  child: Container(
                    //height: 60,
                    
                    width:  double.infinity  ,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10,right: MediaQuery.of(context).size.width *0.25),
                          child: Text('DENYS GUERRERO GUERRA',style: TextStyle(),),
                        ),
                        
                        Padding(
                          padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width *0.25),
                          child: Text('Analista Programador',style: TextStyle(color: Colors.grey),),
                        ),
                        
                      ],
                    ),
                  ),
                ),
  
                Padding(
                  padding:  EdgeInsets.only(left: size.width*0.75,right: 5),
                  child: Container(
                    height: size.height*0.13,
                    width: 90,
                    child: Image(
                        image: AssetImage('assets/images/denys.png'),
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 10,),

            Stack(
              children: [

                Padding(
                  padding: EdgeInsets.only(top:10,left: 40,right: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60,top: 10),
                          child: Text('EVER CARLOS ROJAS',style: TextStyle(),),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: 60,top: 0),
                          child: Text('Analista Programador',style: TextStyle(color: Colors.grey),),
                        ),
                      ],
                    )
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.only(left: 5),
                  child: Container(
                    height: size.height*0.13,
                    width: 90,
                    child: Image(
                        image: AssetImage('assets/images/ever.png'),
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 10,),

            Stack(
              children: [

                

                Padding(
                  padding:   EdgeInsets.only(top: 10,left: 20,right: 10),
                  child: Container(
                    width:  double.infinity  ,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10,right: MediaQuery.of(context).size.width *0.25),
                          child: Text('MICHAEL LABAJOS DETQUIZAN',style: TextStyle(),),
                        ),
                        
                        Padding(
                          padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width *0.25),
                          child: Text('Analista Programador',style: TextStyle(color: Colors.grey),),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                
                Padding(
                  padding:  EdgeInsets.only(left: size.width*0.75,right: 5),
                  child: Container(
                    height: size.height*0.13,
                    width: 90,
                    child: Image(
                        image: AssetImage('assets/images/michael.png'),
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 10,),

            Stack(
              children: [

                Padding(
                  padding: EdgeInsets.only(top:10,left: 40,right: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60,top: 10),
                          child: Text('JOSE LUIS ROJAS VÁSQUEZ',style: TextStyle(),),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: 60,top: 0),
                          child: Text('Diseñador UI/UX',style: TextStyle(color: Colors.grey),),
                        ),
                      ],
                    )
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.only(left: 5),
                  child: Container(
                    height: size.height*0.13,
                    width: 90,
                    child: Image(
                        image: AssetImage('assets/images/userDev4.png'),
                    ),
                  ),
                ),
                SizedBox(height: 5,),

              ],
            ),

            SizedBox(height: 20,),
            Padding(
              padding:  EdgeInsets.only(left: 18,right: 10),
              child: Text(
                'Versión de la aplicación',
                style: TextStyle(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding:  EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(FontAwesomeIcons.android,color: Colors.green,),
                        Text('Android'),
                        Text('1.0.4')
                      ],
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(FontAwesomeIcons.apple,color: Colors.grey[600],),
                        Text('Apple'),
                        Text('1.0.0')
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),

            
          ],
        ),
      )
      
    );
  }
}