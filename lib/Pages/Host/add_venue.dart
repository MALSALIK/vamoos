import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vamoos/widgets/custom_snackbar.dart';

import '../../file_picker.dart';
import '../User/app_theme.dart';

class AddVenue extends StatefulWidget {
  const AddVenue({super.key});

  @override
  State<AddVenue> createState() => _AddVenueState();
}

class _AddVenueState extends State<AddVenue> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _groundName = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _details = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _time = TextEditingController();
  String dropdownValue = 'Football';
  bool isWorking = false;
  String url = '';
  bool isSelected = false;
  String path = '';
  String name = '';
  DateTime? _selectedDateTime;

  Future<void> _selectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023, 5),
      lastDate: DateTime(2033),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // log(pickedTime.toString());
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _time.text = _selectedDateTime.toString().split('.')[0];
        });
        // log(_selectedDateTime.toString().split('.')[0]);
      }
    }
  }

  Future<String> uploadFile() async {
    File file = File(path);

    try {
      await FirebaseStorage.instance
          .ref(
              'images/${FirebaseAuth.instance.currentUser!.uid}/venues/${name}.png')
          .putFile(file)
          .then((p0) async {
        url = await p0.ref.getDownloadURL();
        path = '';
        SaveData();
      });
    } on FirebaseException catch (e) {
      setState(() {
        isWorking = false;
      });
      styledsnackbar(txt: 'Error occured.$e', icon: Icons.error);
      log(e.toString());
    }
    return url;
  }

  // Future PublishVenue() async {
  //   try {
  //     await uploadFile().then((value) {
  //       SaveData();
  //     });
  //   } catch (e) {
  //     styledsnackbar(txt: 'Error occured.$e', icon: Icons.error);
  //   }
  // }

  Future SaveData() async {
    try {
      FirebaseFirestore.instance
          .collection('venues')
          // .doc(FirebaseAuth.instance.currentUser!.uid)
          // .collection('myvenues')
          .doc()
          .set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'venue_name': _groundName.text,
        'venue_details': _details.text,
        'venue_price': _price.text,
        'venue_location': _location.text,
        'venue_time': _time.text,
        'venue_type': dropdownValue.toString(),
        'isavailable': true,
        'img': url.toString(),
      });
      setState(() {
        isWorking = false;
        _groundName.clear();
        _details.clear();
        _price.clear();
        _time.clear();
        _location.clear();
        dropdownValue = 'Football';
      });

      styledsnackbar(
          txt: 'Venue Published Successfully', icon: Icons.check_box);
    } catch (e) {
      styledsnackbar(txt: 'Error occured: $e', icon: Icons.error);
      setState(() {
        isWorking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Add Venue',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    filepicker().then((List selectedpath) {
                      if (selectedpath.isNotEmpty) {
                        setState(() {
                          path = selectedpath[0];
                          name = selectedpath[1].toString().split('.')[0];
                          log(name);
                          log(selectedpath[0].toString());
                          isSelected = true;
                          // uploadFile(selectedpath.toString());
                        });
                      }
                    });
                  },
                  child: isSelected
                      ? CircleAvatar(
                          radius: 50.0,
                          foregroundImage: FileImage(File(path)),
                          child: Icon(
                            Icons.person,
                            size: 80.0,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          radius: 50.0,
                          foregroundImage: CachedNetworkImageProvider(''),
                          child: Icon(
                            Icons.person,
                            size: 80.0,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.black26,
                        ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              CustomField(controller: _groundName, hintText: 'Ground Name'),
              CustomField(controller: _details, hintText: 'Ground Details'),
              CustomField(controller: _price, hintText: 'Ground Price'),
              CustomField(controller: _location, hintText: 'Location'),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 15.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: DropdownButton(
                    value: dropdownValue,
                    alignment: Alignment.centerLeft,
                    isExpanded: true,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.black,
                      // fontWeight: FontWeight.w700,
                    ),
                    hint: Text(
                      'Select Ground Type',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: 'Football',
                        child: Text('Football'),
                      ),
                      DropdownMenuItem(
                        value: 'Padel',
                        child: Text('Padel'),
                      ),
                      DropdownMenuItem(
                        value: 'Volley Ball',
                        child: Text('Volley Ball'),
                      ),
                      DropdownMenuItem(
                        value: 'Bowling',
                        child: Text('Bowling'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: _time,
                      // obscureText: true,

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field should not be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () {
                                _selectDateTime();
                              },
                              child: Icon(
                                Icons.date_range,
                                size: 25.0,
                                color: AppTheme.black,
                              )),
                          border: InputBorder.none,
                          hintText: 'Select Time'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 50.0),
                child: GestureDetector(
                  onTap: isWorking
                      ? null
                      : () {
                          if (_formkey.currentState!.validate()) {
                            if (isSelected == true && path.isNotEmpty) {
                              setState(() {
                                isWorking = true;
                              });
                              uploadFile();
                            } else {
                              styledsnackbar(
                                  txt: 'Please Selected Image',
                                  icon: Icons.warning);
                            }
                          }
                        },
                  child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlue,
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      child: Center(
                        child: isWorking
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Publish',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const CustomField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextFormField(
            controller: controller,
            // obscureText: true,

            validator: (value) {
              if (value!.isEmpty) {
                return 'Field should not be empty';
              }
              return null;
            },
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hintText),
          ),
        ),
      ),
    );
  }
}
