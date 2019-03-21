import 'package:flock/profile/header.dart';
import 'package:flock/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/user/mutation/updateUsername.dart' as mutations;

//@TODO: Allows only username upto 25 characters long
class UpdateUsername extends StatefulWidget {
  final String username, id, imageurl, name;
  UpdateUsername(this.imageurl, this.name, this.username, this.id);
  _UpdateUsernameState createState() => _UpdateUsernameState();
}

class _UpdateUsernameState extends State<UpdateUsername> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.username != null)
      _controller = new TextEditingController(text: widget.username);
    else
      _controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xffededed),
      appBar: Header(
        title: Text("Update Username"),
        leading: false,
      ),
      body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(hintText: 'Username'),
                  ),
                  Mutation(mutations.updateUsername, builder: (
                    updateProfile, {
                    bool loading,
                    Map data,
                    Exception error,
                  }) {
                    return RaisedButton(
                      onPressed: () async {
                        updateProfile(
                            {'id': widget.id, 'username': _controller.text});
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        var route = MaterialPageRoute(
                            builder: (BuildContext context) => Profile(
                                widget.imageurl, widget.name, widget.id));
                        Navigator.of(context).push(route);
                      },
                      child: Text("OK"),
                    );
                  })
                ],
              ))),
    );
  }
}
