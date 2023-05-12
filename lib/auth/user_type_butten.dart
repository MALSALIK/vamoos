import 'package:flutter/material.dart';

class UserTypeButton extends StatefulWidget {
  const UserTypeButton({Key? key}) : super(key: key);

  @override
  _UserTypeButtonState createState() => _UserTypeButtonState();
}

class _UserTypeButtonState extends State<UserTypeButton> {
  bool _isHostSelected = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Are you a Host?'),
      value: _isHostSelected,
      onChanged: (bool value) {
        setState(() {
          _isHostSelected = value;
        });
      },
    );
  }
}
