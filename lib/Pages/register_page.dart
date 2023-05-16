// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vamoos/Pages/User/app_theme.dart';

import '../auth/user_type_butten.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key,required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

      //text controllers
   final _emailController = TextEditingController();
   final _confirmemailController = TextEditingController();
   final _passwordController = TextEditingController();
   final _confirmpasswordController = TextEditingController();
   final _phoneNumberController = TextEditingController();


   @override
  void dispose() {
     _emailController.dispose();
     _confirmemailController.dispose();
     _passwordController.dispose();
     _confirmpasswordController.dispose();
      _phoneNumberController.dispose();
    super.dispose();
  }

  Future signUp() async{
    if(passwordConfirmed()){
         await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
       password: _passwordController.text.trim(),
      );
    }
 


  }


  bool passwordConfirmed (){
    if (_confirmpasswordController.text.trim()==_passwordController.text.trim()){
      return true;
    } else {
      return false;
    }


  }


bool emailConfirmed (){
    if (_confirmemailController.text.trim()==_emailController.text.trim()){
      return true;
    } else {
      return false;
    }


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 73, 107, 172),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.sports_basketball_sharp,
                size: 100,
              ),
              SizedBox(
                height: 50,
              ),
              //Hello agian
              Text(
                'Hello There!',
                style: GoogleFonts.bebasNeue(
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Register below with your details',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),




                    //phone textfield
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
                      controller: _phoneNumberController ,
                      keyboardType: TextInputType.phone,
                      
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Phone Number',
                           hintText: 'Enter Your Phone Number',
                           prefixIcon: Icon(Icons.phone),
                           ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),


              //email textfield
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
                          border: InputBorder.none, 
                          labelText: 'Email',
                           hintText: 'Enter Your Email',
                           prefixIcon: Icon(Icons.email),
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

                //confirm Password textfield
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
                      controller: _confirmemailController,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                           labelText: 'Confirm Email',
                           hintText: 'Confirm Your Email',
                           prefixIcon: Icon(Icons.email),
                           ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),


              //Password textfield
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
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                           labelText: 'Password',
                           hintText: 'Enter Your Password',
                           prefixIcon: Icon(Icons.password),
                           ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

                   //confirm Password textfield
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
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none, 
                         labelText: 'Confirm Password',
                           hintText: 'Confirm Your Password',
                           prefixIcon: Icon(Icons.password),
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

               GestureDetector(child: UserTypeButton()),

              //sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: signUp,
                  child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 25,
              ),

              //not a member ? regidter now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I am a member?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      '  Login here !',
                      style: TextStyle(
                        color: AppTheme.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    ); //Scaffold
  }
}