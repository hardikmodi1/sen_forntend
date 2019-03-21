import 'package:flutter/material.dart';

class Header extends AppBar {
  Header({Key key, Widget title, bool leading})
      : super(key: key, title: title, automaticallyImplyLeading: leading);
}
