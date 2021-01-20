import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motivate_gram/models/user_list.dart';
import 'package:motivate_gram/utils/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// User Class
  UserModel userModel = UserModel();

  Future<User> getCurrentUser() async{
    User currentUser;

    currentUser = await _auth.currentUser;
    return currentUser;
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
    return user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection("Users")
        .where("Email", isEqualTo: user.email)
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
    .collection("Users")
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
        await firestore.collection("Users").get();

    for(var i = 0; i < querySnapshot.docs.length; i++){
      if(querySnapshot.docs[i].id != currentUser.uid){
        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }
}