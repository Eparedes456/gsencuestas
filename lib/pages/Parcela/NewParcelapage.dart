import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsencuesta/controller/Parcela/ParcelaController.dart';

class NewParcelaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelaController>(
      init: ParcelaController(),
      builder: (_)=> Scaffold(
        appBar: AppBar(
          title: Text('Agregar parcelas'),
          elevation: 0,
        ),
        body: _.load?
          Center(
            child: CircularProgressIndicator(),
          )
        :  Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,    
              markers: _.markers,
              mapType: MapType.satellite,
              polylines: _.polylines,
              polygons: _.polygons,
              initialCameraPosition: _.initialCameraPosition,
              onMapCreated: (GoogleMapController controller){
                _.controller.complete(controller);
              },
              //onTap: _.tapMap(),
            ),
            
            
          ],
        ),
        
        bottomNavigationBar: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 102, 84, 1),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: MaterialButton(
                    onPressed: (){
                      //_.addMarker();
                      _.tapMap();
                      
                    },
                    child: Text(
                      'Agregar puntos',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    
                  ),
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(0, 102, 84, 1),
                    ),
                    borderRadius: BorderRadius.circular(15),
                    
                  ),
                  child: MaterialButton(
                    onPressed: (){
                      //_.polygonSave();
                      _.modal();
                      //_.showModaLoading();
                    },
                    child: Text(
                      'Guardar',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 102, 84, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        
      ),
    );
  }
}