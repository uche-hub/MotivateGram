import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:motivate_gram/main.dart';
import 'package:motivate_gram/servies/auth_service.dart';
import 'package:motivate_gram/widgets/provider_widget.dart';

enum AuthFormType {
  signIn, signUp
}

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, @required this.authFormType}) : super(key: key);
  @override
  _SignUpViewState createState() => _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name;

  void swichFormState(String state) {
    formKey.currentState.reset();
    if(state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    }else{
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  void submit() async{
    final form = formKey.currentState;
    form.save();
    try{
      final auth = Provider.of(context).auth;
      if(authFormType == AuthFormType.signIn){
        String uid = await auth.signWithEmailAndPassword(_email, _password);
        print("Signed In with ID $uid");
        Navigator.of(context).pushReplacementNamed('/home');
      }else{
        String uid = await auth.createUserWithEmailAndPassword(_email, _password, _name);
        print("Signed Up with New ID $uid");
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: const Color(0xff000000),
            image: DecorationImage(
                image: AssetImage("assets/images/thought.jpg"),
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(.5), BlendMode.dstATop),
                fit: BoxFit.cover
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: _width,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: _height * 0.05,),
              buildHeaderText(),
              SizedBox(height: _height * 0.05,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: buildInputs() + buildButtons(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if(authFormType == AuthFormType.signUp){
      _headerText = "Create New Account";
    }else{
      _headerText = "Sign In";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 35,
          color: Colors.white,
          fontFamily: 'Langar'
      ),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    /// If we're in the sign up state add name
    if(authFormType == AuthFormType.signUp){
      textFields.add(
          TextFormField(
            style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'Langar'
            ),
            decoration: buildSignUpInputDecoration("Name"),
            onSaved: (value) => _name = value,
          )
      );
      textFields.add(SizedBox(height: 20.0,));
    }

    /// Add Email & Password
    textFields.add(
      TextFormField(
        style: TextStyle(
          fontSize: 22.0,
          fontFamily: 'Langar'
        ),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      )
    );

    textFields.add(SizedBox(height: 20.0,));

    textFields.add(
        TextFormField(
          style: TextStyle(
              fontSize: 22.0,
              fontFamily: 'Langar'
          ),
          decoration: buildSignUpInputDecoration("Password"),
          obscureText: true,
          onSaved: (value) => _password = value,
        )
    );
    textFields.add(SizedBox(height: 20.0,));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint){
    return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white,
                width: 0.0
            )
        ),
        contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0)
    );
  }

  List<Widget> buildButtons() {
    String _swichButton, _newFormState, _submitButtonText;
    if (authFormType == AuthFormType.signIn) {
      _swichButton = "Create new Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
    }else{
      _swichButton = "Have an account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
          ),
          color: Colors.green.withOpacity(0.7),
          textColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_submitButtonText, style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Langar'
            ),),
          ),
          onPressed: submit,
        ),
      ),
      FlatButton(
        child: Text(
          _swichButton,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Langar'
          ),
        ),
        onPressed: () {
          swichFormState(_newFormState);
        },
      )
    ];
  }
}
