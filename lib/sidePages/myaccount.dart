import 'package:flutter/material.dart';
import 'package:motivate_gram/navigationBloc/navigation_bloc.dart';

class MyAccount extends StatefulWidget with NavigationStates{
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "AccountPage",
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 28,
            fontFamily: "Langar"
        ),
      ),
    );
  }
}
