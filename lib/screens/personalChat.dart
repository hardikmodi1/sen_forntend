import 'dart:async';

import 'package:flock/graphql/user/query/allUser.dart';
import 'package:flock/screens/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart' as loc;

class PersonalChat extends StatefulWidget {
  final String id, text;
  PersonalChat(this.id, {this.text});
  _PersonalChatState createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
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

  void redirect(String id, String username, String email, String image) {
    var route = MaterialPageRoute(
        builder: (BuildContext context) => ChatScreen(
              id,
              username,
              email,
              widget.id,
              image,
              isGroup: 0,
            ));
    Navigator.of(context).push(route);
  }

  List<dynamic> data1;

  @override
  Widget build(BuildContext context) {
    return _currentLocation == null
        ? Center(child: SpinKitFadingCircle(
            itemBuilder: (_, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.red : Colors.green,
                ),
              );
            },
          ))
        : Container(
            child: Query(allUser, variables: {
            'id': widget.id,
            'long': _currentLocation['longitude'],
            'lat': _currentLocation['latitude']
          }, builder: ({
            bool loading,
            Map data,
            Exception error,
          }) {
            print(widget.id);
            if (loading) {
              return Center(child: SpinKitFadingCircle(
                itemBuilder: (_, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.red : Colors.green,
                    ),
                  );
                },
              ));
            }
            if (error != null) {
              return Text("Some error fetching data");
            }
            if (data != null && data.length == 0) {
              return Text("No active user in your area!");
            }
            data1 = data['allUser'];
            if (widget.text != null && widget.text != "") {
              List<dynamic> temp = data1
                  .where((i) => i['username']
                      .toLowerCase()
                      .contains(widget.text.toLowerCase()))
                  .toList();
              data1 = temp;
            }
            if (data1 != null && data1.length == 0) {
              return Center(
                child: Text(
                  "No active user in this location!",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: data1.length,
              itemBuilder: (context, i) => Column(
                    children: <Widget>[
                      new Divider(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () => redirect(
                            data1[i]['id'],
                            data1[i]['username'],
                            data1[i]['email'],
                            data1[i]['image']),
                        child: ListTile(
                          leading: InkWell(
                            child: new Hero(
                              child: data1[i]['image'] != null
                                  ? CircleAvatar(
                                      foregroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          NetworkImage(data1[i]['image']),
                                    )
                                  : CircleAvatar(
                                      foregroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          AssetImage("assets/user.png"),
                                    ),
                              tag: data1[i]['id'],
                            ),
                            onTap: () {
                              Navigator.of(context).push(new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new Material(
                                        color: Colors.black38,
                                        child: new Container(
                                          padding: const EdgeInsets.all(30.0),
                                          child: new InkWell(
                                            child: new Hero(
                                              child: data1[i]['image'] != null
                                                  ? Image.network(
                                                      data1[i]['image'],
                                                      alignment:
                                                          Alignment.center,
                                                      fit: BoxFit.contain,
                                                      width: 300.0,
                                                      height: 300.0,
                                                    )
                                                  : Image.asset(
                                                      "assets/user.png",
                                                      alignment:
                                                          Alignment.center,
                                                      fit: BoxFit.contain,
                                                    ),
                                              tag: data1[i]['id'],
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ));
                                  }));
                            },
                          ),
                          title: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(
                                data1[i]['username'] == null
                                    ? data1[i]['email']
                                    : data1[i]['username'],
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
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
