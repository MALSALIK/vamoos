
import 'package:flutter/widgets.dart';
import '../Pages/User/user_home_screen.dart';

class HostList {
  HostList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HostList> hostList = [

    HostList(
      imagePath: '',
      navigateScreen: const UserHomePage(),
    ),
   
   
  ];
}
