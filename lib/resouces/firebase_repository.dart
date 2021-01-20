import 'package:firebase_auth/firebase_auth.dart';
import 'package:motivate_gram/models/user_list.dart';
import 'package:motivate_gram/resouces/firebaseMethods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<User> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateuser(User user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(User user) => _firebaseMethods.addDataToDb(user);

  /// Responsible for signOut
  Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<UserModel>> fetchAllUser(User user) =>
      _firebaseMethods.fetchAllUser(user);
}