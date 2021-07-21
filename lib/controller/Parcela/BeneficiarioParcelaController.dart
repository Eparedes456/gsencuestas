import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Distritos/DistritosModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Parcela/ParcelaMoodel.dart';
import 'package:gsencuesta/model/Ubigeo/UbigeoModel.dart';
import 'package:gsencuesta/pages/Parcela/NewParcelapage.dart';

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
  String idEncuestado  = "";
  bool hayData = false;
  var idUbigeo1;
  List<UbigeoModel> _listCentrosPoblados = [];
  List<UbigeoModel> get listCentroPoblados => _listCentrosPoblados;
   String _selectCodCentroPoblado = "";
   String _valueCentroPoblado;
  String get valueCentroPoblado => _valueCentroPoblado;

  /**  ubigeo */
    
  String _valueDepartamento;
  String get valueDepartamento => _valueDepartamento;

  String _valueProvincia;
  String get valueprovincia => _valueProvincia;
  List<UbigeoModel> _listprovincias = [];
  List<UbigeoModel> get listprovincias => _listprovincias;

  List<UbigeoModel> _listDistritos = [];
  List<UbigeoModel> get listDistrito => _listDistritos;
  String _valueDistrito;
  String get valueDistrito => _valueDistrito;

  String _selectCodDepartamento  = "";
  String _selectCodProvincia     = "";
  String _selectCodDistrito      = "";
  List listCodDep = [];
  List listcodProvincia = [];
  List liscodDistrito = [];

  loadData(var data)async{

    var idBeneficiario = data["idBeneficiario"];
    print(idBeneficiario);
    List<EncuestadoModel> beneficiarioData = await DBProvider.db.getOneEncuestado(idBeneficiario);
    print(beneficiarioData);
    nombreCompleto  = beneficiarioData[0].nombre + " " + beneficiarioData[0].apellidoPaterno + " " + beneficiarioData[0].apellidoMaterno;
    telefono        = beneficiarioData[0].telefono;
    numDocumento    = beneficiarioData[0].documento;
    var foto        = beneficiarioData[0].foto;
    idUbigeo1       = beneficiarioData[0].idUbigeo;
    idEncuestado    = beneficiarioData[0].idEncuestado;
    if(foto != null){
      _photoBase64    = base64Decode(foto);
    }
    
    listParcelasBeneficiario = await DBProvider.db.getBeneParcelas(idBeneficiario.toString());
    
    //listParcelasBeneficiario = data["parcelas"];
    //listParcelasBeneficiario.removeWhere((element) => element.idSeccion.toString() != beneficiarioData[0].idEncuestado);
    print(listParcelasBeneficiario);
    cantidadParcelas = listParcelasBeneficiario.length.toString();
    if(listParcelasBeneficiario.length == 0){
      hayData = false;
    }else{
      hayData = true;
    }
    
    update();

    
  }

  showEncuestadoModal()async{
    listCodDep = [];
    listcodProvincia = [];
    liscodDistrito = [];
    _listprovincias = [];
    _listDistritos = [];
    _listCentrosPoblados = [];
    
    var idUbigeo        =  idUbigeo1; // "220101,220203,210402,220103";  
    var dataUbi = idUbigeo.split(",");
    List temporalDepartamento = [];
    List temporalProvincia    = [];
    List temporalDistrito     = [];
    List temporalCentroPoblado = [];

    List<UbigeoModel> showDepartamentos = [];
    List<UbigeoModel>    showProvincias    = [];
    List<UbigeoModel>     showDistritos     = [];

    
    dataUbi.forEach((element) {
      var flat = element.substring(0,2);
      temporalDepartamento.add(flat);
    });

    dataUbi.forEach((element) {
      var flat = element.substring(0,4);
      temporalProvincia.add(flat);
    });



    listCodDep            = temporalDepartamento.toSet().toList();
    listcodProvincia      = temporalProvincia.toSet().toList();
    

    for (var i = 0; i < listCodDep.length; i++) {
      List<UbigeoModel> dataDepartamento  = await DBProvider.db .getDepartamentos1(listCodDep[i].toString());
      showDepartamentos.add(dataDepartamento[0]);
    }
    _valueDepartamento = showDepartamentos[0].descripcion;
    var idDepartamento = showDepartamentos[0].codigoDepartamento;
    listcodProvincia.removeWhere((element) => element.toString().substring(0,2) != idDepartamento );
    
    print(listcodProvincia);
    temporalProvincia = [];
    listcodProvincia.forEach((element) {
      var flat = element.substring(2,4);
      temporalProvincia.add(flat);
    });

    List codProvincia = temporalProvincia.toSet().toList();

    for (var x = 0; x < codProvincia.length; x++) {
      List<UbigeoModel> dataProvincias = await DBProvider.db.getProvincia1(codProvincia[x].toString(),idDepartamento);
      _listprovincias.add(dataProvincias[0]);
    }
    

    _valueProvincia = _listprovincias[0].descripcion;

    var result = dataUbi.where((element) =>  element.contains(_listprovincias[0].codigoDepartamento) && element.contains( _listprovincias[0].codigoProvincia));
    result.forEach((element) { 
      var flat = element.substring(4, 6);
      temporalDistrito.add(flat);
    });

    List codDistrito = temporalDistrito.toSet().toList();

    for (var d = 0; d < codDistrito.length; d++) {

      List<UbigeoModel> dataDistritos = await DBProvider.db.getDistrito1(
         _listprovincias[0].codigoProvincia, //temporalDistrito[d].toString().substring(2, 4),
          idDepartamento, //temporalDistrito[d].toString().substring(0, 2),
          codDistrito[d].toString() //temporalDistrito[d].toString().substring(4, 6)
      );
      _listDistritos.add(dataDistritos[0]);
    }

    var result2 = dataUbi.where((item) =>  item.contains(_listDistritos[0].codigoDepartamento) && item.contains(_listDistritos[0].codigoProvincia) && item.contains(_listDistritos[0].codigoDistrito) );
    result2.forEach((element) {
       var flat = element.substring(6, 10);
      temporalCentroPoblado.add(flat);
    });
    List codCentroPoblado = temporalCentroPoblado.toSet().toList();

    for (var i = 0; i < temporalCentroPoblado.length; i++) {

      List<UbigeoModel> dataCentroPoblados = await DBProvider.db.getCentroPoblado(
        _listprovincias[0].codigoProvincia, //temporalCentroPoblado[i].toString().substring(2,4), 
        idDepartamento, //temporalCentroPoblado[i].toString().substring(0,2),
        _listDistritos[0].codigoDistrito, //temporalCentroPoblado[i].toString().substring(4,6), 
        codCentroPoblado[i].toString()  //temporalCentroPoblado[i].toString().substring(6,10)
      );
      _listCentrosPoblados.add(dataCentroPoblados[0]);
    }


    print(_listDistritos);

    _valueDistrito = _listDistritos[0].descripcion;
    _selectCodDistrito = _listDistritos[0].codigoDistrito;
    _selectCodDepartamento  = idDepartamento;
    _selectCodProvincia     = _listprovincias[0].codigoProvincia;
    _valueCentroPoblado     = _listCentrosPoblados[0].descripcion;
    _selectCodCentroPoblado = _listCentrosPoblados[0].codigoCentroPoblado;

  
    Get.dialog(

      AlertDialog(

        //title: Text('Encuestado encontrado'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /*ListTile(
              contentPadding: EdgeInsets.zero,
              //leading: Icon(Icons.people,size: 16,),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: MemoryImage(_photoBase64)
              ),
              //trailing: Icon(Icons.arrow_forward,size: 16,),
              title: Text('$nombreCompleto',style: TextStyle(fontSize: 14),),
              onTap: (){

                
              },

            ),*/
            SizedBox(height: 8,),
            Text('Ambito  de intervención',style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Text('DEPARTAMENTO'),
            DropDownDepartamento(showDepartamentos: showDepartamentos, dataUbi: dataUbi,),
            
            SizedBox(height: 8,),
            Text('PROVINCIA'),
            DropDownProvincia(showProvincia: _listprovincias,dataUbi: dataUbi,),
            
            SizedBox(height: 8,),
            Text('DISTRITO'),
            DropDownDistrito(),
            SizedBox(
            height: 8,
          ),
          
            Text('CENTRO POBLADO'),
            CentroPoblado(
              showCentroPoblado: _listCentrosPoblados,
              dataUbi: dataUbi,
              isManual: false,
            ),
            
            
            SizedBox(height: 8,),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 102, 84, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                height: 45,
                child: MaterialButton(
                  onPressed: (){

                    String ubigeo = _selectCodDepartamento + _selectCodProvincia + _selectCodDistrito;
                    Get.back();
                    newParcela(ubigeo, idEncuestado);

                  },
                  child: Text(
                    'Empezar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      )
    );
  }

  newParcela(ubi,id){
    Get.to(
      NewParcelaPage(),
      arguments: {
        'ubigeo'        : ubi,
        'idEncuestado'  : id, 
      }
    );
  }

  selectedDepartamento(List<String> dataUbi, UbigeoModel value)async{
    _listprovincias = [];
    _listDistritos = [];
    List temporalProvincia  = [];
    List temporalDistrito  = [];
    _valueDistrito = "";
    var result = dataUbi.where((element) =>  element.contains(value.codigoDepartamento));
    
    dataUbi.forEach((element) {
      var flat = element.substring(0,4);
      temporalProvincia.add(flat);
    });
    
    listcodProvincia      = temporalProvincia.toSet().toList();
    print(listcodProvincia);
    listcodProvincia.removeWhere((element) => element.toString().substring(0,2) != value.codigoDepartamento );
    print(listcodProvincia);
    
    temporalProvincia = [];
    listcodProvincia.forEach((element) {
      var flat = element.substring(2,4);
      temporalProvincia.add(flat);
    });
    
    List codProvincia = temporalProvincia.toSet().toList();
    for (var x = 0; x < codProvincia.length; x++) {
      List<UbigeoModel> dataProvincias = await DBProvider.db.getOneProvincia(codProvincia[x].toString(),value.codigoDepartamento);
      _listprovincias.add(dataProvincias[0]);
    }
   
    print(_listprovincias);
    _valueProvincia = _listprovincias[0].descripcion;
    _selectCodDepartamento = value.codigoDepartamento;
    _selectCodProvincia = _listprovincias[0].codigoProvincia;
    update(['provincia']);
    await selectedProvincia(dataUbi,_listprovincias[0]);
   
  }
  selectdepartamento(String valor){
    _valueDepartamento  = valor;
    update(['departamento']);
  }

  selectedProvincia(List<String> dataUbi, UbigeoModel value)async{
    _listDistritos          = [];
    List temporalDistrito   = [];

    var result = dataUbi.where((element) =>  element.contains(value.codigoDepartamento + value.codigoProvincia));
    print(result);
    result.forEach((element) { 
      temporalDistrito.add(element);
    });
    print(temporalDistrito);
    for (var d = 0; d < temporalDistrito.length; d++) {

      List<UbigeoModel> dataDistritos = await DBProvider.db.getDistrito1(
        temporalDistrito[d].toString().substring(2,4), temporalDistrito[d].toString().substring(0,2), temporalDistrito[d].toString().substring(4,6)
      );
      _listDistritos.add(dataDistritos[0]);
    }
    print(_listDistritos);
     _valueDistrito = _listDistritos[0].descripcion;
     _selectCodProvincia = value.codigoProvincia;
     _selectCodDistrito = _listDistritos[0].codigoDistrito;
     update(['distrito']);
    
  }

  changeProvincia(String valor){
    _valueProvincia  = valor;
    update(['provincia']);
  }

  selectedDistrito(UbigeoModel value){
    _selectCodDistrito = value.codigoDistrito;
  }
  changeDistrito(String valor){
    _valueDistrito = valor;
    update(['distrito']);
  }

  selectedCentroPoblado(UbigeoModel value) {
    _selectCodCentroPoblado = value.codigoCentroPoblado;
  }

  changeCentroPoblado(String valor){
    _valueCentroPoblado = valor;
    update(['centroPoblado']);
  }

}


class DropDownDepartamento extends StatelessWidget {
  final List<UbigeoModel> showDepartamentos;
  final List<String> dataUbi;
  const DropDownDepartamento({Key key, this.showDepartamentos, this.dataUbi}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    String value = showDepartamentos[0].descripcion;

    return GetBuilder<BeneficiarioParcelaController>(
      init: BeneficiarioParcelaController(),
      id: 'departamento',
      builder: (_)=> Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: DropdownButton(
                underline: Container(color: Colors.transparent,),
                hint: Padding(
                  padding:  EdgeInsets.only(left: 8),
                  child: Text('Seleccione un departamento'),
                ),
                isExpanded: true,
                value: _.valueDepartamento,
                items: showDepartamentos.map((value){
                  return DropdownMenuItem(
                    value: value.descripcion,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(value.descripcion,style: TextStyle(fontSize: 14),),
                    ),
                    onTap: ()async{
                      //print(value.codigoDepartamento);
                      _.selectedDepartamento(dataUbi,value);
                    },
                  );
                }).toList(),
                onChanged: (valor){
                  
                 _.selectdepartamento(valor);
                
                },
              ),
            ),
    );
  }
}

class DropDownProvincia extends StatelessWidget {
  final List<UbigeoModel> showProvincia;
  final List<String> dataUbi;
  const DropDownProvincia({Key key,this.showProvincia,this.dataUbi}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    String value; //showProvincia[0].descripcion;

    return GetBuilder<BeneficiarioParcelaController>(

      init: BeneficiarioParcelaController(),
      id: 'provincia',
      builder: (_)=> Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: DropdownButton(
                underline: Container(color: Colors.transparent,),
                hint: Padding(
                  padding:  EdgeInsets.only(left: 8),
                  child: Text('Seleccione un departamento'),
                ),
                isExpanded: true,
                value: _.valueprovincia,
                items: _.listprovincias.map((value){
                  return DropdownMenuItem(
                    value: value.descripcion,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(value.descripcion,style: TextStyle(fontSize: 14),),
                    ),
                    onTap: ()async{
                      _.selectedProvincia(dataUbi,value);
                    },
                  );
                }).toList(),
                onChanged: (valor){
                  
                 _.changeProvincia(valor);
                
                },
              ),
            ),
    );
  }
}

class DropDownDistrito extends StatelessWidget {
  final List<DistritoModel> showDistrito;
  final List<String> dataUbi;
  const DropDownDistrito({Key key,this.showDistrito,this.dataUbi}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    String value; //showProvincia[0].descripcion;

    return GetBuilder<BeneficiarioParcelaController>(

      init: BeneficiarioParcelaController(),
      id: 'distrito',
      builder: (_)=> Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: DropdownButton(
                underline: Container(color: Colors.transparent,),
                hint: Padding(
                  padding:  EdgeInsets.only(left: 8),
                  child: Text('Seleccione un distrito'),
                ),
                isExpanded: true,
                value: _.valueDistrito,
                items: _.listDistrito.map((value){
                  return DropdownMenuItem(
                    value: value.descripcion,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(value.descripcion,style: TextStyle(fontSize: 14),),
                    ),
                    onTap: ()async{
                      _.selectedDistrito(value);
                    },
                  );
                }).toList(),
                onChanged: (valor){
                  
                 _.changeDistrito(valor);
                
                },
              ),
            ),
    );
  }
}

class CentroPoblado extends StatelessWidget {
  final List<UbigeoModel> showCentroPoblado;
  final List<String> dataUbi;
  final bool isManual;
  const CentroPoblado(
      {Key key, this.showCentroPoblado, this.dataUbi, this.isManual})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String value; //showProvincia[0].descripcion;

    return GetBuilder<BeneficiarioParcelaController>(
      init: BeneficiarioParcelaController(),
      id: 'centroPoblado',
      builder: (_) => Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: DropdownButton(
          underline: Container(
            color: Colors.transparent,
          ),
          hint: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text('Seleccione un centro poblado'),
          ),
          isExpanded: true,
          value: _.valueCentroPoblado,
          items: _.listCentroPoblados.map((value) {
            return DropdownMenuItem(
              value: value.descripcion,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.descripcion,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              onTap: () async {
                if (isManual == true) {
                  //_.selectedCentroPoblado(value);
                } else {
                  //_.selectedDistrito(value);
                }
              },
            );
          }).toList(),
          onChanged: (valor) {
            //_.changeCentroPoblado(valor);
          },
        ),
      ),
    );
  }
}

