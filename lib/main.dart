import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import './graphql/client.dart';
import './user/first_signup.dart';
import './home/home.dart';

void main() => runApp(GraphqlProvider(
    client: client,
    child: CacheProvider(
      child: MaterialApp(
        title: "Flock",
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(primaryColor: Colors.red, accentColor: Color(0xff25D366)),
        initialRoute: '/',
        routes: {
          // When we navigate to the "/" route, build the FirstScreen Widget
          '/': (context) => FirstSignup()
        },
      ),
    )));
