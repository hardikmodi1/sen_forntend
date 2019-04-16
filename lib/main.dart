import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import './graphql/client.dart';
import './user/first_signup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphqlProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Flock',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            // When we navigate to the "/" route, build the FirstScreen Widget
            '/': (context) => FirstSignup()
          },
        ),
      ),
    );
  }
}

// ThemeData(primaryColor: Colors.red, accentColor: Color(0xff25D366)),
