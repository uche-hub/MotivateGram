import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_gram/sidePages/aboutPage.dart';
import 'package:motivate_gram/sidePages/chatListScreen.dart';
import 'package:motivate_gram/sidePages/helpPage.dart';
import 'package:motivate_gram/sidePages/homepage.dart';
import 'package:motivate_gram/sidePages/myaccount.dart';
import 'package:motivate_gram/sidePages/settingPage.dart';

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
        yield MyAccount();
        break;

      case NavigationEvents.AboutClickedEvent:
        yield AboutPage();
        break;

      case NavigationEvents.ChatRoomClickedEvent:
        yield ChatScreen();
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