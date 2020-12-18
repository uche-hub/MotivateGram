import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("LogOut Page", style: TextStyle(
          fontFamily: 'Langar',
          fontWeight: FontWeight.w900,
          fontSize: 28
        ),),
      ),
    );
  }
}
