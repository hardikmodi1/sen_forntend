import 'dart:async';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart';

import 'package:flock/graphql/user/query/allUser.dart';
import 'package:flock/profile/header.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: Text("Location"),
        leading: true,
      ),
      body: Container(
        width: double.infinity,
        height: 350.0,
        child: _currentLocation == null
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
                return GoogleMap(
                  markers: setMarkers(data),
                  initialCameraPosition: CameraPosition(
                      target: LatLng(_currentLocation['latitude'],
                          _currentLocation['longitude']),
                      zoom: 14.4746),
                  mapType: MapType.terrain,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
              }),
      ),
    );
  }
}
