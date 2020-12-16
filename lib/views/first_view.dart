import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/widgets/custom_dialog.dart';

class FirstView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
            color: const Color(0xff000000),
          image: DecorationImage(
            image: AssetImage("assets/images/thought.jpg"),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(.5), BlendMode.dstATop),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: _height * 0.10),
                Text("MotivateGram",
                  style: TextStyle(
                    fontFamily: 'Langar',
                    fontSize: 44,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: _height * 0.10),
                AutoSizeText(
                  "Create And Post Your Own Quotes",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Langar',
                    color: Colors.white
                  ),
                ),
                SizedBox(height: _height * 0.15),
                RaisedButton(
                  color: Colors.green.withOpacity(.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontFamily: 'Langar',
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                            title: "Create A Free Account",
                            description: "With an account, your data will be securely saved, allowing you to access it from multiple devices.",
                            primaryButtonText: "Create Account",
                            primaryButtonRoute: "/signUp",
                        )
                    );
                  },
                ),
                SizedBox(height: _height * 0.05),
                FlatButton(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Langar',
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed("/signIn");
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}