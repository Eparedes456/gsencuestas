
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/pages/Login/LoginPage.dart';
import 'package:gsencuesta/pages/Perfil/EditProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    var argument = Get.arguments;
    print('Dato recibido $argument');
    this.loadData();


  }


  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  String _userName = "";
  String get userName => _userName;

  loadData()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    _userName = preferences.getString('nombreUser');

    update();

  }

  navigateToEditProfile()async{

    Get.to(

      EditProfilePage()

    );


  }

  logout()async{

    SharedPreferences preferences = await  SharedPreferences.getInstance();

    preferences.clear();

    Get.offAll(
      LoginPage()
    );


  }

  



}