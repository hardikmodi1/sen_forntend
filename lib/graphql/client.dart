import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// void main() {
ValueNotifier<Client> client = ValueNotifier(
    Client(endPoint: 'https://stark-wave-67999.herokuapp.com/', cache: InMemoryCache()));
// }
// https://stark-wave-67999.herokuapp.com/
// http://192.168.0.104:4000/
