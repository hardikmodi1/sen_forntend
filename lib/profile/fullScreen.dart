import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  final String image;
  FullScreen(this.image);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profile Photo"),
        elevation: 0.0,
      ),
      body: Container(
          decoration: new BoxDecoration(
            color: Colors.black,
          ),
          child: Center(child: Image.network(image))),
    );
  }
}
