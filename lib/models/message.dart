import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  FieldValue timeStamp;
  String photoUrl;

  Message({
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.timeStamp
  });

  /// Will be called when you wish to send am image
  Message.imageMessage({
     this.senderId,
    this.receiverId,
    this.message,
    this.type,
    this.timeStamp,
    this.photoUrl
  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timeStamp'] = this.timeStamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    Message _message = Message();
    _message.senderId = map['senderId'];
    _message.receiverId = map['receiverId'];
    _message.type = map['type'];
    _message.message = map['message'];
    _message.timeStamp = map['timeStamp'];
    return _message;
  }
}