import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_gram/navigationBloc/navigation_bloc.dart';
import 'package:motivate_gram/sidePages/homepage.dart';
import 'package:motivate_gram/sidebar/sidebar.dart';

class SideBarLayout extends StatelessWidget {
  NavigationStates get initialState => HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(initialState),
        child: Stack(
          children: [
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            SideBar(),
          ],
        ),
      ),
    );
  }
}
