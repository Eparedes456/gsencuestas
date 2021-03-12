import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:gsencuesta/controller/Tabs/TabsController.dart';
import 'package:get/route_manager.dart';
import 'package:gsencuesta/pages/Config/ConfigPage.dart';
import 'package:gsencuesta/pages/Perfil/ProfilePage.dart';
import 'package:gsencuesta/pages/Principal/Principal.dart';
import 'package:gsencuesta/pages/Report/ReportPage.dart';
import 'package:gsencuesta/pages/quiz/QuizPage.dart';
import 'package:get/get.dart';

class TabsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final  TabsController tabsController = Get.put(TabsController());

    final List<Widget> bodyContent = [

      PrincipalPage(),
      ReportPage(),
      ConfigPage(),
      ProfilePage()
    ];

    return Scaffold(

      body: Obx(
        ()=>IndexedStack(
          children: [
            Center(child: bodyContent.elementAt(tabsController.selectIndex),)
          ],
          //child: Center(child: bodyContent.elementAt(tabsController.selectIndex),)
        )
      ),

      bottomNavigationBar: Obx(
        ()=> BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Color.fromRGBO(0, 102, 84, 1),
          selectedLabelStyle: TextStyle(color: Colors.green),

          items: [

            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.clipboard),
              label: 'Proyectos',
              
            ),

            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chartBar),
              label: 'Reporte'
            ),

            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.cogs),
              label: 'Config'
            ),

            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userCircle),
              label: 'Perfil'
            ),

          ],
          currentIndex: tabsController.selectIndex,
          onTap: (index) => tabsController.selectIndex = index,

        ),
      ),
      
    );
  }
}