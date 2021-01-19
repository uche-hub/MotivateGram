import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/animations/fade_animation.dart';
import 'package:motivate_gram/resouces/firebase_repository.dart';
import 'package:motivate_gram/sidebar/sidebar_layout.dart';
import 'package:motivate_gram/utils/universal_variables.dart';
import 'package:shimmer/shimmer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{
  FirebaseRepository _repository = FirebaseRepository();

  bool isLoginpressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          titleText(),
          loginButton(),
          isLoginpressed
          ? Center(
            child: CircularProgressIndicator(),
          ): Container()
        ],
      ),
    );
  }

  Widget titleText() {
    return Column(
        children: [
          FadeAnimation(
            2,
              AutoSizeText(
                "Welcome To,",
                maxLines: 1,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontFamily: "Langar"
                ),
              )
          ),
          FadeAnimation(
            3,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    "Motivate",
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontFamily: "Langar"
                    ),
                  ),
                  AutoSizeText(
                    "Gram",
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 40,
                        color: Color(0xffc41a78),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontFamily: "Langar"
                    ),
                  )
                ],
              )
          )
        ],
      );
  }

  Widget loginButton() {
    return FadeAnimation(
      4,
        Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: UniversalVariables.pinkColor,
          child: FlatButton(
            padding: EdgeInsets.all(35),
            child: Text(
              "LOGIN",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  fontFamily: "Langar"
              ),
            ),
            onPressed: () => performLogin(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        )
    );
  }

  void performLogin() {
    setState(() {
      isLoginpressed = true;
    });
    _repository.signIn().then((User user) {
      if(user != null){
        authenticateUser(user);
      }else{
        print("Error");
      }
    });
  }

  void authenticateUser(User user) {
    _repository.authenticateuser(user).then((isNewUser) {

      setState(() {
        isLoginpressed = false;
      });

      if(isNewUser){
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return SideBarLayout();
            }));
        });
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return SideBarLayout();
        }));
      }
    });
  }
}
