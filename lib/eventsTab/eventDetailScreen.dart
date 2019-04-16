import 'package:flock/graphql/events/query/eventDetail.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EventDetailScreen extends StatefulWidget {
  final String id;
  EventDetailScreen(this.id);
  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with TickerProviderStateMixin {
  AnimationController _containerController;
  Animation<double> width;
  Animation<double> heigth;
  double _appBarHeight = 256.0;

  void initState() {
    _containerController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();
    print("ds");
    print(widget.id);
    width = new Tween<double>(
      begin: 200.0,
      end: 220.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth = new Tween<double>(
      begin: 400.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth.addListener(() {
      setState(() {
        if (heigth.isCompleted) {}
      });
    });
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromRGBO(106, 94, 175, 1.0),
        platform: Theme.of(context).platform,
      ),
      child: Query(getDescription, variables: {'id': widget.id}, builder: ({
        bool loading,
        Map data,
        Exception error,
      }) {
        if (loading) {
          return Scaffold(body: Text("Loading..."));
        }
        if (error != null) {
          return Scaffold(body: Text("Some error fetching data"));
        }
        return new Container(
          width: width.value,
          height: heigth.value,
          color: const Color.fromRGBO(106, 94, 175, 1.0),
          child: new Hero(
            tag: "img",
            child: new Card(
              color: Colors.transparent,
              child: new Container(
                alignment: Alignment.center,
                width: width.value,
                height: heigth.value,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    new CustomScrollView(
                      shrinkWrap: false,
                      slivers: <Widget>[
                        new SliverAppBar(
                          elevation: 0.0,
                          forceElevated: true,
                          leading: new IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: new Icon(
                              Icons.arrow_back,
                              color: Colors.cyan,
                              size: 30.0,
                            ),
                          ),
                          expandedHeight: _appBarHeight,
                          flexibleSpace: new FlexibleSpaceBar(
                            title: new Text(data['getDescription']['name']),
                            background: new Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                new Container(
                                  width: width.value,
                                  height: _appBarHeight,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: new NetworkImage(
                                          data['getDescription']['imageLink']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        new SliverList(
                          delegate: new SliverChildListDelegate(<Widget>[
                            new Container(
                              color: Colors.white,
                              child: new Padding(
                                padding: const EdgeInsets.all(35.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      padding:
                                          new EdgeInsets.only(bottom: 20.0),
                                      alignment: Alignment.center,
                                      decoration: new BoxDecoration(
                                          color: Colors.white,
                                          border: new Border(
                                              bottom: new BorderSide(
                                                  color: Colors.black12))),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          new Row(
                                            children: <Widget>[
                                              new Icon(
                                                Icons.calendar_today,
                                                color: Colors.cyan,
                                              ),
                                              new Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Text(
                                                    data['getDescription']
                                                        ['date']),
                                              )
                                            ],
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              new Icon(
                                                Icons.watch_later,
                                                color: Colors.cyan,
                                              ),
                                              new Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Text(
                                                    data['getDescription']
                                                        ['time']),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, bottom: 8.0),
                                      child: new Text(
                                        "ABOUT",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    new Text(
                                        data['getDescription']['description']),
                                    new Container(
                                      margin: new EdgeInsets.only(top: 25.0),
                                      padding: new EdgeInsets.only(
                                          top: 5.0, bottom: 10.0),
                                      height: 120.0,
                                      decoration: new BoxDecoration(
                                          color: Colors.white,
                                          border: new Border(
                                              top: new BorderSide(
                                                  color: Colors.black12))),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        child: Container(
                                                          height: 350.0,
                                                          width: 200.0,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          child:
                                                              ListView.builder(
                                                            itemCount: data[
                                                                        'getDescription']
                                                                    [
                                                                    'participants']
                                                                .length,
                                                            itemBuilder:
                                                                (context, i) =>
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        CircleAvatar(
                                                                          backgroundImage: data['getDescription']['participants'][i]['image'] == null
                                                                              ? AssetImage('assets/user.png')
                                                                              : NetworkImage(data['getDescription']['participants'][i]['image']),
                                                                        ),
                                                                        Text(data['getDescription']['participants'][i]
                                                                            [
                                                                            'username']),
                                                                      ],
                                                                    ),
                                                          ),
                                                        ));
                                                  });
                                            },
                                            child: Text(
                                              '${data['getDescription']['participants'].length} ATTENDEES',
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      height: 100.0,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
