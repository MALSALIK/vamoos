// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vamoos/auth/auth_page.dart';
import '../Pages/Host/host_page.dart';
import '../Pages/User/navigation_home_screen.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key , required this.isHost});
  final bool isHost;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return  isHost?   HostPage() : NavigationHomeScreen();
          } else {
            return AuthPage();
          }
        },
      ),

                

    );
  }
}