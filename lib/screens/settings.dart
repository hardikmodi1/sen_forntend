import 'dart:async';

import 'package:flock/graphql/user/mutation/setRange.dart';
import 'package:flock/graphql/user/query/getRange.dart';
import 'package:flock/profile/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart' as intl;

class Settings extends StatefulWidget {
  final String id;
  Settings(this.id);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _lowerValue;
  double _upperValue;
  String text;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lowerValue = 0.0;
    _upperValue = 100.0;
    text = "Save settings";
  }

  int flag = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: Text("ChangeSettings"),
        leading: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50.0),
          ),
          Query(getRange, variables: {'id': widget.id}, builder: ({
            bool loading,
            Map data,
            Exception error,
          }) {
            if (loading) {
              return Text("Fetching details of the member");
            }
            if (flag == 0) {
              _lowerValue = data['getRange'].toDouble();
              flag = -1;
            }
            return FlutterSlider(
              values: [_lowerValue],
              max: 500,
              min: 0,
              tooltip: FlutterSliderTooltip(
                alwaysShowTooltip: true,
                textStyle: TextStyle(fontSize: 17, color: Colors.lightBlue),
                numberFormat: intl.NumberFormat(),
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                _lowerValue = lowerValue;
                _upperValue = upperValue;
                print(_lowerValue);
                setState(() {});
              },
            );
          }),
          Mutation(
            setRange,
            builder: (
              setRange, {
              bool loading,
              Map data,
              Exception error,
            }) {
              return MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  setRange({'id': widget.id, 'range': _lowerValue});
                },
                child: Text(text),
              );
            },
            onCompleted: (Map<String, dynamic> data) {
              Navigator.of(context).pop();
              setState(() {
                text = "Saved";
              });
              Timer timer = new Timer(new Duration(seconds: 2), () {
                debugPrint("Print after 5 seconds");
                setState(() {
                  text = "Save settings";
                });
              });
            },
          )
        ],
      ),
    );
  }
}
