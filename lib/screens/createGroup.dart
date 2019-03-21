import 'package:flock/profile/header.dart';
import 'package:flock/screens/finalGroup.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/user/query/allUser.dart';

class CreateGroup extends StatefulWidget {
  final String id;
  CreateGroup(this.id);
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<String> selected = new List<String>();

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
      print(_currentLocation["latitude"]);
      print(_currentLocation["longitude"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: Text("Create Group"),
        leading: true,
      ),
      body: _currentLocation == null
          ? Text("Fetching location...")
          : Query(allUser, variables: {
              'id': widget.id,
              'lat': _currentLocation['latitude'],
              'long': _currentLocation['longitude']
            }, builder: ({
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
                itemCount: data['allUser'].length,
                itemBuilder: (context, i) => Column(
                      children: <Widget>[
                        new Divider(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (selected.contains(data['allUser'][i]['id'])) {
                              setState(() {
                                selected.remove(data['allUser'][i]['id']);
                              });
                            } else {
                              setState(() {
                                selected.add(data['allUser'][i]['id']);
                              });
                            }
                          },
                          child: ListTile(
                            leading: Stack(
                              children: <Widget>[
                                CircleAvatar(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      data['allUser'][i]['image'] != null
                                          ? NetworkImage(
                                              data['allUser'][i]['image'])
                                          : AssetImage("assets/user.png"),
                                ),
                                selected != null &&
                                        selected
                                            .contains(data['allUser'][i]['id'])
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
                                  data['allUser'][i]['username'] == null
                                      ? data['allUser'][i]['email']
                                      : data['allUser'][i]['username'],
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold),
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
        return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            if (selected.length == 0) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: new Text("Atleast 1 contact must be selected"),
              ));
            } else {
              var route = MaterialPageRoute(
                  builder: (BuildContext context) =>
                      FinalGroup(selected, widget.id));
              Navigator.of(context).push(route);
            }
          },
          child: new Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        );
      }),
    );
  }
}
