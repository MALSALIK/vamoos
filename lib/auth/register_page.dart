// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, library_prefixes

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vamoos/Pages/User/app_theme.dart';
import 'package:vamoos/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthUser;
import 'package:vamoos/widgets/custom_snackbar.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

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
  final _unameController = TextEditingController();
  bool isWorking = false;
  bool _isHostSelected = false;
  @override
  void dispose() {
    _emailController.dispose();
    _confirmemailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _phoneNumberController.dispose();
    _unameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    Box box = await Hive.openBox('userData');

    setState(() {
      isWorking = true;
    });
    if (passwordConfirmed()) {
      try {
        UserCredential usercredential = await FirebaseAuthUser
            .FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // ignore: unused_local_variable
        final user = UserModel(
          id: "",
          utype: _isHostSelected,
          uname: _unameController.text.trim(),
          phoneno: int.tryParse(_phoneNumberController.text) ?? 0,
          password: _passwordController.text.trim(),
          email: _emailController.text.trim(),
        );
        box.put(usercredential.user!.uid.toString(), {
          'isHost': _isHostSelected,
          'data': user.toJson(),
        });

        await createUser(user, usercredential.user!.uid);
        setState(() {
          isWorking = false;
        });
        styledsnackbar(txt: 'User Created Successfully', icon: Icons.check_box);
      } on FirebaseAuthException catch (e) {
        setState(() {
          isWorking = false;
        });
        if (e.code == 'weak-password') {
          styledsnackbar(
              txt: 'The password provided is too weak.', icon: Icons.error);
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          styledsnackbar(
              txt: 'The account already exists for that email.',
              icon: Icons.error);

          print('The account already exists for that email.');
        }
      } catch (e) {
        setState(() {
          isWorking = false;
        });
        styledsnackbar(txt: e.toString(), icon: Icons.error);

        print(e);
      }
    }
  }

  Future createUser(UserModel user, String uid) async {
    final docUser = FirebaseFirestore.instance.collection('user').doc(uid);
    user.id = uid;
    final json = user.toJson();
    await docUser.set(json);
  }

  bool passwordConfirmed() {
    if (_confirmpasswordController.text.trim() ==
        _passwordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  // bool emailConfirmed() {
  //   if (_confirmemailController.text.trim() == _emailController.text.trim()) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

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
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      // to allow the user to input digits only (security breach)
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
                      controller: _unameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'UserName',
                        hintText: 'Enter Your Username',
                        prefixIcon: Icon(Icons.face),
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

              GestureDetector(
                  child: SwitchListTile(
                title: const Text(
                  'Are you a Host?',
                  style: TextStyle(
                    color: AppTheme.notWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                value: _isHostSelected,
                onChanged: (bool value) {
                  setState(() {
                    _isHostSelected = value;
                  });
                },
              )),

              //sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: isWorking ? null : signUp,
                  child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: isWorking
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
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

class UserTypeButton extends StatefulWidget {
  const UserTypeButton({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserTypeButtonState createState() => _UserTypeButtonState();
}

class _UserTypeButtonState extends State<UserTypeButton> {
  bool _isHostSelected = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        'Are you a Host?',
        style: TextStyle(
          color: AppTheme.notWhite,
          fontWeight: FontWeight.bold,
          fontSize: 23,
        ),
      ),
      value: _isHostSelected,
      onChanged: (bool value) {
        setState(() {
          _isHostSelected = value;
        });
      },
    );
  }
} // class user type button


