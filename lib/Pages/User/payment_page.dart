import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vamoos/Pages/User/app_theme.dart';
import 'package:vamoos/Pages/User/checkout_page.dart';

class PaymentPage extends StatelessWidget {
  final Map venueData;
  final String venueId;
  const PaymentPage(
      {super.key, required this.venueData, required this.venueId});

  @override
  Widget build(BuildContext context) {
    log(venueData.toString());
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
          'Select Payment Method',
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
            SizedBox(height: 24.0),
            PaymentOptionCard(
              optionTitle: 'Cash',
              optionIcon: Icons.money,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CheckoutPage(
                          paymentMethod: 'Cash',
                          venueId: this.venueId,
                          venueData: this.venueData,
                        )));
              },
            ),
            SizedBox(height: 16.0),
            PaymentOptionCard(
              optionTitle: 'Credit Card',
              optionIcon: Icons.credit_card,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CheckoutPage(
                          paymentMethod: 'Credit Card',
                          venueId: this.venueId,
                          venueData: this.venueData,
                        )));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOptionCard extends StatelessWidget {
  final String optionTitle;
  final IconData optionIcon;
  final VoidCallback onPressed;

  const PaymentOptionCard({
    required this.optionTitle,
    required this.optionIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              optionIcon,
              size: 40.0,
              color: Colors.blue,
            ),
            SizedBox(width: 16.0),
            Text(
              optionTitle,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
