import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Parcela/ParcelaMoodel.dart';

class BeneficiarioParcelaController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var data = Get.arguments;
    this.loadData(data);
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  String nombreCompleto = "";
  String telefono = "";
  String numDocumento = "";
  Uint8List _photoBase64;
  Uint8List get photoBase64 => _photoBase64;
  List<ParcelaModel> listParcelasBeneficiario = [];
  String cantidadParcelas = ""; 

  loadData(var data)async{

    var idBeneficiario = data["idBeneficiario"];
    print(idBeneficiario);
    List<EncuestadoModel> beneficiarioData = await DBProvider.db.getOneEncuestado(idBeneficiario);
    print(beneficiarioData);
    nombreCompleto = beneficiarioData[0].nombre + " " + beneficiarioData[0].apellidoPaterno + " " + beneficiarioData[0].apellidoMaterno;
    telefono = beneficiarioData[0].telefono;
    numDocumento = beneficiarioData[0].documento;
    var foto = beneficiarioData[0].foto;
    _photoBase64 = base64Decode(foto);
    listParcelasBeneficiario = data["parcelas"];
    listParcelasBeneficiario.removeWhere((element) => element.idSeccion.toString() != beneficiarioData[0].idEncuestado);
    print(listParcelasBeneficiario);
    cantidadParcelas = listParcelasBeneficiario.length.toString();
    update();

    
  }


}