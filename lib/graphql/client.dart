import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

// void main() {
ValueNotifier<Client> client = ValueNotifier(Client(
    endPoint: 'https://stark-wave-67999.herokuapp.com/',
    cache: InMemoryCache()));
// }
