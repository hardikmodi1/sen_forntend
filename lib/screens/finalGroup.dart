import 'dart:async';

import 'package:flock/home/home.dart';
import 'package:flock/profile/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart' as loc;

import '../graphql/groups/mutation/createGroup.dart' as mutations;
import '../shared/uploadImage.dart' as upload;

class FinalGroup extends StatefulWidget {
  final List<String> selected;
  final String id;
  FinalGroup(this.selected, this.id);
  _FinalGroupState createState() => _FinalGroupState();
}

class _FinalGroupState extends State<FinalGroup> {
  TextEditingController groupNameController = new TextEditingController();

  String url;
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Map<String, double> _currentLocation;

  getLocation() async {
    Map<String, double> _startLocation;

    StreamSubscription<Map<String, double>> _locationSubscription;
    loc.Location _location = new loc.Location();
    bool _permission = false;
    String error;

    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      print(error);

      location = null;
    }
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        _currentLocation = result;
      });
      _locationSubscription.cancel();
      print("kl");
      print(_currentLocation["latitude"]);
      print(_currentLocation["longitude"]);
    });
  }

  void _settingModalBottomSheet(BuildContext context, String name) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Group icon",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text("Camera"),
                        onTap: () {
                          upload.upload(name, 0).then((onValue) {
                            if (onValue != null) {
                              setState(() {
                                url = onValue;
                              });
                              print("fdfdfdfd" + url);
                            }
                          });
                        }),
                    ListTile(
                      leading: Icon(
                        Icons.image,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text("Gallery"),
                      onTap: () {
                        upload.upload(name, 1).then((onValue) {
                          if (onValue != null) {
                            setState(() {
                              url = onValue;
                            });
                            print("fdfdfdfd" + url);
                          }
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffededed),
      appBar: Header(
        title: Text("New Group"),
        leading: true,
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Container(
              width: double.infinity,
              height: 100.0,
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        _settingModalBottomSheet(context, "Group_profile");
                      },
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.grey.withOpacity(0.4),
                        child: url != null
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(url))),
                              )
                            : Icon(
                                Icons.camera_alt,
                                size: 30.0,
                                color: Colors.white,
                              ),
                      )),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TextField(
                        controller: groupNameController,
                        decoration:
                            InputDecoration(hintText: 'Add group name...'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Mutation(mutations.createGroup, builder: (
            createGroup, {
            bool loading,
            Map data,
            Exception error,
          }) {
            return RaisedButton(
              onPressed: () {
                if (groupNameController.text.isNotEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  createGroup({
                    'name': groupNameController.text,
                    'iconLink': url,
                    'creator': widget.id,
                    'members': widget.selected,
                    'long': _currentLocation['longitude'],
                    'lat': _currentLocation['latitude']
                  });
                  var route = MaterialPageRoute(
                      builder: (BuildContext context) => FlockHome());
                  Navigator.of(context).pop();
                  Navigator.of(context).push(route);
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: new Text("Add sujbect to the group"),
                  ));
                }
              },
              child: Text("Create Group"),
            );
          })
        ],
      ),
    );
  }
}
