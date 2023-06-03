import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_snackbar.dart';
import 'app_theme.dart';

class MyReservations extends StatelessWidget {
  const MyReservations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'My Reservations',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('myreservations')
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .collection('myvenues')
            // .where('isavailable', isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                'No Reserved Venue.',
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
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      color: AppTheme.nearlyWhite,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
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
                                image: CachedNetworkImageProvider(snapshot
                                    .data!.docs[index]['reserved_venue']['img']
                                    .toString()),
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
                        snapshot
                            .data!.docs[index]['reserved_venue']['venue_name']
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
                        '${snapshot.data!.docs[index]['reserved_venue']['venue_price']} SAR', //  snapshot.data!.docs[index]['venue_price'],
                        style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Time: ${snapshot.data!.docs[index]['reserved_venue']['venue_time']}', //  snapshot.data!.docs[index]['venue_price'],
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
                        child: MaterialButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  'Are you sure?',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                content: const Text(
                                  'Do you want to cancel this reservation?',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      try {
                                        final CollectionReference venuesRef =
                                            FirebaseFirestore.instance
                                                .collection('venues');

                                        final CollectionReference
                                            myreservations = FirebaseFirestore
                                                .instance
                                                .collection('myreservations')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid
                                                    .toString())
                                                .collection('myvenues');
                                        await venuesRef
                                            .doc(snapshot.data!.docs[index]
                                                ['venue_id'])
                                            .set(
                                                {
                                              'isavailable': true,
                                            },
                                                SetOptions(
                                                  merge: true,
                                                ));
                                        await myreservations
                                            .doc(snapshot.data!.docs[index].id
                                                .toString())
                                            .delete();
                                        Navigator.of(context).pop();
                                        styledsnackbar(
                                            txt:
                                                'Reservation cancelled successfully',
                                            icon: Icons.check_box);
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        styledsnackbar(
                                            txt: 'Error occured: $e',
                                            icon: Icons.error);
                                      }
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          minWidth: MediaQuery.of(context).size.width * 0.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            'Cancel', //  snapshot.data!.docs[index]['venue_name'],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          color: Colors.teal,
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
    );
  }
}
