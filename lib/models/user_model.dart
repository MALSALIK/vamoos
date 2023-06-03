// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  final bool utype;
  final String uname;
  final String email;
  final int phoneno;
  final String password;

  UserModel({
    required this.utype,
    required this.uname,
    required this.email,
    required this.phoneno,
    required this.id,
    required this.password,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      utype: data['utype'],
      uname: data['name'],
      email: data['email'],
      password: data['password'],
      phoneno: data['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uname': uname,
      'email': email,
      'phoneno': phoneno,
      'utype': utype,
      'password': password,
    };
  }
}
