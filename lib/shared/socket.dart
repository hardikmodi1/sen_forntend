import 'package:graphql_flutter/graphql_flutter.dart';

Future<SocketClient> connect() async {
  return await SocketClient.connect('ws://coolserver.com/graphql');
}
