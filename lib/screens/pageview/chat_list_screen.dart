import 'package:flutter/material.dart';
import 'package:motivate_gram/resouces/firebase_repository.dart';
import 'package:motivate_gram/utils/universal_variables.dart';
import 'package:motivate_gram/utils/utilities.dart';
import 'package:motivate_gram/widgets/appbar.dart';
import 'package:motivate_gram/widgets/custom_title.dart';

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
          return CustomTile(
            mini: false,
            onTap: () {},
            title: Text(
              "Uchenna Ndukwe",
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
                  fontFamily: "Langar",
                  fontSize: 14
              ),
            ),
            leading: Container(
              constraints: BoxConstraints(
                maxHeight: 60,
                maxWidth: 60
              ),
              child: Stack(
                children: [
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage("https://images.unsplash.com/photo-1586083702768-190ae093d34d?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=395&q=80"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: UniversalVariables.onlineDotColor,
                        border: Border.all(
                          color: Colors.black,
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
