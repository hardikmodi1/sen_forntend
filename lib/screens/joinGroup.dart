import 'package:flock/home/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../graphql/groups/query/groupDetailsQuery.dart' as query;
import '../graphql/groups/mutation/addToGroup.dart' as mutation;

class JoinGroup extends StatefulWidget {
  final String groupId, id;
  JoinGroup(this.groupId, this.id);
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffededed),
      body:
          Query(query.fetchGroup, variables: {'id': widget.groupId}, builder: ({
        bool loading,
        Map data,
        Exception error,
      }) {
        if (loading) return Text("Loading");
        if (error != null) {
          return Text("Error in fetching data");
        }
        return CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(data['groupDetail']['name']),
                background: data['groupDetail']['iconLink'] == null
                    ? Image.asset("assets/group.png", fit: BoxFit.cover)
                    : Container(
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage(
                                data['groupDetail']['iconLink']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 50.0,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      data['groupDetail']['description'] == null
                          ? ""
                          : data['groupDetail']['description'],
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                color: Colors.white,
                padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
                child: Text(
                  data['fetchGroupMember'].length.toString() + " participants",
                  style: TextStyle(
                      fontSize: 17.0, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                sliver: SliverFixedExtentList(
                  itemExtent: 75.0,
                  delegate: SliverChildBuilderDelegate(
                      (builder, index) => _buildListItem(
                          data['fetchGroupMember'][index],
                          context,
                          data['adminList']),
                      childCount: data['fetchGroupMember'].length),
                )),
            SliverToBoxAdapter(
              child: Mutation(mutation.addToGroup, builder: (
                addToGroup, {
                bool loading,
                Map data,
                Exception error,
              }) {
                return Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  color: Colors.green,
                  height: 50.0,
                  padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      addToGroup({
                        'groupId': widget.groupId,
                        'members': [widget.id]
                      });
                      var route = MaterialPageRoute(
                          builder: (BuildContext context) => FlockHome());
                      Navigator.of(context).pop();
                      Navigator.of(context).push(route);
                    },
                    child: Text(
                      "Join Group",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}

Widget _buildListItem(itm, BuildContext context, List<dynamic> adminList) {
  return Container(
    color: Colors.white,
    child: Column(
      children: <Widget>[
        Divider(
          height: 10.0,
        ),
        GestureDetector(
          onLongPress: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      height: 350.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(height: 110.0),
                              Container(
                                height: 60.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    color: Theme.of(context).primaryColor),
                              ),
                              Positioned(
                                  top: 5.0,
                                  left: 94.0,
                                  child: Container(
                                    height: 100.0,
                                    width: 90.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(45.0),
                                        border: Border.all(
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                            width: 1.0),
                                        image: DecorationImage(
                                            image: itm['image'] != null
                                                ? NetworkImage(itm['image'])
                                                : AssetImage("assets/user.png"),
                                            fit: BoxFit.cover)),
                                  ))
                            ],
                          ),
                          Text(
                            itm['username'] != null
                                ? itm['username']
                                : "No username",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: itm['username'] != null
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                          ListTile(
                            onTap: () async {
                              String url = 'mailto:' + itm['email'];
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                //@TODO: show the snackbar here
                                print("No application avaible to make call");
                              }
                            },
                            leading: Icon(Icons.mail_outline),
                            title: Text(
                              itm['email'],
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              String url = 'tel:' + itm['phone'];
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                //@TODO: show the snackbar here
                                print("No application avaible to make call");
                              }
                            },
                            leading: Icon(Icons.call),
                            title: Text(
                              itm['phone'] != null ? itm['phone'] : "No phone",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: itm['phone'] != null
                                      ? Colors.black
                                      : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: ListTile(
            leading: CircleAvatar(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              backgroundImage: itm['image'] != null
                  ? NetworkImage(itm['image'])
                  : AssetImage("assets/user.png"),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  itm['username'] == null ? itm['email'] : itm['username'],
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                adminList.contains(itm['id'])
                    ? Container(
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)),
                        child: Text(
                          "Group Admin",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 10.0),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        )
      ],
    ),
  );
}
