import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/servies/auth_service.dart';
import 'package:motivate_gram/utils/utilities.dart';
import 'package:motivate_gram/widgets/appbar.dart';
import 'package:motivate_gram/widgets/custom_tile.dart';
import 'package:motivate_gram/widgets/provider_widget.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

///Global
final AuthService _authService = AuthService();

class _ChatListScreenState extends State<ChatListScreen> {

  String currentUserId;
  String initials;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authService.userSetup().then((user) async{
      setState(() {
        currentUserId = Provider.of(context).auth.getUserId();
        initials = Utils.getInitials(Provider.of(context).auth.getProfileName());
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications_none_outlined,
          color: Color(0xffc41a78),
        ),
        onPressed: (){},
      ),
      title: UserCircle(initials),
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(
              Icons.search,
              color: Color(0xffc41a78),
            ),
            onPressed: (){}),
        IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Color(0xffc41a78),
            ),
            onPressed: (){}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(currentUserId),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;

  ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomTile(
            mini: false,
            onTap: (){},
            title: Text(
              Provider.of(context).auth.getProfileName(),
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Langar",
                fontSize: 19
              ),
            ),
            subtitle: Text(
              "Hello",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'Langar'
              ),
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: [
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.black,
                    backgroundImage: Provider.of(context).auth.getProfileImage(),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 2
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class UserCircle extends StatelessWidget {
  final String text;

  UserCircle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Color(0xffc41a78),
        borderRadius: BorderRadius.circular(50)
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              text != null ? text : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Langar',
                fontSize: 13
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 2
                ),
                color: Colors.green
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffc41a78),
        borderRadius: BorderRadius.circular(50)
      ),
      child: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
