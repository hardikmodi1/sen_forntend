import 'dart:async';

import 'package:flock/eventsTab/eventDetailScreen.dart';
import 'package:flock/graphql/events/mutation/likeOrDislike.dart';
import 'package:flock/graphql/events/query/fetchEventsToJoin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart' as loc;

class Events extends StatefulWidget {
  final String id;
  Events(this.id);
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
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
      print("dedededed");
      print(_currentLocation["latitude"]);
      print(_currentLocation["longitude"]);
    });
  }

  int current;
  Map data1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _currentLocation == null
          ? Text("Fetching location...")
          : Query(fetchEventsToJoin, variables: {
              'id': widget.id,
              'long': _currentLocation['longitude'],
              'lat': _currentLocation['latitude']
            }, builder: ({
              bool loading,
              Map data,
              Exception error,
            }) {
              if (loading || error != null) {
                print(error);
                return Text("Loading...");
              }
              data1 = data;
              return new Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: GestureDetector(
                        child: Mutation(likeOrDislike, builder: (
                          likeOrDislike, {
                          bool loading,
                          Map data,
                          Exception error,
                        }) {
                          return TinderSwapCard(
                            swipeCompleteCallback: (cardSwipeOrientation) {
                              print(current);
                              print(data1['fetchEventsToJoin'][current]['_id']);
                              if (cardSwipeOrientation ==
                                  CardSwipeOrientation.RIGHT) {
                                print("I am in");
                                likeOrDislike({
                                  'eventId': data1['fetchEventsToJoin'][current]
                                      ['_id'],
                                  'userId': widget.id,
                                  'like': 1
                                });
                              } else {
                                print("I am out");
                                likeOrDislike({
                                  'eventId': data1['fetchEventsToJoin'][current]
                                      ['_id'],
                                  'userId': widget.id,
                                  'like': 0
                                });
                              }
                            },
                            orientation: AmassOrientation.BOTTOM,
                            totalNum: data1['fetchEventsToJoin'].length,
                            stackNum: 2,
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                            maxHeight: MediaQuery.of(context).size.width * 0.9,
                            minWidth: MediaQuery.of(context).size.width * 0.8,
                            minHeight: MediaQuery.of(context).size.width * 0.8,
                            cardBuilder: (context, index) => Card(
                                  child: GestureDetector(
                                    onTap: () {
                                      var route = MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              EventDetailScreen(
                                                  data1['fetchEventsToJoin']
                                                      [index]['_id']));
                                      Navigator.of(context).push(route);
                                    },
                                    onTapDown: (TapDownDetails) {
                                      print(TapDownDetails);
                                      current = index;
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                    new Radius.circular(8.0),
                                                topRight:
                                                    new Radius.circular(8.0)),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    '${data1['fetchEventsToJoin'][index]['imageLink']}')),
                                          ),
                                        ),
                                        Container(
                                          decoration: new BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.center,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.7),
                                              ],
                                            ),
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                    new Radius.circular(8.0),
                                                topRight:
                                                    new Radius.circular(8.0)),
                                          ),
                                        ),
                                        Positioned(
                                          top: 260.0,
                                          left: 20.0,
                                          child: Text(
                                            data1['fetchEventsToJoin'][index]
                                                ['name'],
                                            style: TextStyle(
                                                fontSize: 30.0,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                          );
                        }),
                      )));
            }),
    );
  }
}
