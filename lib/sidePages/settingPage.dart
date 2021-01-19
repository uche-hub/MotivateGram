import 'package:flutter/material.dart';
import 'package:motivate_gram/navigationBloc/navigation_bloc.dart';

class SettingPage extends StatefulWidget with NavigationStates{
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "SettingPage",
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 28,
            fontFamily: "Langar"
        ),
      ),
    );
  }
}
