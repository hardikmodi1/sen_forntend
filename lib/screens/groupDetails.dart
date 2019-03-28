import 'package:flock/home/home.dart';
import 'package:flock/screens/commonRating.dart';
import 'package:flock/screens/updateDescription.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import './addToGroup.dart';
import '../graphql/groups/mutation/dismissAdmin.dart';
import '../graphql/groups/mutation/makeAdmin.dart';
import '../graphql/groups/mutation/remove.dart';
import '../graphql/groups/mutation/updateGroupDescription.dart' as mutations;
import '../graphql/groups/query/groupDetailsQuery.dart' as query;
import '../shared/uploadImage.dart' as upload;

class GroupDetail extends StatefulWidget {
  final String groupId, image, currentUserId;
  GroupDetail(this.groupId, this.image, this.currentUserId);
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  String url;

  @override
  void initState() {
    super.initState();
    url = widget.image;
  }

  void _settingModalBottomSheet(BuildContext context, String name) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Group icon",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Mutation(
                  mutations.updateGroup,
                  builder: (
                    updateDescription, {
                    bool loading,
                    Map data,
                    Exception error,
                  }) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                            leading: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text("Camera"),
                            onTap: () {
                              upload.upload(name).then((onValue) {
                                if (onValue != null) {
                                  setState(() {
                                    url = onValue;
                                  });
                                  print("gdfdfdfdfds" + url);
                                  print(widget.groupId);
                                  updateDescription({
                                    'groupId': widget.groupId,
                                    'imageLink': url
                                  });
                                }
                                print(onValue);
                              });
                            }),
                        ListTile(
                          leading: Icon(
                            Icons.image,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text("Gallery"),
                          onTap: () {
                            upload.upload(name).then((onValue) {
                              print(onValue);
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  List<dynamic> adminList;

  addOrRemoveAdmin(String memberId) {
    if (adminList.contains(memberId)) {
      setState(() {
        adminList.remove(memberId);
      });
    } else {
      setState(() {
        adminList.add(memberId);
      });
    }
  }

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
        adminList = data['adminList'];
        return CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(data['groupDetail']['name']),
                  background: GestureDetector(
                    onTap: () {
                      _settingModalBottomSheet(context, "Group_profile");
                    },
                    child: Stack(
                      children: <Widget>[
                        url == null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/group.png',
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new NetworkImage(url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          )),
                        )
                      ],
                    ),
                  )),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 50.0,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                        onTap: () {
                          var route = MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UpdateDescription(
                                      data['groupDetail']['description'],
                                      widget.groupId,
                                      widget.image,
                                      widget.currentUserId));
                          Navigator.of(context).push(route);
                        },
                        child: Text(
                          data['groupDetail']['description'] == null
                              ? "Add group description"
                              : data['groupDetail']['description'],
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w400),
                        )),
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
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  var route = MaterialPageRoute(
                      builder: (BuildContext context) => AddToGroup(
                          widget.groupId, widget.image, widget.currentUserId));
                  Navigator.of(context).push(route);
                },
                child: adminList.contains(widget.currentUserId)
                    ? Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Icon(Icons.person_add),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            Text(
                              "Add participants",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            )
                          ],
                        ),
                      )
                    : Container(),
              ),
            ),
            SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                sliver: SliverFixedExtentList(
                  itemExtent: 75.0,
                  delegate: SliverChildBuilderDelegate(
                      (builder, index) => _buildListItem(
                              widget.groupId,
                              data['fetchGroupMember'][index],
                              context,
                              adminList,
                              widget.currentUserId, (String memberId) {
                            if (adminList.contains(memberId)) {
                              setState(() {
                                adminList.remove(memberId);
                              });
                            } else {
                              setState(() {
                                adminList.add(memberId);
                              });
                            }
                          }, widget.image),
                      childCount: data['fetchGroupMember'].length),
                )),
            SliverToBoxAdapter(
              child: Container(
                height: 45.0,
                margin: EdgeInsets.only(top: 5.0),
                color: Colors.white,
                padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
                child: Mutation(
                  remove,
                  builder: (
                    remove, {
                    bool loading,
                    Map data,
                    Exception error,
                  }) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        remove({
                          'groupId': widget.groupId,
                          'memberId': widget.currentUserId
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                          Text(
                            "Exit Group",
                            style: TextStyle(
                                fontSize: 22.0,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    );
                  },
                  onCompleted: (Map<String, dynamic> data) {
                    var route = MaterialPageRoute(
                        builder: (BuildContext context) => FlockHome());
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                        route, (Route<dynamic> route) => false);
                  },
                ),
              ),
            ),
            CommonRating(
              widget.groupId,
              widget.image,
              widget.currentUserId,
              show: 1,
            )
          ],
        );
      }),
    );
  }
}

Widget _buildListItem(groupId, itm, BuildContext context,
    List<dynamic> adminList, String currentUserid, addOrRemove, String image) {
  return Container(
    color: Colors.white,
    child: Column(
      children: <Widget>[
        Divider(
          height: 10.0,
        ),
        GestureDetector(
          onLongPress: () {
            if (currentUserid != itm['id'])
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
                                                  : AssetImage(
                                                      "assets/user.png"),
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
                                itm['phone'] != null
                                    ? itm['phone']
                                    : "No phone",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: itm['phone'] != null
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                            ),
                            adminList.contains(currentUserid) &&
                                    !adminList.contains(itm['id'])
                                ? Mutation(makeAdmin, builder: (
                                    makeAdmin, {
                                    bool loading,
                                    Map data,
                                    Exception error,
                                  }) {
                                    return ListTile(
                                      onTap: () {
                                        //TODO:show progress bar here
                                        makeAdmin({
                                          'groupId': groupId,
                                          'memberId': itm['id']
                                        });
                                        int length = adminList.length;
                                        addOrRemove(itm['id']);
                                        while (length == adminList.length) {}
                                        Navigator.of(context).pop();
                                      },
                                      title: Text(
                                        "Make an admin",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  })
                                : Container(),
                            adminList.contains(currentUserid) &&
                                    adminList.contains(itm['id'])
                                ? Mutation(dismissAsAdmin, builder: (
                                    dismissAsAdmin, {
                                    bool loading,
                                    Map data,
                                    Exception error,
                                  }) {
                                    return ListTile(
                                      onTap: () {
                                        //TODO:show progress bar here
                                        dismissAsAdmin({
                                          'groupId': groupId,
                                          'memberId': itm['id']
                                        });
                                        int length = adminList.length;
                                        addOrRemove(itm['id']);
                                        while (length == adminList.length) {}
                                        Navigator.of(context).pop();
                                      },
                                      title: Text(
                                        "Dismiss as admin",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  })
                                : Container(),
                            adminList.contains(currentUserid)
                                ? Mutation(remove, builder: (
                                    remove, {
                                    bool loading,
                                    Map data,
                                    Exception error,
                                  }) {
                                    return ListTile(
                                      onTap: () {
                                        //TODO:show progress bar here
                                        remove({
                                          'groupId': groupId,
                                          'memberId': itm['id']
                                        });
                                        int length = adminList.length;
                                        addOrRemove(itm['id']);
                                        while (length == adminList.length) {}
                                        var route = MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                GroupDetail(groupId, image,
                                                    currentUserid));
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(route);
                                      },
                                      title: Text(
                                        "Remove",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  })
                                : Container(),
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
                  currentUserid == itm['id']
                      ? "You"
                      : itm['username'] == null
                          ? itm['email']
                          : itm['username'],
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
