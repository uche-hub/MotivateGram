import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_gram/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:motivate_gram/views/sideBar/sidebar.dart';
import 'package:motivate_gram/views/sidePage/homepage.dart';



class SideBarLayout  extends StatelessWidget {
  NavigationStates get initialState => HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(initialState),
        child: Stack(
          children: [
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, navigationState){
                return navigationState as Widget;
              },
            ),
            SideBar()
          ],
        ),
      ),
    );
  }
}
