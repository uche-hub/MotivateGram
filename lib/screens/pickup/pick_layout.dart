import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/models/call.dart';
import 'package:motivate_gram/provider/user_provider.dart';
import 'package:motivate_gram/resouces/call_methods.dart';
import 'package:motivate_gram/screens/pickup/pick_screen.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    @required this.scaffold
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (userProvider != null && userProvider.getUser != null) ? StreamBuilder<DocumentSnapshot>(
      stream: callMethods.callStream(uid: userProvider.getUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.data() != null) {
          Call call = Call.fromMap(snapshot.data.data());
          return PickupScreen(call: call);
        }
        return scaffold;
      },
    ) : Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
