import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/resouces/firebase_repository.dart';
import 'package:motivate_gram/screens/login_screen.dart';
import 'package:motivate_gram/sidePages/homepage.dart';
import 'package:motivate_gram/sidebar/sidebar_layout.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MotivateGram',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: FutureBuilder(
          future: _repository.getCurrentUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if(snapshot.hasData){
              return SideBarLayout();
            }else{
              return LoginPage();
            }
          },
        ),
      );
  }
}