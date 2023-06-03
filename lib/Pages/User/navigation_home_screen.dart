// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vamoos/Pages/Host/host_page.dart';
import '../custom_drawer/drawer_user_controller.dart';
import '../custom_drawer/home_drawer.dart';
import 'app_theme.dart';
import 'feedback_screen.dart';
import 'help_screen.dart';
import 'user_home_screen.dart';
import 'invite_friend_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  const NavigationHomeScreen({super.key});

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State {
  Widget? screenView;
  DrawerIndex? drawerIndex;
  bool ishost = false;
  Box box = Hive.box('userData');
  @override
  void initState() {
    var val = box.get(FirebaseAuth.instance.currentUser!.uid.toString());
    log(val['isHost'].toString());
    ishost = val['isHost'] ?? false;
    drawerIndex = DrawerIndex.HOME;
    screenView = ishost ? const HostPage() : const UserHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const UserHomePage();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = const HelpScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = const FeedbackScreen();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = const InviteFriend();
          });
          break;
        default:
          break;
      }
    }
  }
}
