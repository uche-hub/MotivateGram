import 'package:flutter/material.dart';
import 'package:motivate_gram/navigationBloc/navigation_bloc.dart';

class AboutPage extends StatefulWidget with NavigationStates{
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
