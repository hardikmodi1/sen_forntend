// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flock/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Checking register functioanlity', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // invalid email format
    await tester.enterText(find.byKey(Key("email")), 'hmodi2457');
    await tester.enterText(find.byKey(Key("password")), 'pass');
    await tester.enterText(find.byKey(Key("username")), 'abcd123');
    await tester.enterText(find.byKey(Key("phone")), '1234567890');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // email already taken
    await tester.enterText(find.byKey(Key("email")), 'hmodi2457@gmail.com');
    await tester.enterText(find.byKey(Key("password")), 'pass');
    await tester.enterText(find.byKey(Key("username")), 'abcd123');
    await tester.enterText(find.byKey(Key("phone")), '1234567890');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // empty email
    await tester.enterText(find.byKey(Key("email")), '');
    await tester.enterText(find.byKey(Key("password")), 'pass');
    await tester.enterText(find.byKey(Key("username")), 'abcd123');
    await tester.enterText(find.byKey(Key("phone")), '1234567890');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // username already taken
    await tester.enterText(find.byKey(Key("email")), 'valid@gmail.com');
    await tester.enterText(find.byKey(Key("password")), 'pass');
    await tester.enterText(find.byKey(Key("username")), 'ms');
    await tester.enterText(find.byKey(Key("phone")), '1234567890');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // empty username
    await tester.enterText(find.byKey(Key("email")), 'valid@gmail.com');
    await tester.enterText(find.byKey(Key("password")), 'pass');
    await tester.enterText(find.byKey(Key("username")), '');
    await tester.enterText(find.byKey(Key("phone")), '1234567890');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // password of length < 3
    await tester.enterText(find.byKey(Key("email")), 'valid@gmail.com');
    await tester.enterText(find.byKey(Key("password")), 'ps');
    await tester.enterText(find.byKey(Key("username")), 'abcd123');
    await tester.enterText(find.byKey(Key("phone")), '1234567890');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);
  });

  testWidgets('Checking login functioanlity', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.tap(find.byType(FlatButton));
    await tester.pumpAndSettle();
    expect(find.text('Already have an account? Login'), findsNothing);

    // correct email, empty password
    await tester.enterText(find.byKey(Key("email")), 'hmodi2457@gmail.com');
    await tester.enterText(find.byKey(Key("password")), '');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // correct email, incorrect password
    await tester.enterText(find.byKey(Key("email")), 'hmodi2457@gmail.com');
    await tester.enterText(find.byKey(Key("password")), '1234567');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // empty email, empty password
    await tester.enterText(find.byKey(Key("email")), '');
    await tester.enterText(find.byKey(Key("password")), '');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // empty email, non-empty password
    await tester.enterText(find.byKey(Key("email")), '');
    await tester.enterText(find.byKey(Key("password")), '1234567');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // incorrect email, empty password
    await tester.enterText(find.byKey(Key("email")), 'invalid@gmail.com');
    await tester.enterText(find.byKey(Key("password")), '');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);

    // incorrect email, non-empty password
    await tester.enterText(find.byKey(Key("email")), 'invalid@gmail.com');
    await tester.enterText(find.byKey(Key("password")), '1234567');
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();
    expect(find.byType(FlatButton), findsOneWidget);
  });
}
