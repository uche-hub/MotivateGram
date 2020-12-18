import 'package:flutter/material.dart';
import 'package:motivate_gram/views/sideBar/sidebar.dart';
import 'package:motivate_gram/views/sidePage/homepage.dart';

class SideBarLayout  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomePage(),
          SideBar()
        ],
      ),
    );
  }
}
