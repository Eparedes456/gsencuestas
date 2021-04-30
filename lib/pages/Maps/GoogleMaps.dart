import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsencuesta/controller/MapsController.dart/MapsController.dart';

class GoogleMaps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapsController>(
      init: MapsController(),
      builder: (_)=> Scaffold(
        body: Stack(
          children: [

            Positioned.fill(
              child: GoogleMap(
                myLocationButtonEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                markers: _.markers,
                mapType: MapType.normal,
                polylines: _.polylines,
                initialCameraPosition: _.initialCameraPosition,
                onMapCreated: (GoogleMapController controller){
                  _.controller.complete(controller);

                  _.setPolyline();
                  _.showMarker();
                },
              ) 
            )

          ],
        ),
        
      ),
    );
  }
}