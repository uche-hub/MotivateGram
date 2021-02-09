import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:motivate_gram/navigationBloc/navigation_bloc.dart';
import 'package:motivate_gram/provider/user_provider.dart';
import 'package:motivate_gram/screens/pageview/chat_list_screen.dart';
import 'package:motivate_gram/screens/pickup/pick_layout.dart';
import 'package:motivate_gram/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class ChatScreenPage extends StatefulWidget with NavigationStates{
  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  PageController pageController;
  int _page = 0;

  UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });

    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {

    double _labeFontSize = 10;

    return PickupLayout(
      scaffold: Scaffold(
        body: PageView(
          children: [
            Container(child: ChatListScreen(),),
            Center(child: Text("Call Log"),),
            Center(child: Text("Contact Screen"),),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: CupertinoTabBar(
              backgroundColor: Colors.black12,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat,
                        color: (_page == 0)
                            ? UniversalVariables.pinkColor
                            : UniversalVariables.greyColor
                    ),
                    title: Text(
                      "Chats",
                      style: TextStyle(
                          fontSize: _labeFontSize,
                          fontFamily: "Langar",
                          color: (_page == 0)
                              ? UniversalVariables.pinkColor
                              : UniversalVariables.greyColor
                      ),
                    )
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.call,
                        color: (_page == 1)
                            ? UniversalVariables.pinkColor
                            : UniversalVariables.greyColor
                    ),
                    title: Text(
                      "Calls",
                      style: TextStyle(
                          fontSize: _labeFontSize,
                          fontFamily: "Langar",
                          color: (_page == 1)
                              ? UniversalVariables.pinkColor
                              : UniversalVariables.greyColor
                      ),
                    )
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contact_phone,
                        color: (_page == 2)
                            ? UniversalVariables.pinkColor
                            : UniversalVariables.greyColor
                    ),
                    title: Text(
                      "Contacts",
                      style: TextStyle(
                          fontSize: _labeFontSize,
                          fontFamily: "Langar",
                          color: (_page == 2)
                              ? UniversalVariables.pinkColor
                              : UniversalVariables.greyColor
                      ),
                    )
                )
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
