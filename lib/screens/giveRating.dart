import 'package:flock/graphql/groups/mutation/addGroupRating.dart';
import 'package:flock/graphql/groups/query/fetchRatingOfMember.dart';
import 'package:flock/profile/header.dart';
import 'package:flock/screens/groupDetails.dart';
import 'package:flock/screens/star.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GiveRating extends StatefulWidget {
  final String groupId, image, currentUserId;
  GiveRating(this.groupId, this.image, this.currentUserId);
  @override
  _GiveRatingState createState() => _GiveRatingState();
}

class _GiveRatingState extends State<GiveRating> {
  var rating = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rating = 0.0;
  }

  int flag = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: Text("Give Review"),
        leading: true,
      ),
      body: Query(fetchRatingOfMember, variables: {
        'groupId': widget.groupId,
        'memberId': widget.currentUserId
      }, builder: ({
        bool loading,
        Map data,
        Exception error,
      }) {
        if (loading) {
          return Text("Fetching details of the member");
        }
        if (flag == 0) {
          rating = data['fetchRatingOfMember'].toDouble();
          flag = -1;
        }
        return Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
              ),
              SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {
                  rating = v;
                  print(rating);
                  setState(() {});
                },
                starCount: 5,
                rating: rating,
                size: 40.0,
                color: Colors.green,
                borderColor: Colors.green,
              ),
              Mutation(
                addGroupRating,
                builder: (
                  addGroupRating, {
                  bool loading,
                  Map data,
                  Exception error,
                }) {
                  return MaterialButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: rating == 0.0
                        ? null
                        : () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            if (rating != 0.0)
                              addGroupRating({
                                'groupId': widget.groupId,
                                'memberId': widget.currentUserId,
                                'rating': rating
                              });
                          },
                    child: Text("Save Review"),
                  );
                },
                onCompleted: (Map<String, dynamic> data) {
                  //TODO: hide loading icon here.
                  var route = MaterialPageRoute(
                      builder: (BuildContext context) => GroupDetail(
                          widget.groupId, widget.image, widget.currentUserId));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(route);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
