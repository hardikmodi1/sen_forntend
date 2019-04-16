import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flock/graphql/user/query/meQuery.dart';
import 'package:flock/profile/updateUsername.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../graphql/user/mutation/updateProfile.dart' as mutations;
import '../shared/uploadImage.dart' as upload;

class Profile extends StatefulWidget {
  final String imageUrl, name, id;
  Profile(this.imageUrl, this.name, this.id);
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<String> picker(String name) async {
    print("pressed");
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(name)
        .child(img.path.split("/")[img.path.split("/").length - 1]);
    StorageUploadTask uploadTask = ref.putFile(img);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
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
                    "Profile photo",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Mutation(
                  mutations.updateProfile,
                  builder: (
                    updateProfile, {
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
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                              upload.upload(name, 0).then((onValue) {
                                print(onValue);
                                updateProfile(
                                    {'id': widget.id, 'image': onValue});
                                if (onValue != null) {
                                  setState(() {
                                    url = onValue;
                                  });
                                }
                              });
                            }),
                        ListTile(
                          leading: Icon(
                            Icons.image,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text("Gallery"),
                          onTap: () {
                            upload.upload(name, 1).then((onValue) {
                              print(onValue);
                              updateProfile(
                                  {'id': widget.id, 'image': onValue});
                              if (onValue != null) {
                                setState(() {
                                  url = onValue;
                                });
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                  onCompleted: (Map<String, dynamic> data) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  String url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init");
    setState(() {
      url = widget.imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffededed),
        appBar: AppBar(
          title: Text("Profile"),
          elevation: 0.7,
        ),
        body: Query(meQuery, variables: {'id': widget.id}, builder: ({
          bool loading,
          Map data,
          Exception error,
        }) {
          if (error != null) {
            return null;
          }
          return Container(
              padding: EdgeInsets.only(top: 20.0),
              width: double.infinity,
              child: Column(children: <Widget>[
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 80.0,
                      backgroundColor: Colors.green,
                      child: url == null
                          ? GestureDetector(
                              child: Text(
                                widget.name[0],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 90.0),
                              ),
                            )
                          : Container(
                              width: 160.0,
                              height: 160.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(url))),
                            ),
                    ),
                    Positioned(
                      left: 100.0,
                      top: 110.0,
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.purpleAccent,
                        child: GestureDetector(
                          child: IconButton(
                            onPressed: () {
                              _settingModalBottomSheet(context, widget.name);
                            },
                            icon: Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () {
                              print("object");
                              var route = MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateUsername(
                                          widget.imageUrl,
                                          widget.name,
                                          data['me']['username'],
                                          widget.id));
                              Navigator.of(context).push(route);
                            },
                            child: Card(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.0, top: 5.0, bottom: 10.0),
                                  child:
                                      loading || data['me']['username'] == null
                                          ? Text(
                                              "",
                                              style: TextStyle(
                                                fontSize: 30.0,
                                              ),
                                            )
                                          : Text(
                                              data['me']['username'],
                                              style: TextStyle(
                                                fontSize: 30.0,
                                              ),
                                            )),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, top: 10.0, bottom: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "About and Phone number",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 15.0),
                                  ),
                                  Divider(),
                                  data['me']['phone'] == null || loading
                                      ? Text("Not provided")
                                      : Text(data['me']['phone'],
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]));
        }));
  }
}
