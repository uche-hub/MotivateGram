import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Profile Page", style: TextStyle(
          fontFamily: 'Langar',
          fontWeight: FontWeight.w900,
          fontSize: 28
        ),),
      ),
    );
  }
}
