import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  Timestamp timeStamp;
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

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timeStamp'] = this.timeStamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  /// Member Function
  Message.fromMap(Map<String, dynamic> map) {

    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.type = map['type'];
    this.message = map['message'];
    this.timeStamp = map['timeStamp'];
    this.photoUrl = map['photoUrl'];
  }
}