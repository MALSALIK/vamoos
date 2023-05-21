


import 'package:flutter/widgets.dart';
import 'package:vamoos/Pages/User/user_page.dart';

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
      navigateScreen: const UserPage(),
    ),
   
   
  ];
}
