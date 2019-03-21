import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../errors/userError.dart';
import '../graphql/user/mutation/loginUser.dart' as mutations;
import './first_signup.dart';
import '../home/home.dart';

class Login extends StatefulWidget {
  static String tag = 'login-page';
  Login() {
    print("hello");
  }
  find() async {
    final storage = new FlutterSecureStorage();

    // Read value
    String value = await storage.read(key: 'token');
    print(value);
  }

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  String _emailValidate = "", _passValidate = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

    final forgotLabel = FlatButton(
      child: Text(
        'Don\'t have an account? Register',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        var route =
            MaterialPageRoute(builder: (BuildContext context) => FirstSignup());
        Navigator.of(context).push(route);
      },
    );

    setError(Map<String, dynamic> data) {
      setState(() {
        _emailValidate = "";
        _passValidate = "";
      });
      print(data);
      List errors = data['login'];
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
      await storage.write(key: 'token', value: data['login'][0]['id']);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Thanks for login"),
              actions: <Widget>[
                SimpleDialogOption(
                  child: Text('Dismiss'),
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

    return Container(
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
              password,
              SizedBox(height: 24.0),
              Mutation(
                mutations.login,
                builder: (
                  login, {
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
                          login({
                            'email': _emailController.text,
                            'password': _passwordController.text
                          });
                        } else {
                          setState(() {
                            _emailValidate =
                                _emailController.text.isEmpty ? blankError : "";
                            _passValidate = _passwordController.text.isEmpty
                                ? blankError
                                : "";
                          });
                        }
                        print(error);
                      },
                      child: Text('Login'));
                },
                onCompleted: (Map<String, dynamic> data) {
                  data['login'][0]['id'] != null
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
