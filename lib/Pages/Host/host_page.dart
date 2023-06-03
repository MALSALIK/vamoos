// ignore_for_file: depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vamoos/Pages/Host/add_venue.dart';
import 'package:vamoos/widgets/logout_widget.dart';

import '../../widgets/custom_snackbar.dart';
import '../User/app_theme.dart';

class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  Future<bool> onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Are you sure?',
              style: TextStyle(fontSize: 18.0),
            ),
            content: const Text(
              'Do you want to exit the App',
              style: TextStyle(fontSize: 18.0),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              MaterialButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.blue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            'Host',
            style: TextStyle(
              fontSize: 22,
              color: AppTheme.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  logout(context);
                },
                child: Icon(
                  Icons.logout,
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddVenue()));
          },
          label: Text(
            'Add Venue',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.white,
              // fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: AppTheme.black,
          icon: Icon(
            Icons.add,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('venues')
              // .doc(FirebaseAuth.instance.currentUser!.uid)
              // .collection('myvenues')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppTheme.white,
              ));
              // Do something with the data.
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
              // Handle the error.
            } else if (snapshot.data!.docs.isEmpty) {
              // Loading...
              return Center(
                child: Text(
                  'No data available.',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            } else {
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items in each row
                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.35,
                ),
                itemCount: snapshot
                    .data!.docs.length, // Total number of items in the grid
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              // width: MediaQuery.of(context).size.width * 0.42,
                              decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          snapshot.data!.docs[index]['img']),
                                      fit: BoxFit.fill)),
                              // child: Image.asset(
                              //   'assets/images/introduction_animation/welcome.png',
                              //   fit: BoxFit.fill,
                              // ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              snapshot.data!.docs[index]['venue_name']
                                  .toString(), //  snapshot.data!.docs[index]['venue_name'],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '${snapshot.data!.docs[index]['venue_price']} SAR', //  snapshot.data!.docs[index]['venue_price'],
                              style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Time: ${snapshot.data!.docs[index]['venue_time']}', //  snapshot.data!.docs[index]['venue_price'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: snapshot.data!.docs[index]
                                        ['isavailable']
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: const Text(
                                              'Are you sure?',
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                            content: const Text(
                                              'Do you want to delete this venue.',
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                            actions: <Widget>[
                                              MaterialButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text(
                                                  'No',
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () async {
                                                  Get.back();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('venues')
                                                      // .doc(FirebaseAuth.instance.currentUser!.uid)
                                                      // .collection('myvenues')
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .delete();
                                                  styledsnackbar(
                                                      txt:
                                                          'Data deleted successfully',
                                                      icon: Icons.delete);
                                                },
                                                child: const Text(
                                                  'Yes',
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    : null,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  minimumSize: Size.fromWidth(
                                      MediaQuery.of(context).size.width * 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                // minWidth: MediaQuery.of(context).size.width * 0.5,
                                icon: Icon(Icons.delete),

                                label: Text(
                                  'Delete', //  snapshot.data!.docs[index]['venue_name'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0.0,
                          top: 0.0,
                          child: snapshot.data!.docs[index]['isavailable']
                              ? Center()
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: AppTheme.lightBlue,
                                  ),
                                  child: Text(
                                    'Reserved', //  snapshot.data!.docs[index]['venue_name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
