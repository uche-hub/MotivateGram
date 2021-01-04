import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/servies/auth_service.dart';
import 'package:motivate_gram/views/first_view.dart';
import 'package:motivate_gram/views/sideBar/sidebar_layout.dart';
import 'package:motivate_gram/views/sign_up_view.dart';
import 'package:motivate_gram/widgets/provider_widget.dart';
import 'package:motivate_gram/widgets/verify_dialog.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'MotivateGram',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/signUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp,),
          '/signIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn,),
          '/homePage': (BuildContext context) => HomeController(),
          'verifyDialog': (BuildContext context) => VerifyDialog()
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final bool signedIn = snapshot.hasData;
          return signedIn ? SideBarLayout() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}