// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vamoos/Pages/User/my_reservations.dart';
import 'package:vamoos/Pages/User/payment_page.dart';
import '../../models/hostlist.dart';

import 'app_theme.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with TickerProviderStateMixin {
  List<HostList> hostList = HostList.hostList;

  bool multiple = true;
  String filter = 'All';
  List sports = [
    {
      'name': 'Football',
      'path': 'assets/images/football.png',
      'isSelected': false,
    },
    {
      'name': 'Padel',
      'path': 'assets/images/padel.png',
      'isSelected': false,
    },
    {
      'name': 'Volley ball',
      'path': 'assets/images/volleyball.png',
      'isSelected': false,
    },
    {
      'name': 'Bowling',
      'path': 'assets/images/bowling.png',
      'isSelected': false,
    },
    {
      'name': 'All',
      'path': 'assets/images/all.png',
      'isSelected': true,
    },
  ];

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
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: Text(
            'Vamoos',
            style: TextStyle(
              fontSize: 22,
              color: AppTheme.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyReservations(),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.blue,
              ),
              // minWidth: MediaQuery.of(context).size.width * 0.5,
              icon: Icon(
                Icons.bookmark_added,
                color: AppTheme.black,
              ),

              label: Text(
                'My Reservations', //  snapshot.data!.docs[index]['venue_name'],
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(
                'Manage Sport',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: InkWell(
                child: Text(
                  '', //View all
                  style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  sports.length,
                  (index) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          sports.forEach((element) {
                            element['isSelected'] = false;
                          });
                          sports[index]['isSelected'] = true;
                          filter = sports[index]['name'];
                          setState(() {});
                        },
                        child: Container(
                          width: 70,
                          height: 100.0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: sports[index]['isSelected']
                                ? AppTheme.darkGrey
                                : AppTheme.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Image.asset(
                            sports[index]['path'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        sports[index]['name'],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            ListTile(
              title: Text(
                'PlayGrounds',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: InkWell(
                child: Text(
                  '', //View all
                  style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: filter == 'All'
                  ? FirebaseFirestore.instance
                      .collection('venues')
                      // .doc(FirebaseAuth.instance.currentUser!.uid)
                      // .collection('myvenues')
                      // .where('isavailable', isEqualTo: true)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('venues')
                      // .doc(FirebaseAuth.instance.currentUser!.uid)
                      // .collection('myvenues')
                      .where('venue_type', isEqualTo: filter)
                      // .where('isavailable', isEqualTo: true)
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Center(
                      child: Text(
                        'No Venue available.',
                        style: TextStyle(
                          fontSize: 22,
                          color: AppTheme.white,
                          fontWeight: FontWeight.w700,
                        ),
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
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
                                          .data!.docs[index]['img']
                                          .toString()),
                                      fit: BoxFit.fill)),
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
                              child: MaterialButton(
                                onPressed: !snapshot.data!.docs[index]
                                        ['isavailable']
                                    ? null
                                    : () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: const Text(
                                                    'Do you want to reserve this venue with following details?',
                                                    style: TextStyle(
                                                        fontSize: 17.0),
                                                  ),
                                                  content: Text(
                                                    'Name: ${snapshot.data!.docs[index]["venue_name"]}\nDetails: ${snapshot.data!.docs[index]["venue_details"]}\nPrice: ${snapshot.data!.docs[index]["venue_price"]} SAR\nReservation Time: ${snapshot.data!.docs[index]["venue_time"]}',
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  ),
                                                  actions: <Widget>[
                                                    MaterialButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text(
                                                        'No',
                                                        style: TextStyle(
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                    MaterialButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PaymentPage(
                                                                          venueId: snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .id
                                                                              .toString(),
                                                                          venueData: snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .data() as Map,
                                                                        )));
                                                      },
                                                      child: const Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                      },
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  snapshot.data!.docs[index]['isavailable']
                                      ? 'Reserve'
                                      : 'Reserved', //  snapshot.data!.docs[index]['venue_name'],
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
          ],
        ),
      ),
    );
  }
}
