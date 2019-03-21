import 'package:flock/profile/header.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/groups/query/addGroupList.dart' as query;
import '../graphql/groups/mutation/addToGroup.dart' as mutation;
import './groupDetails.dart';

class AddToGroup extends StatefulWidget {
  final String groupId, image, currentUserId;
  AddToGroup(this.groupId, this.image, this.currentUserId);
  _AddToGroupState createState() => _AddToGroupState();
}

class _AddToGroupState extends State<AddToGroup> {
  List<String> selected = new List<String>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: Text("Add to group"),
        leading: true,
      ),
      body: Query(query.addGroupList, variables: {'groupId': widget.groupId},
          builder: ({
        bool loading,
        Map data,
        Exception error,
      }) {
        if (loading) {
          return Text("Loading...");
        }
        if (error != null) {
          return Text("Some error fetching data");
        }
        if (data != null && data.length == 0) {
          return Text("No active user in your area!");
        }
        return ListView.builder(
          itemCount: data['addGroupList'].length,
          itemBuilder: (context, i) => Column(
                children: <Widget>[
                  new Divider(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (selected.contains(data['addGroupList'][i]['id'])) {
                        setState(() {
                          selected.remove(data['addGroupList'][i]['id']);
                        });
                      } else {
                        setState(() {
                          selected.add(data['addGroupList'][i]['id']);
                        });
                      }
                    },
                    child: ListTile(
                      leading: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            foregroundColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.grey,
                            backgroundImage: data['addGroupList'][i]['image'] !=
                                    null
                                ? NetworkImage(data['addGroupList'][i]['image'])
                                : AssetImage("assets/user.png"),
                          ),
                          selected != null &&
                                  selected
                                      .contains(data['addGroupList'][i]['id'])
                              ? Positioned(
                                  left: 20.0,
                                  top: 20.0,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).primaryColor,
                                    size: 20.0,
                                  ),
                                )
                              : Text(''),
                        ],
                      ),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            data['addGroupList'][i]['username'] == null
                                ? data['addGroupList'][i]['email']
                                : data['addGroupList'][i]['username'],
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
        );
      }),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return Mutation(mutation.addToGroup, builder: (
          addToGroup, {
          bool loading,
          Map data,
          Exception error,
        }) {
          return FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              if (selected.length != 0) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    });
                addToGroup({'groupId': widget.groupId, 'members': selected});
              }
              var route = MaterialPageRoute(
                  builder: (BuildContext context) => GroupDetail(
                      widget.groupId, widget.image, widget.currentUserId));
              Navigator.of(context).pop();
              Navigator.of(context).push(route);
            },
            child: new Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          );
        });
      }),
    );
  }
}
