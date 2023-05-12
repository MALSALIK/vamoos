import 'package:flutter/material.dart';

class HostPage extends StatelessWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Page'),
      ),
      body: const Center(
        child: Text('Welcome, Host!'),
      ),
    );
  }
}
