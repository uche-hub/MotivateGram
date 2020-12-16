import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<String> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
      (User user) => user?.uid,
  );

  /// Email & Password Sign Up
  Future<String>  createUserWithEmailAndPassword(String email, String password, String name) async{
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );

    /// Update the Username
    await updateUserName(name, authResult.user);
    return authResult.user.uid;
  }

  Future updateUserName(String name, User currentUser) async{
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();
  }

  /// Email & Password Sign IN
  Future<String> signWithEmailAndPassword(String email, String password)async{
    return (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user.uid;
  }

  /// Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }
}

class NameValidator {
  static String validate(String value) {
    if(value.isEmpty){
      return "Name Can't be empty";
    }
    if(value.length < 2){
      return "Name must be at least 2 characters long";
    }
    if(value.length > 50){
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if(value.isEmpty){
      return "Email Can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if(value.isEmpty){
      return "Password Can't be empty";
    }
    return null;
  }
}