import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/navigationBloc/navigation_bloc.dart';
import 'package:motivate_gram/screens/pageview/chat_list_screen.dart';
import 'package:motivate_gram/utils/universal_variables.dart';

class ChatScreen extends StatefulWidget with NavigationStates{
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  PageController pageController;
  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    return Scaffold(
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
    );
  }
}
