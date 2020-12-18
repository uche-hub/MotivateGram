import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:motivate_gram/main.dart';
import 'package:motivate_gram/servies/auth_service.dart';
import 'package:motivate_gram/widgets/provider_widget.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:motivate_gram/widgets/verify_dialog.dart';

enum AuthFormType {
  signIn, signUp, reset
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
  String _email, _password, _name, _warning;

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

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  void submit() async{
    if(validate()){
      try{
        final auth = Provider.of(context).auth;
        if(authFormType == AuthFormType.signIn){
          String uid = await auth.signWithEmailAndPassword(_email, _password);
          print("Signed In with ID $uid");
          Navigator.of(context).pushReplacementNamed('/homePage');
        }else if(authFormType == AuthFormType.reset) {
          await auth.sendPasswordResetEmail(_email);
          print("Password reset email sent");
          _warning = "A Password reset link has been sent to $_email";
          setState(() {
            authFormType = AuthFormType.signIn;
          });
        }
        else{
          String uid = await auth.createUserWithEmailAndPassword(_email, _password, _name);
          print("Signed Up with New ID $uid");
          showDialog(
            context: context,
            builder: (BuildContext context) => VerifyDialog()
          );
          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyDialog()));
        }
      }catch(e){
        setState(() {
          _warning = e.message;
        });
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                SizedBox(height: _height * 0.025,),
                showAlert(),
                SizedBox(height: _height * 0.025,),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget showAlert() {
    if(_warning != null){
      return Container(
        color: Colors.black.withOpacity(.5),
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Langar'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white,),
                onPressed: (){
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(height: 0,);
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if(authFormType == AuthFormType.signUp){
      _headerText = "Create New Account";
    }else if(authFormType == AuthFormType.reset){
      _headerText = "Reset Password";
    }
    else{
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

    if(authFormType == AuthFormType.reset){
      textFields.add(
          TextFormField(
            validator: EmailValidator.validate,
            style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'Langar'
            ),
            decoration: buildSignUpInputDecoration("Email"),
            onSaved: (value) => _email = value,
          )
      );
      textFields.add(SizedBox(height: 20.0,));
      return textFields;
    }

    /// If we're in the sign up state add name
    if(authFormType == AuthFormType.signUp){
      textFields.add(
          TextFormField(
            validator: NameValidator.validate,
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
        validator: EmailValidator.validate,
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
          validator: PasswordValidator.validate,
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
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormType.signIn) {
      _swichButton = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    }else if(authFormType == AuthFormType.reset){
      _swichButton = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showSocial = false;
    }
    else{
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
      showForgotPassword(_showForgotPassword),
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
      ),
      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Langar'
          ),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: [
          Divider(
            color: Colors.white,
          ),
          SizedBox(height: 10,),
          GoogleSignInButton(
            onPressed: () async{
              try{
                await _auth.signInWithGoogle();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => VerifyDialog()
                );
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyDialog()));
              }catch(e){
                setState(() {
                  _warning = e.message;
                });
              }
            },
          )
        ],
      ),
      visible: visible,
    );
  }
}
