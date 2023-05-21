// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try {
          await FirebaseAuth.instance.sendPasswordResetEmail(
      email: _emailController.text.trim()
      );

    } on FirebaseAuthException catch (e){
      print(e);
       showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      content: Text(e.message.toString()),
    );
  },
);
    }
  }

  
    
  
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 73, 107, 172),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text('Enter Your Email to get Password Rest link',
            textAlign:TextAlign.center,
            style: TextStyle(fontSize: 25.0),
            ),
          ), 

          SizedBox(
                height: 10,
              ),




          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Email'),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),


              MaterialButton(onPressed: passwordReset,
              color: Color.fromARGB(255, 101, 80, 148),
              child: Text('Rest Password'),
              ),
          
        ],
      ),
    );
  }
}