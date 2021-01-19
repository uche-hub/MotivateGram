import 'package:flutter/material.dart';
import 'package:motivate_gram/resouces/firebase_repository.dart';
import 'package:motivate_gram/utils/universal_variables.dart';
import 'package:motivate_gram/utils/utilities.dart';
import 'package:motivate_gram/widgets/appbar.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

/// Global
final FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  String currentUserId;
  String initials;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user) {
      currentUserId = user.uid;
      initials = Utils.getInitials(user.displayName);
    });
  }

  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: UniversalVariables.pinkColor,
          ),
          onPressed: (){},
        ),
        title: UserCircle(initials),
      centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: UniversalVariables.pinkColor,
              ),
              onPressed: (){}
          ),
          IconButton(
              icon: Icon(
                Icons.more_vert,
                color: UniversalVariables.pinkColor,
              ),
              onPressed: (){}
          )
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
          return CustomTile();
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
        borderRadius: BorderRadius.circular(50),
        color: UniversalVariables.separatorColor
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              text != null ? text : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.lightBlueColor,
                fontSize: 13,
                fontFamily: "Langar"
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
                  color: Colors.black12,
                  width: 2
                ),
                color: UniversalVariables.onlineDotColor
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
        color: UniversalVariables.pinkColor,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
