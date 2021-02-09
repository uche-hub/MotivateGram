import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motivate_gram/models/user_list.dart';
import 'package:motivate_gram/resouces/firebase_repository.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  UserModel get getUser => _user;

  void refreshUser() async {
    UserModel user = await _firebaseRepository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}