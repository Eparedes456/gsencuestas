import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/DetalleFicha/ImagenesController.dart';

class ImagenesEncuesta extends StatelessWidget {
  const ImagenesEncuesta({ Key  key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImagenesController>(
      init: ImagenesController(),
      builder:(_)=> Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Imágenes'),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: _.lisMultimedia.length,
            itemBuilder: (context,i){
              Uint8List photoBase64;
              photoBase64 = base64Decode(_.lisMultimedia[i].tipo);
              print(photoBase64);
              return Padding(
                padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image:  MemoryImage(photoBase64),  //NetworkImage('https://upload.wikimedia.org/wikipedia/commons/5/53/Vaporwave-4K-Wallpapers.jpg') //MemoryImage(_.photoBase64)  
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_.lisMultimedia[i].nombre),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
      ),
    );
  }
}