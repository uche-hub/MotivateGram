import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motivate_gram/constants/String.dart';
import 'package:motivate_gram/models/message.dart';
import 'package:motivate_gram/models/user_list.dart';
import 'package:motivate_gram/provider/image_upload_provider.dart';
import 'package:motivate_gram/utils/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final CollectionReference _userCollection = _firestore.collection(USERS_COLLECTION);

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Reference _storageReference;

  String name;
  String email;
  String imageUrl;

  /// User Class
  UserModel userModel = UserModel();

  Future<User> getCurrentUser() async{
    User currentUser;

    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<UserModel> getUserDetails() async {
    User currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _userCollection.doc(currentUser.uid).get();
    return UserModel.fromMap(documentSnapshot.data());
  }

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken
    );

    User user = (await _auth.signInWithCredential(credential)).user;

    if(user != null){
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;

      print(name);
      print(email);
    }

    return user;
  }

  getProfileName() {
    if(_auth.currentUser.displayName != null) {
      return _auth.currentUser.displayName;
    }
  }

  getProfileEmail() {
    if(_auth.currentUser.email != null) {
      return _auth.currentUser.email;
    }
  }

  getProfileImage() {
    if(_auth.currentUser.photoURL != null) {
      return _auth.currentUser.photoURL;
    }
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    /// If user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {

    String username = Utils.getUsername(currentUser.email);

    userModel = UserModel(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoURL,
      username: username
    );

    firestore
    .collection(USERS_COLLECTION)
    .doc(currentUser.uid)
    .set(userModel.toMap(userModel));
  }

  Future<void> signOut() async{
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<UserModel>> fetchAllUser(User currentUser) async{
    List<UserModel> userList = List<UserModel>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();

    for(var i = 0; i < querySnapshot.docs.length; i++){
      if(querySnapshot.docs[i].id != currentUser.uid){
        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(Message message, UserModel sender, UserModel receiver) async{
     var map = message.toMap();

     await firestore
     .collection(MESSAGES_COLLECTION)
     .doc(message.senderId)
     .collection(message.receiverId)
     .add(map);

     return await firestore
         .collection(MESSAGES_COLLECTION)
         .doc(message.receiverId)
         .collection(message.senderId)
         .add(map);
  }

  Future<String> uploadImageToStorage(File image) async{
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().microsecondsSinceEpoch}');

      UploadTask _storageUploadTask = _storageReference.putFile(image);

      var url = await (await _storageUploadTask).ref.getDownloadURL();
      print(url);
      return url;
    }catch(e) {
      print(e);
      return null;
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;

    _message = Message.imageMessage(
      message: 'IMAGE',
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timeStamp: Timestamp.now(),
      type: 'image'
    );

    var map = _message.toImageMap();

    /// Set the data to database
    await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  void uploadImage(File image, String receiverId, String senderId, ImageUploadProvider imageProvider) async{
    imageProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    imageProvider.setTOIdle();
    setImageMsg(url, receiverId, senderId);
  }
}