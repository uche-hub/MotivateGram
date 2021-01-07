import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:motivate_gram/views/bottomScreens/chatListScreen.dart';

class ChatRoomPage extends StatefulWidget with NavigationStates{
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  PageController pageController;
  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {

    double _labelFontSize = 10;

    return Scaffold(
      body: PageView(
        children: [
          Container(child: ChatListScreen(),),
          Center(
            child: Text("Call Logs Screen"),
          ),
          Center(
            child: Text("Contact Screen Screen"),
          )
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: CupertinoTabBar(
            backgroundColor: Colors.black.withOpacity(0.0),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.chat,
                  color: (_page == 0) ? Color(0xffc41a78) : Colors.grey
                ),
                title: Text(
                  "Chats",
                  style: TextStyle(
                    fontSize: _labelFontSize,
                    fontFamily: 'Langar',
                      color: (_page == 0) ? Color(0xffc41a78) : Colors.grey
                  ),
                )
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                      Icons.call,
                      color: (_page == 1) ? Color(0xffc41a78) : Colors.grey
                  ),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        fontFamily: 'Langar',
                        color: (_page == 1) ? Color(0xffc41a78) : Colors.grey
                    ),
                  )
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                      Icons.contact_phone,
                      color: (_page == 2) ? Color(0xffc41a78) : Colors.grey
                  ),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        fontFamily: 'Langar',
                        color: (_page == 2) ? Color(0xffc41a78) : Colors.grey
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
