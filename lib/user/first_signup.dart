import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../errors/userError.dart';
import '../graphql/user/mutation/registerUser.dart' as mutations;
import './login.dart';
import '../home/home.dart';

class FirstSignup extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _FirstSignupState createState() => new _FirstSignupState();
}

class _FirstSignupState extends State<FirstSignup> {
  String _emailValidate = "", _passValidate = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool loggedin;
  @override
  void initState() {
    super.initState();
    check().then((log) {
      print(log);
      if (log == true) {
        print("Register page");
        print(log);
        setState(() {
          loggedin = true;
        });
      } else {
        setState(() {
          loggedin = false;
        });
      }
    });
  }

  Future<bool> check() async {
    final store = new FlutterSecureStorage();
    final value = await store.read(key: 'token');
    if (value == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 20.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        errorText: _emailValidate != "" ? _emailValidate : null,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.greenAccent, width: 2.0)),
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.teal)),
      ),
    );

    final password = TextField(
      controller: _passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        errorText: _passValidate != "" ? _passValidate : null,
        hintText: 'Password',
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.greenAccent, width: 2.0)),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final phone = TextField(
      controller: _phoneController,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Mobile Number',
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.greenAccent, width: 2.0)),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Already have an account? Login',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        var route =
            MaterialPageRoute(builder: (BuildContext context) => Login());
        Navigator.of(context).push(route);
      },
    );

    setError(Map<String, dynamic> data) {
      print(loggedin);
      setState(() {
        _emailValidate = "";
        _passValidate = "";
      });
      List errors = data['register'];
      for (int i = 0; i < errors.length; i++) {
        setState(() {
          _emailValidate = errors[i]['path'] == "email"
              ? _emailValidate + errors[i]['message'] + '\n'
              : _emailValidate;
          _passValidate = errors[i]['path'] == "password"
              ? _passValidate + errors[i]['message'] + '\n'
              : _passValidate;
        });
      }
    }

    success(Map<String, dynamic> data) async {
      setState(() {
        _emailValidate = "";
        _passValidate = "";
      });
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'token', value: data['register'][0]['id']);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Thanks for registering"),
              actions: <Widget>[
                SimpleDialogOption(
                  child: Text('Okay'),
                  onPressed: () {
                    var route = MaterialPageRoute(
                        builder: (BuildContext context) => FlockHome());
                    Navigator.of(context).pushAndRemoveUntil(
                        route, (Route<dynamic> route) => false);
                  },
                )
              ],
            );
          });
    }

    return loggedin == true
        ? FlockHome()
        : Container(
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.white,
              body: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    logo,
                    SizedBox(height: 48.0),
                    email,
                    SizedBox(height: 8.0),
                    phone,
                    SizedBox(height: 8.0),
                    password,
                    SizedBox(height: 24.0),
                    Mutation(
                      mutations.register,
                      builder: (
                        register, {
                        bool loading,
                        Map data,
                        Exception error,
                      }) {
                        return RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              if (_emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                register({
                                  'email': _emailController.text,
                                  'password': _passwordController.text,
                                  'phone': _phoneController.text
                                });
                              } else {
                                setState(() {
                                  _emailValidate = _emailController.text.isEmpty
                                      ? blankError
                                      : "";
                                  _passValidate =
                                      _passwordController.text.isEmpty
                                          ? blankError
                                          : "";
                                });
                              }
                              print(error);
                            },
                            child: Text('Register'));
                      },
                      onCompleted: (Map<String, dynamic> data) {
                        data['register'][0]['id'] != null
                            ? success(data)
                            : setError(data);
                      },
                    ),
                    forgotLabel
                  ],
                ),
              ),
            ),
          );
  }
}
