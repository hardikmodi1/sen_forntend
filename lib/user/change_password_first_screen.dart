import 'package:flock/graphql/user/mutation/sendOTP.dart';
import 'package:flock/profile/header.dart';
import 'package:flock/user/EnterOTP.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ChangePasswordFirst extends StatelessWidget {
  final String id, phone;
  ChangePasswordFirst(this.id, this.phone);
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
                sendForgotPasswordEmail({'phone': phone});
              },
              child: Text("Click here to send OTP"),
              color: Colors.green,
            );
          },
          onCompleted: (Map<String, dynamic> data) {
            //TODO: hide loading icon here.
            var route = MaterialPageRoute(
                builder: (BuildContext context) => EnterOTP(phone));
            Navigator.of(context).push(route);
          },
        ),
      ),
    );
  }
}
