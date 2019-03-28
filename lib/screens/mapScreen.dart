import 'dart:async';

import 'package:flock/graphql/user/query/allUser.dart';
import 'package:flock/profile/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart' as loc;

class MapScreen extends StatefulWidget {
  final String id;
  MapScreen(this.id);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Set<Marker> setMarkers(Map<String, dynamic> data) {
    int i = 0;
    for (i = 0; i < data['allUser'].length; i++) {
      print(data['allUser'][i]['username']);
      final String markerIdVal = 'marker_id_$data["allUser"][i]["id"]';
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(data['allUser'][i]['location']['coordinates'][1],
            data['allUser'][i]['location']['coordinates'][0]),
        infoWindow: InfoWindow(
            title: data['allUser'][i]['email'],
            snippet: data['allUser'][i]['username']),
      );
      markers[markerId] = marker;
    }
    return Set<Marker>.of(markers.values);
  }

  Future<void> _goToLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(long, lat), zoom: 15, tilt: 50.0, bearing: 45.0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: Text("Location"),
        leading: true,
      ),
      body: _currentLocation == null
          ? Text("Fetching location...")
          : Query(allUser, variables: {
              'id': widget.id,
              'long': _currentLocation['longitude'],
              'lat': _currentLocation['latitude']
            }, builder: ({
              bool loading,
              Map data,
              Exception error,
            }) {
              if (loading == true) {
                return Text("Loading...");
              } else if (error != null) {
                return Text("Error in fetching data...");
              }
              return Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(_currentLocation['latitude'],
                              _currentLocation['longitude']),
                          zoom: 14.4746),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: setMarkers(data),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 130.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data['allUser'].length,
                          itemBuilder: (context, i) => GestureDetector(
                                onTap: () {
                                  _goToLocation(
                                      data['allUser'][i]['location']
                                          ['coordinates'][0],
                                      data['allUser'][i]['location']
                                          ['coordinates'][1]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  child: FittedBox(
                                    child: Material(
                                      color: Colors.white,
                                      elevation: 14.0,
                                      borderRadius: BorderRadius.circular(24.0),
                                      shadowColor: Color(0x802196F3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 130.0,
                                            height: 130.0,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              child: Image(
                                                fit: BoxFit.fill,
                                                image: data['allUser'][i]
                                                            ['image'] ==
                                                        null
                                                    ? AssetImage(
                                                        'assets/user.png')
                                                    : NetworkImage(
                                                        data['allUser'][i]
                                                            ['image']),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    data['allUser'][i]['email'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green,
                                                        fontSize: 17.0),
                                                  ),
                                                  Text(data['allUser'][i]
                                                      ['username']),
                                                  Text(data['allUser'][i]
                                                      ['phone'])
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        )),
                  )
                ],
              );
            }),
    );
  }
}
