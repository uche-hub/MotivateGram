import 'package:flutter/material.dart';
import 'package:motivate_gram/models/call.dart';
import 'package:motivate_gram/resouces/call_methods.dart';

class CallScreen extends StatefulWidget {
  final Call call;


  CallScreen({
    @required this.call
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Call Has Been Made"
            ),
            MaterialButton(
              color: Colors.red,
              child: Icon(
                Icons.call_end,
                color: Colors.white,
              ),
              onPressed: () async => await callMethods.endCall(call: widget.call),
            )
          ],
        ),
      ),
    );
  }
}
