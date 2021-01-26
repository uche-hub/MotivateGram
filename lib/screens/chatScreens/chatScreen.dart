import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:motivate_gram/constants/String.dart';
import 'package:motivate_gram/models/message.dart';
import 'package:motivate_gram/models/user_list.dart';
import 'package:motivate_gram/resouces/firebase_repository.dart';
import 'package:motivate_gram/utils/universal_variables.dart';
import 'package:motivate_gram/widgets/appbar.dart';
import 'package:motivate_gram/widgets/custom_title.dart';

class ChatScreen extends StatefulWidget {
 final UserModel receiver;

 ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();

  FirebaseRepository _repository = FirebaseRepository();

  ScrollController _listScrollController = ScrollController();

  UserModel sender;

  String _currentUserId;

  FocusNode textFieldFocus = FocusNode();

  bool isWriting = false;

  bool showEmojiPicker = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = UserModel(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL
        );
      });
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker =true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(
            child: meassageList(),
          ),
          chatControls(),
          showEmojiPicker ? Container(child: emojiContainer()) : Container()
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        textEditingController.text = textEditingController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

  Widget meassageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
        .collection(MESSAGES_COLLECTION)
        .doc(_currentUserId)
        .collection(widget.receiver.uid)
        .orderBy(TIMESTAMP_FIELD, descending: true)
        .snapshots(),

      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.data == null) {
          return Center(child: CircularProgressIndicator(),);
        }

        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   _listScrollController.animateTo(
        //     _listScrollController.position.minScrollExtent,
        //     duration: Duration(milliseconds: 250),
        //     curve: Curves.easeInOut
        //   );
        // });

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.docs.length,
          reverse: true,
          controller: _listScrollController,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {

    Message _message = Message.fromMap(snapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId
        ? Alignment.centerRight : Alignment.centerLeft,
        child: _message.senderId == _currentUserId ? senderLayout(_message) : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.pinkColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius
        )
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Langar",
        fontSize: 16.0
      ),
    );
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65
      ),
      decoration: BoxDecoration(
          color: UniversalVariables.receiverColor,
          borderRadius: BorderRadius.only(
              bottomRight: messageRadius,
              topRight: messageRadius,
              bottomLeft: messageRadius
          )
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  addMediaModal(context) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.black,
      builder: (context) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  FlatButton(
                    child: Icon(
                      Icons.close,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Content and tools",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Langar",
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: ListView(
                children: [
                  ModalTile(
                    title: "Media",
                    subtitle: "Share Photos and Videos",
                    icon: Icons.image,
                  ),
                  ModalTile(
                    title: "File",
                    subtitle: "Share Files",
                    icon: Icons.tab,
                  ),
                  ModalTile(
                    title: "Contact",
                    subtitle: "Share Contact",
                    icon: Icons.contacts,
                  ),
                  ModalTile(
                    title: "Location",
                    subtitle: "Share a Location",
                    icon: Icons.add_location,
                  ),
                  ModalTile(
                    title: "Schedule Call",
                    subtitle: "Arrange a call and get reminders",
                    icon: Icons.schedule,
                  ),
                  ModalTile(
                    title: "Create Poll",
                    subtitle: "Share Poll",
                    icon: Icons.poll,
                  )
                ],
              ),
            )
          ],
        );
      }
    );
  }

  Widget chatControls(){
    setWritingTo(bool val){
      setState(() {
        isWriting = val;
      });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: UniversalVariables.pinkColor,
                  shape: BoxShape.circle
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(width: 5,),
          Expanded(
            child: Stack(
              children: [
                TextField(
                  controller: textEditingController,
                  focusNode: textFieldFocus,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Langar"
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "") ? setWritingTo(true) : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                      hintText: "Type A Message",
                      hintStyle: TextStyle(
                          color: UniversalVariables.greyColor,
                          fontFamily: "Langar"
                      ),
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(50.0)
                          ),
                          borderSide: BorderSide.none
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 45, vertical: 5),
                      filled: true,
                      fillColor: UniversalVariables.separatorColor,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: (){
                    if(!showEmojiPicker) {
                      /// Keyboard is visible
                      hideKeyboard();
                      showEmojiContainer();
                    }else {
                      /// Keyboard is hidden
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(Icons.emoji_emotions_outlined, color: UniversalVariables.pinkColor,),
                )
              ],
            ),
          ),
          isWriting ? Container() : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.record_voice_over_outlined, color: UniversalVariables.pinkColor,),
          ),
          isWriting ? Container() : Icon(Icons.camera_alt, color: UniversalVariables.pinkColor,),
          isWriting ? Container(margin: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: UniversalVariables.pinkColor,
              shape: BoxShape.circle
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () => sendMessage(),
            ),
          ) : Container()
        ],
      ),
    );
  }

  sendMessage(){
    var text = textEditingController.text;

    Message _message = Message(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      message: text,
      timeStamp: Timestamp.now(),
      type: 'text'
    );

    setState(() {
      isWriting = false;
    });

    textEditingController.text = "";

    _repository.addMessageToDb(_message, sender, widget.receiver);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: UniversalVariables.pinkColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: AutoSizeText(
        widget.receiver.name,
        maxLines: 1,
        style: TextStyle(
          fontFamily: "Langar"
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
            color: UniversalVariables.pinkColor,
          ),
          onPressed: (){},
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
            color: UniversalVariables.pinkColor,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.pinkColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
            fontFamily: "Langar"
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
            fontFamily: "Langar"
          ),
        ),
      ),
    );
  }
}

