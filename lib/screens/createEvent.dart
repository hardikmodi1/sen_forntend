import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flock/graphql/events/mutation/createEvent.dart';
import 'package:flock/profile/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;

class CreateEvent extends StatefulWidget {
  final String id;
  CreateEvent(this.id);
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  String text = "Select Date";
  String timeText = "Select Time";
  TextEditingController _eventName = TextEditingController();
  TextEditingController _discription = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(_date.year),
        lastDate: DateTime(_date.year + 1));
    if (picked != null) {
      setState(() {
        _date = picked;
        text = _date.toString().substring(0, 11);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _time = picked;
        timeText = _time.toString().substring(10, 15);
      });
      print(_time.toString());
    }
  }

  File _image;

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
                    "Event",
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
                        onTap: () async {
                          File img = await ImagePicker.pickImage(
                              source: ImageSource.camera);
                          Navigator.of(context).pop();
                          if (img != null) {
                            setState(() {
                              _image = img;
                            });
                          }
                        }),
                    ListTile(
                      leading: Icon(
                        Icons.image,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text("Gallery"),
                      onTap: () async {
                        File img = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        Navigator.of(context).pop();
                        if (img != null) {
                          setState(() {
                            _image = img;
                          });
                        }
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
        title: Text("Create Event"),
        leading: true,
      ),
      body: _currentLocation == null
          ? Text("Fetching Location!")
          : ListView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 20.0,
                  padding: EdgeInsets.only(left: 10.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        _image == null
                            ? Text(
                                'Select image.',
                              )
                            : Image.file(
                                _image,
                                width: MediaQuery.of(context).size.width - 30.0,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                              ),
                        RaisedButton(
                          onPressed: () {
                            _settingModalBottomSheet(context, "Event photo");
                          },
                          child: Text("Choose Event picture"),
                        ),
                        TextField(
                          controller: _eventName,
                          decoration:
                              InputDecoration(hintText: 'Event Name...'),
                        ),
                        TextField(
                          controller: _discription,
                          decoration:
                              InputDecoration(hintText: 'Event Discription...'),
                        ),
                        RaisedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text(text),
                        ),
                        RaisedButton(
                          onPressed: () {
                            _selectTime(context);
                          },
                          child: Text(timeText),
                        ),
                        Mutation(createEvent, builder: (
                          createEvent, {
                          bool loading,
                          Map data,
                          Exception error,
                        }) {
                          return RaisedButton(
                            onPressed: () async {
                              if (_image != null &&
                                  _eventName.text.isNotEmpty &&
                                  _discription.text.isNotEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    });
                                StorageReference ref = FirebaseStorage.instance
                                    .ref()
                                    .child("Event")
                                    .child(_image.path.split("/")[
                                        _image.path.split("/").length - 1]);
                                StorageUploadTask uploadTask =
                                    ref.putFile(_image);
                                String url = await (await uploadTask.onComplete)
                                    .ref
                                    .getDownloadURL();
                                print(url);

                                createEvent({
                                  'id': widget.id,
                                  'name': _eventName.text,
                                  'imageLink': url,
                                  'description': _discription.text,
                                  'date': text,
                                  'time': timeText,
                                  'long': _currentLocation['longitude'],
                                  'lat': _currentLocation['latitude']
                                });
                              } else {
                                //TODO: add a snackbar to show error message
                                // Scaffold.of(context).showSnackBar(SnackBar(
                                //   content: new Text(
                                //       "Select valid inputs for creating event!"),
                                // ));
                              }
                            },
                            child: Text("Submit Event"),
                          );
                        }, onCompleted: (Map<String, dynamic> data) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
