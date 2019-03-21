import 'package:flock/profile/header.dart';
import 'package:flock/profile/profile.dart';
import 'package:flock/screens/groupDetails.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/groups/mutation/updateGroupDescription.dart' as mutations;

//@TODO: Allows only username upto 25 characters long
class UpdateDescription extends StatefulWidget {
  final String description, id, image, currentUserId;
  UpdateDescription(this.description, this.id, this.image, this.currentUserId);
  _UpdateDescriptionState createState() => _UpdateDescriptionState();
}

class _UpdateDescriptionState extends State<UpdateDescription> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.description != null)
      _controller = new TextEditingController(text: widget.description);
    else
      _controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xffededed),
      appBar: Header(
        title: Text("Group Description"),
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
                    decoration:
                        InputDecoration(hintText: 'Add group description'),
                  ),
                  Mutation(mutations.updateGroup, builder: (
                    updateDescription, {
                    bool loading,
                    Map data,
                    Exception error,
                  }) {
                    return RaisedButton(
                      onPressed: () async {
                        updateDescription({
                          'groupId': widget.id,
                          'description': _controller.text
                        });
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        var route = MaterialPageRoute(
                            builder: (BuildContext context) => GroupDetail(
                                widget.id, widget.image, widget.currentUserId));
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
