import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/views/sidePage/aboutPage.dart';
import 'package:motivate_gram/views/sidePage/homepage.dart';
import 'package:motivate_gram/views/sidePage/profile.dart';

enum NavigationEvents{
  HomePageClickedEvent,
  MyProfileClickedEvent,
  AboutClickedEvent
}

abstract class NavigationStates{}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates>{
  NavigationBloc(NavigationStates initialState) : super(initialState);


  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents events) async*{
    switch (events){
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;

      case NavigationEvents.MyProfileClickedEvent:
        yield ProfilePage();
        break;

      case NavigationEvents.AboutClickedEvent:
        yield AboutPage();
        break;

    }
  }
}