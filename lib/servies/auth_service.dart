import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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

  /// Reset password
  Future sendPasswordResetEmail(String email) async{
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Google
  Future<String> signInWithGoogle() async{
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googlgAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googlgAuth.idToken,
      accessToken: _googlgAuth.accessToken
    );
    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
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