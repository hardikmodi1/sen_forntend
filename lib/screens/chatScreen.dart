import 'package:flock/profile/header.dart';
import 'package:flock/screens/groupDetails.dart';
import 'package:flock/screens/personDetail.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/message/mutation/createMessage.dart' as mutations;
import '../graphql/message/query/fetchMessage.dart' as queries;

class ChatScreen extends StatefulWidget {
  final String receiverId, username, senderId, email, image;
  final int isGroup;
  ChatScreen(
      this.receiverId, this.username, this.email, this.senderId, this.image,
      {this.isGroup});
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 0.0);
  final TextEditingController textEditingController =
      new TextEditingController();
  FocusNode focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(
          title: GestureDetector(
            onTap: () {
              if (widget.isGroup == 1) {
                var route = MaterialPageRoute(
                    builder: (BuildContext context) => GroupDetail(
                        widget.receiverId, widget.image, widget.senderId));
                Navigator.of(context).push(route);
              } else {
                var route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PersonDetail(widget.senderId, widget.receiverId));
                Navigator.of(context).push(route);
              }
            },
            child: widget.username == null
                ? Text(widget.email)
                : Text(widget.username),
          ),
          leading: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(0.15), BlendMode.dstATop),
                  repeat: ImageRepeat.repeat),
              color: Colors.transparent),
          child: Column(
            children: <Widget>[
              new Flexible(
                  child:
                      Query(queries.fetchMessage, pollInterval: 1, variables: {
                'senderId': widget.senderId,
                'receiverId': widget.receiverId,
                'query': widget.isGroup
              }, builder: ({
                bool loading,
                Map data,
                Exception error,
              }) {
                return loading || error != null
                    ? Container()
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: data['fetchMessage'].length,
                        itemBuilder: (context, i) => data['fetchMessage'][i]
                                    ['senderId'] !=
                                widget.senderId
                            ? Container(
                                margin: EdgeInsets.only(bottom: 20.0),
                                child: GestureDetector(
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/left.png',
                                        color: Color(0xffffffff),
                                      ),
                                      Card(
                                        margin: EdgeInsets.only(left: 0.0),
                                        color: Color(0xffffffff),
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    90),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  data['fetchMessage'][i]
                                                      ['user']['username'],
                                                  style: TextStyle(
                                                      color:
                                                          Colors.orangeAccent),
                                                ),
                                                Text(
                                                  data['fetchMessage'][i]
                                                      ['text'],
                                                ),
                                                Container(
                                                  child: Text(
                                                    data['fetchMessage'][i]
                                                        ['time'],
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            : Container(
                                margin: EdgeInsets.only(bottom: 20.0),
                                child: GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Card(
                                        color: Colors.blue.withOpacity(0.7),
                                        margin: EdgeInsets.only(left: 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    90),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(data['fetchMessage'][i]
                                                      ['text']),
                                                  Text(
                                                    data['fetchMessage'][i]
                                                        ['time'],
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/right.png',
                                        color: Colors.blue.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                )));
              })),
              new Divider(
                height: 1.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width - 45.0,
                          margin: EdgeInsets.only(bottom: 0),
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                            child: Card(
                              color: Colors.white70,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: TextField(
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0,
                                      color: Colors.black),
                                  maxLines: 1,
                                  keyboardType: TextInputType.multiline,
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              width: 1.0)),
                                      hintText: 'Type Message...',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                          borderSide:
                                              BorderSide(color: Colors.teal)))),
                            ),
                          )),
                      Mutation(
                        mutations.createMessage,
                        builder: (
                          createMessage, {
                          bool loading,
                          Map data,
                          Exception error,
                        }) {
                          return Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                if (textEditingController.text.isNotEmpty) {
                                  createMessage({
                                    'senderId': widget.senderId,
                                    'receiverId': widget.receiverId,
                                    'text': textEditingController.text
                                  });
                                }
                              },
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(Icons.send),
                              ),
                            ),
                          );
                        },
                        onCompleted: (Map<String, dynamic> data) {
                          setState(() {
                            textEditingController.clear();
                          });
                        },
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
