import 'package:flock/graphql/user/mutation/changePassword.dart';
import 'package:flock/home/home.dart';
import 'package:flock/profile/header.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NewPassword extends StatefulWidget {
  final String phone;
  NewPassword(this.phone);
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: Text("Reset Password"),
        leading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0),
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _passwordController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Enter New Password",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 2.0)),
                ),
              ),
            ),
            Mutation(
              forgotPasswordChange,
              builder: (
                forgotPasswordChange, {
                bool loading,
                Map data,
                Exception error,
              }) {
                return RaisedButton(
                  onPressed: () {
                    //TODO: show loaidng icon here
                    forgotPasswordChange({
                      'phone': widget.phone,
                      'newPassword': _passwordController.text
                    });
                  },
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Text("Change Password"),
                  color: Colors.green,
                );
              },
              onCompleted: (Map<String, dynamic> data) {
                var route = MaterialPageRoute(
                    builder: (BuildContext context) => FlockHome());
                Navigator.of(context).pop();
                Navigator.of(context).push(route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
