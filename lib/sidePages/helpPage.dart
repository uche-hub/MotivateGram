import 'package:flutter/material.dart';
import 'package:motivate_gram/navigationBloc/navigation_bloc.dart';

class HelpPage extends StatefulWidget with NavigationStates{
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "HelpPage",
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 28,
            fontFamily: "Langar"
        ),
      ),
    );
  }
}
