import 'package:flock/graphql/groups/query/fetchGroup.dart';
import 'package:flock/screens/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart' as loc;
import 'dart:async';
import 'package:flutter/services.dart';

class GroupChat extends StatefulWidget {
  final String id, text;
  GroupChat(this.id, {this.text});
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  List<dynamic> data1;

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

  void redirect(String id, String username, String image) {
    var route = MaterialPageRoute(
        builder: (BuildContext context) => ChatScreen(
              id,
              username,
              "group",
              widget.id,
              image,
              isGroup: 1,
            ));
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _currentLocation == null
            ? Text("Fetching Location")
            : Query(fetchGroup, variables: {
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
                if (data != null && data['fetchGroup'].length == 0) {
                  return Text("No active group in your area!");
                }
                print(data.length);
                data1 = data['fetchGroup'];
                if (widget.text != null && widget.text != "") {
                  List<dynamic> temp = data1
                      .where((i) => i['name']
                          .toLowerCase()
                          .contains(widget.text.toLowerCase()))
                      .toList();
                  data1 = temp;
                }
                return ListView.builder(
                  itemCount: data1.length,
                  itemBuilder: (context, i) => Column(
                        children: <Widget>[
                          new Divider(
                            height: 10.0,
                          ),
                          GestureDetector(
                            onTap: () => redirect(data1[i]['_id'],
                                data1[i]['name'], data1[i]['iconLink']),
                            child: ListTile(
                              leading: CircleAvatar(
                                foregroundColor: Theme.of(context).primaryColor,
                                backgroundColor: Colors.grey,
                                backgroundImage: data1[i]['iconLink'] != null
                                    ? NetworkImage(data1[i]['iconLink'])
                                    : AssetImage("assets/group.png"),
                              ),
                              title: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    data1[i]['name'],
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
              }));
  }
}
