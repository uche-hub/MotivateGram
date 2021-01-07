import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_gram/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:motivate_gram/views/sideBar/meun_item.dart';
import 'package:motivate_gram/views/sidePage/homepage.dart';
import 'package:motivate_gram/widgets/provider_widget.dart';
import 'package:rxdart/rxdart.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar>{
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if(isAnimationCompleted){
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    }else{
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Color(0xff2c2b2c),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 300.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 58,
                          ),
                          ListTile(
                            title: AutoSizeText(
                              Provider.of(context).auth.getProfileName(),
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Langar'
                              ),
                            ),
                            subtitle: AutoSizeText(
                              Provider.of(context).auth.getProfileEmail(),
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Langar'
                              ),
                            ),
                            leading: CircleAvatar(
                              child: Provider.of(context).auth.getProfileImage(),
                              radius: 40,
                            ),
                          ),
                          Divider(
                            height: 64,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          MenuItem(
                            icon: Icons.home_outlined,
                            title: "Home",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.person_outline,
                            title: "My Profile",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.chat_outlined,
                            title: "Chat Room",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ChatRoomClickedEvent);
                            },
                          ),
                          Divider(
                            height: 64,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          MenuItem(
                            icon: Icons.settings_outlined,
                            title: "Setting",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.SettingClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.question_answer_outlined,
                            title: "About",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.AboutClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.help_outline,
                            title: "Help",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HelpClickedEvent);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Color(0xff2c2b2c),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_arrow,
                        color: Color(0xffc41a78),
                        size: 25,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}
