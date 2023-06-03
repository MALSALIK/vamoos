import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vamoos/Pages/User/app_theme.dart';
import 'package:vamoos/Pages/User/navigation_home_screen.dart';
import '../../widgets/custom_snackbar.dart';

class CheckoutPage extends StatefulWidget {
  final String paymentMethod;
  final Map venueData;
  final String venueId;
  CheckoutPage(
      {super.key,
      required this.venueData,
      required this.paymentMethod,
      required this.venueId});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isWorking = false;

  Future PlaceOrder() async {
    setState(() {
      isWorking = true;
    });
    final CollectionReference venuesRef =
        FirebaseFirestore.instance.collection('venues');
    final CollectionReference myreservations = FirebaseFirestore.instance
        .collection('myreservations')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('myvenues');

    try {
      venuesRef.doc(widget.venueId).set(
          {
            'isavailable': false,
          },
          SetOptions(
            merge: true,
          ));
      myreservations.doc().set({
        'reserved_venue': widget.venueData,
        'payment_method': widget.paymentMethod,
        'venue_id': widget.venueId,
      });
      setState(() {
        isWorking = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
      );
      styledsnackbar(txt: 'Venue Reserved Successfully', icon: Icons.check_box);
    } catch (e) {
      styledsnackbar(txt: 'Error occured: $e', icon: Icons.error);
      setState(() {
        isWorking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // log(venueData.toString());

    return Scaffold(
      backgroundColor: AppTheme.blue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppTheme.black,
          ),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Details Section
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    // tileColor: Colors.teal,
                    minLeadingWidth: -25,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.darkGrey,
                      child: Icon(
                        Icons.sports_basketball_outlined,
                        size: 30.0,
                        color: AppTheme.nearlyWhite,
                      ),
                    ),
                    title: Text(
                      widget.venueData[
                          'venue_name'], //  snapshot.data!.docs[index]['venue_name'],
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      'details: ${widget.venueData['venue_details']}\nprice: ${widget.venueData['venue_price']} SAR', //  snapshot.data!.docs[index]['venue_name'],
                      style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  // Product details content
                  // ...
                ],
              ),
            ),
            SizedBox(height: 16.0),
            // Address Section
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    // tileColor: Colors.teal,
                    minLeadingWidth: -25,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),

                    title: Text(
                      'Venue Address: ${widget.venueData['venue_location']}', //  snapshot.data!.docs[index]['venue_name'],
                      style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      'Reservation Time: ${widget.venueData['venue_time']}', //  snapshot.data!.docs[index]['venue_name'],
                      style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  // Address form or details
                  // ...
                ],
              ),
            ),
            SizedBox(height: 16.0),
            // Payment Method Section
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    // tileColor: Colors.teal,
                    minLeadingWidth: -25,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),

                    title: Text(
                      '${widget.paymentMethod}', //  snapshot.data!.docs[index]['venue_name'],
                      style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      widget.paymentMethod == 'Cash'
                          ? 'Cash on delivery'
                          : 'Visa Ending in XXXX', //  snapshot.data!.docs[index]['venue_name'],
                      style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  // Payment method selection or details
                  // ...
                ],
              ),
            ),
            SizedBox(height: 16.0),
            // Total Fee and Estimated Tax Section
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    // tileColor: Colors.teal,
                    minLeadingWidth: -25,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    title: Text(
                      'Total Fee', //  snapshot.data!.docs[index]['venue_name'],
                      style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    trailing: Text(
                      '${widget.venueData['venue_price']} SAR', //  snapshot.data!.docs[index]['venue_name'],
                      style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            // Place Order Button
            ElevatedButton(
              onPressed: isWorking
                  ? null
                  : () {
                      PlaceOrder();
                    },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                backgroundColor: AppTheme.darkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: isWorking
                  ? CircularProgressIndicator(
                      color: AppTheme.white,
                    )
                  : Text(
                      'Place Order',
                      style: TextStyle(fontSize: 18.0),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
