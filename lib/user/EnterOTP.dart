import 'package:flock/graphql/user/mutation/checkOTP.dart';
import 'package:flock/profile/header.dart';
import 'package:flock/user/new_password.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EnterOTP extends StatefulWidget {
  final String email;
  EnterOTP(this.email);
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  TextEditingController _otpController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: Text("Enter OTP"),
        leading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0),
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                controller: _otpController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 2.0)),
                ),
              ),
            ),
            Mutation(
              checkOTP,
              builder: (
                checkOTP, {
                bool loading,
                Map data,
                Exception error,
              }) {
                return RaisedButton(
                  onPressed: () {
                    //TODO: show loaidng icon here
                    print(int.parse(_otpController.text));
                    checkOTP({
                      'email': widget.email,
                      'OTP': int.parse(_otpController.text)
                    });
                  },
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Text("Verify OTP"),
                  color: Colors.green,
                );
              },
              onCompleted: (Map<String, dynamic> data) {
                print(data);
                if (data['checkOTP'] == null) {
                  var route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          NewPassword(widget.email));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(route);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
