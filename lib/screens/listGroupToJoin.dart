import 'package:flock/graphql/groups/query/fetchGroupToJoin.dart';
import 'package:flock/screens/joinGroup.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:flutter/services.dart';

class ListGroupToJoin extends StatefulWidget {
  final String id;
  ListGroupToJoin(this.id);
  _ListGroupToJoinState createState() => _ListGroupToJoinState();
}

class _ListGroupToJoinState extends State<ListGroupToJoin> {
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

  void redirect(String groupId, String id) {
    var route = MaterialPageRoute(
        builder: (BuildContext context) => JoinGroup(groupId, id));
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Group"),
      ),
      body: Container(
          child: _currentLocation == null
              ? Text("Fetching Location")
              : Query(fetchGroupToJoin, variables: {
                  'id': widget.id,
                  'long': _currentLocation['longitude'],
                  'lat': _currentLocation['latitude']
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
                  if (data != null && data['fetchGroupToJoin'].length == 0) {
                    return Text("No active group in your area!");
                  }
                  return ListView.builder(
                    itemCount: data['fetchGroupToJoin'].length,
                    itemBuilder: (context, i) => Column(
                          children: <Widget>[
                            new Divider(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: () => redirect(
                                  data['fetchGroupToJoin'][i]['_id'],
                                  widget.id),
                              child: ListTile(
                                leading: CircleAvatar(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: data['fetchGroupToJoin'][i]
                                              ['iconLink'] !=
                                          null
                                      ? NetworkImage(data['fetchGroupToJoin'][i]
                                          ['iconLink'])
                                      : AssetImage("assets/group.png"),
                                ),
                                title: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                      data['fetchGroupToJoin'][i]['name'],
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
                })),
    );
  }
}
