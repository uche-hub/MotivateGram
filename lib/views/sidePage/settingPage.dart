import 'package:flutter/material.dart';
import 'package:motivate_gram/bloc/navigation_bloc/navigation_bloc.dart';

class SettingPage extends StatelessWidget with NavigationStates{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Setting Page", style: TextStyle(
            fontFamily: 'Langar',
            fontWeight: FontWeight.w900,
            fontSize: 28
        ),),
      ),
    );
  }
}
