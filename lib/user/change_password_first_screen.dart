import 'package:flock/graphql/user/mutation/sendOTP.dart';
import 'package:flock/profile/header.dart';
import 'package:flock/user/EnterOTP.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ChangePasswordFirst extends StatelessWidget {
  final String id, email;
  ChangePasswordFirst(this.id, this.email);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: Text("Change Password"),
        leading: true,
      ),
      body: Center(
        child: Mutation(
          sendForgotPasswordEmail,
          builder: (
            sendForgotPasswordEmail, {
            bool loading,
            Map data,
            Exception error,
          }) {
            return MaterialButton(
              onPressed: () {
                //TODO: show loaidng icon here
                sendForgotPasswordEmail({'email': email});
              },
              child: Text("Click here to send OTP"),
              color: Colors.green,
            );
          },
          onCompleted: (Map<String, dynamic> data) {
            //TODO: hide loading icon here.
            var route = MaterialPageRoute(
                builder: (BuildContext context) => EnterOTP(email));
            Navigator.of(context).push(route);
          },
        ),
      ),
    );
  }
}
