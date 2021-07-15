import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/VerEncuesta/VerEncuestaController.dart';



class VerDatePicker extends StatelessWidget {
  final String idpregunta;
  final String enunciado;
  final String numPregunta;
  final String bloque;
  final int i;
  final String pagina;
  final String tipoCampo;

  const VerDatePicker({ Key key, this.idpregunta, this.enunciado, this.numPregunta, this.bloque, this.i, this.pagina, this.tipoCampo }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    

    return GetBuilder<VerEncuestacontroller>(
      init: VerEncuestacontroller(),
      id: 'datePicker',
      builder: (_)=> Padding(
          padding:  EdgeInsets.only(left: 0,right: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Padding(
                padding: EdgeInsets.only(left: 0,right: 0),
                child: Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(top: 20,left: 20,right: 20),
                          child: Text(
                            '$numPregunta.- $enunciado',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              fontSize: 16
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                      
                        
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            readOnly: true,
                            onTap: (){
                              //_.showModalUbigeo(id_pregunta.toString(),apariencia,i);
                              //_.selectDatePicker(idpregunta,i,context,tipoCampo);
                            },
                            controller: _.controllerInput[i].controller,
                            decoration: InputDecoration(hintText: 'Presione aqui'),
                          ),
                        ),
                        SizedBox(height: 12,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}