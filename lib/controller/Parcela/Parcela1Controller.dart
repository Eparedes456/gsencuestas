import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:gsencuesta/database/database.dart';
import 'package:gsencuesta/model/Departamento/DepartamentoModel.dart';
import 'package:gsencuesta/model/Distritos/DistritosModel.dart';
import 'package:gsencuesta/model/Encuestado/EncuestadoModel.dart';
import 'package:gsencuesta/model/Parcela/BeneficiarioParcela.dart';
import 'package:gsencuesta/model/Parcela/ParcelaCoordenadas.dart';
import 'package:gsencuesta/model/Parcela/ParcelaMoodel.dart';
import 'package:gsencuesta/model/Provincia/ProvinciaModel.dart';
import 'package:gsencuesta/pages/Parcela/NewParcelapage.dart';
import 'package:gsencuesta/services/apiServices.dart';
import 'package:gsencuesta/model/Ubigeo/UbigeoModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/Encuestado/EncuestadoModel.dart';

class Parcela1Controller extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    this.getAllParcela();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
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

  TextEditingController insertEncuestadoController = new TextEditingController();
  String idEncuestado;
  ApiServices apiConexion = ApiServices();
  Uint8List _photoBase64;
  Uint8List get photoBase64 => _photoBase64;
  List<EncuestadoModel> encuestado = [];

  String _valueCentroPoblado;
  String get valueCentroPoblado => _valueCentroPoblado;
  List<UbigeoModel> _listCentrosPoblados = [];
  List<UbigeoModel> get listCentroPoblados => _listCentrosPoblados;
  
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


  /*  PARCELAS */

  List<EncuestadoModel> _listParcelas = [];
  List<EncuestadoModel> get listParcela => _listParcelas;
  List<ParcelaCoordenadasModel> _listParcelaCoordenada = [];
  bool hayParcela = false;
  bool loading = true;
  bool cargaCoordenadas = false;

  getAllParcela()async{
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    var idInstitucion = await preferencias.getString('idInstitucion');
    print(idInstitucion);
    //List response = await apiConexion.getAllParcelas();
    //List<EncuestadoModel> response = await DBProvider.db.getAllEncuestado();
    List<EncuestadoModel> response = await DBProvider.db.getAllEncuestadoxinstitucion(idInstitucion.toString());
    _listParcelas = response;
    if(_listParcelas.length > 0){
      hayParcela = true;
      loading = false;
    }else if(_listParcelas.length == 0){
      hayParcela = false;
      loading = false;
    }
    update();

  }

  navigateToBeneficiarioParcela(String idBeneficiario){
    Get.to(
      BeneficiaroParcela(),
      arguments: {
        "idBeneficiario" : idBeneficiario,
        //"parcelas"       : lista
      }
    );
  }

  




  /** */

  showModalSearch(){

    Get.dialog(

      AlertDialog(

        title: Text('Buscar encuestado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: insertEncuestadoController,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 13
                ),
                hintText: 'Ingrese el dni o el nombre'
              ),
            ),
            SizedBox(height: 12,),

            FlatButton.icon(
              color: Color.fromRGBO(0, 102, 84, 1),
              onPressed: (){

                searchEncuestado();

              }, 
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              label: Text('Buscar',style: TextStyle(color: Colors.white),)
            )


          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),

      ),
      

    );


  }



  searchEncuestado()async{

    Get.back();

    loadMessage('Buscando...', true);

    if(insertEncuestadoController.text == ""){

      print('El campo es requerido para hacer la busqueda');
      Get.back();
      messageInfo('El campo es requerido para hacer la busqueda');


    }else{

      ConnectivityResult conectivityResult = await Connectivity().checkConnectivity();

      if(conectivityResult == ConnectivityResult.wifi || conectivityResult == ConnectivityResult.mobile){

        var response = await apiConexion.findEncuestado(insertEncuestadoController.text);
        if(response == 2){

          Get.back();

          messageInfo('Error 500, error de servidor comuniquese con el encargado del sistema');

        }else if( response != 2 && response != 1 && response != 3){

          print(response);
          
          if( response.length > 0 ){

            Get.back(); 
            encuestado = [];
            response.forEach((element){
              encuestado.add(
                EncuestadoModel(
                  idEncuestado    : element["idEncuestado"].toString(),
                  nombre          : element["nombre"],
                  apellidoPaterno : element["apellidoPaterno"], 
                  apellidoMaterno : element["apellidoMaterno"],
                  tipoDocumento   : element["tipoDocumento"],
                  foto            : element["foto"],
                  idUbigeo        : element["idUbigeo"]   
                )
              );
            });
            //showEncuestadoModal(response);
            showEncuesta1(encuestado);

          }else{
            Get.back();
            messageInfo('El encuestado no se encuentra registrado');
          }
          

        }


      }else{

        print("Busco al encuestado en la bd local");

        var respuesta = await DBProvider.db.searchEncuestado(insertEncuestadoController.text);
        if(respuesta.length > 0){

          Get.back(); 
          showEncuesta1(respuesta);

        }else{
          
          Get.back();
          messageInfo('El encuestado no se encuentra registrado');

        }

      }

      

    }

  }

  showEncuesta1(var response){

    Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Encuestados encontrados'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 300,
                child: ListView.builder(
                  itemCount: response.length,
                  itemBuilder: (context,i){
                    var nombreCompleto  = response[i].nombre + " " + response[i].apellidoPaterno + " " + response[i].apellidoMaterno;
                    print(nombreCompleto);
                    var foto            = response[i].foto;
                    _photoBase64        = base64Decode(foto); 

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:  _photoBase64 == "" || _photoBase64 == null ?  AssetImage('assets/images/nouserimage.jpg') :  MemoryImage(_photoBase64)
                        ),
                        title: Text( nombreCompleto ,style: TextStyle(fontSize: 14),),
                        onTap: (){
                          Get.back();
                          //showEncuestadoModalFinal(response[i]);
                            showEncuestadoModal(response[i]);
                        },
                      ),
                    );
                  }
                ),
              )
            ],
          ),

        )
    );
  }


  loadMessage(String message, bool isLoading){

    Get.dialog(

      AlertDialog(

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            isLoading == true ? CircularProgressIndicator() : Container(),

            SizedBox(height: 20,),

            Text(message)

          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),

      )

    );


  }
  messageInfo(String mensaje){
    Get.dialog(
      AlertDialog(
        title: Text('Notificación'),
        content: Text('$mensaje'),
      )
    );
  }

  showEncuestadoModal(dynamic data)async{
    listCodDep = [];
    listcodProvincia = [];
    liscodDistrito = [];
    _listprovincias = [];
    _listDistritos = [];

    print(data.idEncuestado);
    var idEncuestado2   = data.idEncuestado.toString();
    var nombreCompleto  =  data.nombre + " " + data.apellidoPaterno + " " + data.apellidoMaterno;
    var foto            = data.foto;
    _photoBase64        = base64Decode(foto); 
    var idUbigeo        =  data.idUbigeo; // "220101,220203,210402,220103";  
    var dataUbi = idUbigeo.split(",");
    List temporalDepartamento = [];
    List temporalProvincia    = [];
    List temporalDistrito     = [];

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
    print(dataUbi[0].substring(2,4));
    print(idDepartamento);

    _valueProvincia = _listprovincias[0].descripcion;

    var result = dataUbi.where((element) =>  element.contains(_listprovincias[0].codigoDepartamento) && element.contains( _listprovincias[0].codigoProvincia));
    result.forEach((element) { 
      temporalDistrito.add(element);
    });
    for (var d = 0; d < temporalDistrito.length; d++) {

      List<UbigeoModel> dataDistritos = await DBProvider.db.getDistrito1(
        temporalDistrito[d].toString().substring(2,4), temporalDistrito[d].toString().substring(0,2), temporalDistrito[d].toString().substring(4,6)
      );
      _listDistritos.add(dataDistritos[0]);
    }
    print(_listDistritos);

    _valueDistrito = _listDistritos[0].descripcion;
    _selectCodDistrito = _listDistritos[0].codigoDistrito;
    _selectCodDepartamento  = idDepartamento;
    _selectCodProvincia     = _listprovincias[0].codigoProvincia;



  
    Get.dialog(

      AlertDialog(

        title: Text('Encuestado encontrado'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
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

            ),
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
            SizedBox(height: 8,),
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
                    idEncuestado = idEncuestado2.toString();
                    print(idEncuestado);
                    print(ubigeo);

                    //confirmationModal(idEncuestado,ubigeo);

                    //Get.to(Practica());
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

}

class DropDownDepartamento extends StatelessWidget {
  final List<UbigeoModel> showDepartamentos;
  final List<String> dataUbi;
  const DropDownDepartamento({Key key, this.showDepartamentos, this.dataUbi}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    String value = showDepartamentos[0].descripcion;

    return GetBuilder<Parcela1Controller>(
      init: Parcela1Controller(),
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

    return GetBuilder<Parcela1Controller>(

      init: Parcela1Controller(),
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

    return GetBuilder<Parcela1Controller>(

      init: Parcela1Controller(),
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

    return GetBuilder<Parcela1Controller>(
      init: Parcela1Controller(),
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

