import 'package:flock/screens/createGroup.dart';
import 'package:flock/screens/listGroupToJoin.dart';
import 'package:flock/screens/mapScreen.dart';
import 'package:flock/screens/settings.dart';
import 'package:flock/user/change_password_first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../screens/groupChat.dart';
import '../screens/personalChat.dart';
import '../user/first_signup.dart';
import '../graphql/user/query/meQuery.dart';
import '../profile/profile.dart';

class FlockHome extends StatefulWidget {
  @override
  _FlockHomeState createState() => new _FlockHomeState();
}

class _FlockHomeState extends State<FlockHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController searchController = TextEditingController();

  bool loggedin, _isSearching;
  String id, search;
  bool checkLoaded;
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    checkLoaded = false;
    searchController.addListener(_listner);
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 2);
    check().then((log) {
      print("log");
      if (log == true) {
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

  _listner() {
    setState(() {
      search = searchController.text;
    });
  }

  Future<bool> check() async {
    final store = new FlutterSecureStorage();
    // await store.deleteAll();
    final value = await store.read(key: 'token');
    if (value == "" || value == null) {
      return false;
    } else {
      setState(() {
        id = value;
      });
      return true;
    }
  }

  void redirect(String image, String email, String id) {
    var route = MaterialPageRoute(
        builder: (BuildContext context) => Profile(image, email, id));
    Navigator.of(context).pop();
    Navigator.of(context).push(route);
  }

  ImageProvider<dynamic> showImage(String image) {
    var _myEarth = NetworkImage(image);
    _myEarth.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        if (checkLoaded == false) {
          setState(() {
            checkLoaded = true;
          });
          return _myEarth;
        }
      }
      if (checkLoaded) {
        return _myEarth;
      }
      return AssetImage('assets/logo.png');
    });
    if (checkLoaded) {
      return _myEarth;
    }
    return AssetImage('assets/logo.png');
  }

  @override
  Widget build(BuildContext context) {
    return loggedin == true
        ? _isSearching == false
            ? Scaffold(
                appBar: new AppBar(
                  title: new Text("Flock"),
                  elevation: 0.7,
                  bottom: new TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    tabs: <Widget>[
                      new Tab(text: "CHATS"),
                      new Tab(
                        text: "GROUPS",
                      )
                    ],
                  ),
                  actions: <Widget>[
                    new IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    ),
                    Icon(Icons.more_vert),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    ),
                  ],
                ),
                drawer: Query(meQuery, variables: {'id': id}, builder: ({
                  bool loading,
                  Map data,
                  Exception error,
                }) {
                  if (error != null) {
                    return null;
                  }
                  return Drawer(
                    child: ListView(
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          accountEmail: loading
                              ? Text("Loading...")
                              : Text(data['me']['email']),
                          accountName: loading || error != null
                              ? Text("Loading...")
                              : data['me']['username'] == null
                                  ? Text("")
                                  : Text(data['me']['username']),
                          currentAccountPicture: loading
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: CircularProgressIndicator(),
                                )
                              : data['me']['image'] == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: GestureDetector(
                                        onTap: () {
                                          redirect(data['me']['image'],
                                              data['me']['email'], id);
                                        },
                                        child: Text(
                                          data['me']['email'][0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 30.0),
                                        ),
                                      ))
                                  : Container(
                                      width: 190.0,
                                      height: 190.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          redirect(data['me']['image'],
                                              data['me']['email'], id);
                                        },
                                      ),
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: showImage(
                                                  data['me']['image']))),
                                    ),
                        ),
                        ListTile(
                          title: Text("Create Group"),
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CreateGroup(id));
                            Navigator.of(context).pop();
                            Navigator.of(context).push(route);
                          },
                          leading: Icon(
                            Icons.group,
                            color: Colors.black,
                          ),
                        ),
                        ListTile(
                          title: Text("Join Group"),
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ListGroupToJoin(id));
                            Navigator.of(context).pop();
                            Navigator.of(context).push(route);
                          },
                          leading: Icon(
                            Icons.group_add,
                            color: Colors.black,
                          ),
                        ),
                        ListTile(
                          title: Text("Change Password"),
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ChangePasswordFirst(
                                        id, data['me']['phone']));
                            Navigator.of(context).pop();
                            Navigator.of(context).push(route);
                          },
                          leading: Icon(
                            Icons.security,
                            color: Colors.black,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Locate on map"),
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MapScreen(id));
                            Navigator.of(context).pop();
                            Navigator.of(context).push(route);
                          },
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Settings"),
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Settings(id));
                            Navigator.of(context).pop();
                            Navigator.of(context).push(route);
                          },
                          leading: Icon(
                            Icons.settings,
                            color: Colors.black,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Logout"),
                          onTap: () async {
                            final store = new FlutterSecureStorage();
                            await store.deleteAll();
                            var route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FirstSignup());
                            Navigator.of(context).pushAndRemoveUntil(
                                route, (Route<dynamic> route) => false);
                          },
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  );
                }),
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    PersonalChat(id),
                    GroupChat(id),
                  ],
                ),
                floatingActionButton: new FloatingActionButton(
                  backgroundColor: Theme.of(context).accentColor,
                  child: new Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  onPressed: () => print("open chats"),
                ),
              )
            : new Scaffold(
                appBar: new AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                        });
                      },
                    ),
                    title: TextField(
                      autofocus: true,
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: 'Search...', border: InputBorder.none),
                    ),
                    elevation: 0.7),
                body: _tabController.index == 0
                    ? PersonalChat(
                        id,
                        text: search,
                      )
                    : GroupChat(
                        id,
                        text: search,
                      ),
                floatingActionButton: new FloatingActionButton(
                  backgroundColor: Theme.of(context).accentColor,
                  child: new Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  onPressed: () => print("open chats"),
                ),
              )
        : FirstSignup();
  }
}
