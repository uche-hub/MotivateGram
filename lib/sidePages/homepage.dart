import 'package:flutter/material.dart';
import 'package:motivate_gram/navigationBloc/navigation_bloc.dart';

class HomePage extends StatefulWidget with NavigationStates{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          "HomePage",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 28,
          fontFamily: "Langar"
        ),
      ),
    );
  }
}
