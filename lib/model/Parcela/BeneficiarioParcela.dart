import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Parcela/BeneficiarioParcelaController.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class BeneficiaroParcela extends StatelessWidget {
  const BeneficiaroParcela({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BeneficiarioParcelaController>(
      init: BeneficiarioParcelaController(),
      builder: (_)=> Scaffold(
        backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text('Beneficiario'),
            centerTitle: true,
            actions: [
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: (){
                _.showEncuestadoModal();
              }
            )
          ],
          ),
          body: Container(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: _.photoBase64 == null || _.photoBase64 == "null" || _.photoBase64 == "" ? AssetImage('assets/images/no-image.png') : MemoryImage(_.photoBase64),
                            ),
                          ),
                          SizedBox(height: 12,),
                          Text(_.nombreCompleto),
                          SizedBox(height: 20,),
                          Container(
                            height: 2,
                            width: double.infinity,
                            color: Colors.grey[200],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left: 8,right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      UrlLauncher.launch('tel:+51${_.telefono}');
                                    },
                                    child: Container(
                                      
                                      //color: Colors.black,
                                      height: 70,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.phone_in_talk,color: Colors.grey,),
                                          SizedBox(height: 8,),
                                          Text(
                                            _.telefono,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  width: 2,
                                  color: Colors.grey[200],
                                ),
                                Expanded(
                                  child: Container(
                                    
                                    //color: Colors.black,
                                    height: 70,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.badge,color: Colors.grey,),
                                        SizedBox(height: 8,),
                                        Text(
                                          _.numDocumento,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12,),
                        ],
                      ),
                    )
                  ),
                  SizedBox(height: 15,),
                  _.hayData == true ? Padding(
                    padding:  EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lista de parcelas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        
                        CircleAvatar(
                          radius: 15,
                          child: Text('${_.cantidadParcelas}'),
                          backgroundColor: Color.fromRGBO(0, 102, 84, 1),
                        )

                      ],
                    ),
                  ) : Container(),
                  SizedBox(height: 20,),
              
                  _.hayData == true?  Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),//NeverScrollableScrollPhysics(),
                        itemCount: _.listParcelasBeneficiario.length,
                        itemBuilder: (context,i){
                          return Column(
                            children: [
                              ListTile(
                                title: Text(' Descripcion: ${_.listParcelasBeneficiario[i].descripcion}'),
                                subtitle: Text('Area: ${_.listParcelasBeneficiario[i].area} m2'),
                              ),
                              Divider()
                            ],
                          );
                        }
                      ),
                            
                          
                        
                      
                    ):
                   Center(
                    child: Text('No cuenta con parcelas registradas.'),
                  ),
                  
                ],
              ),
            ),
          ),
      ),
    );
  }
}