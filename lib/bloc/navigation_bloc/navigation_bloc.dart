import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/views/sidePage/aboutPage.dart';
import 'package:motivate_gram/views/sidePage/chatRoomPage.dart';
import 'package:motivate_gram/views/sidePage/helpPage.dart';
import 'package:motivate_gram/views/sidePage/homepage.dart';
import 'package:motivate_gram/views/sidePage/profile.dart';
import 'package:motivate_gram/views/sidePage/settingPage.dart';

enum NavigationEvents{
  HomePageClickedEvent,
  MyProfileClickedEvent,
  AboutClickedEvent,
  ChatRoomClickedEvent,
  SettingClickedEvent,
  HelpClickedEvent
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

      case NavigationEvents.ChatRoomClickedEvent:
        yield ChatRoomPage();
        break;

      case NavigationEvents.SettingClickedEvent:
        yield SettingPage();
        break;

      case NavigationEvents.HelpClickedEvent:
        yield HelpPage();
        break;
    }
  }
}