import 'package:flutter/material.dart';
import 'package:vamoos/auth/login_page.dart';

import 'register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initilaay show the log in page
  bool showLoginPage = true;

  void toggleScreens() {

    setState(() {
      showLoginPage = !showLoginPage;
    });


  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleScreens);
    } else {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
