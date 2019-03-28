import 'package:flock/graphql/groups/query/fetchRatingByGroupId.dart';
import 'package:flock/screens/giveRating.dart';
import 'package:flock/screens/linear_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CommonRating extends StatelessWidget {
  final String groupId, image, currentUserId;
  final int show;
  CommonRating(this.groupId, this.image, this.currentUserId, {this.show});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Query(fetchRatingByGroupId, variables: {
            'groupId': groupId,
          }, builder: ({
            bool loading,
            Map data,
            Exception error,
          }) {
            if (loading || data['fetchRatingByGroupId']['ratings'] == null)
              return Text("Fetching User ratings...");
            else if (error != null)
              return Text("Some error fetching data...");
            else {
              return Column(
                children: <Widget>[
                  Text(
                    '${data['fetchRatingByGroupId']['total']} Member reviews',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount:
                        data['fetchRatingByGroupId']['ratings'].length - 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          Text('${index + 1}'),
                          Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                            size: 25.0,
                          ),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 100,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2500,
                            percent: data['fetchRatingByGroupId']['total'] == 0
                                ? 0.0
                                : data['fetchRatingByGroupId']['ratings']
                                        [index + 1] /
                                    data['fetchRatingByGroupId']['total'],
                            center: data['fetchRatingByGroupId']['total'] == 0
                                ? Text("0%")
                                : Text(
                                    '${((data['fetchRatingByGroupId']['ratings'][index + 1] / data['fetchRatingByGroupId']['total']) * 100).toStringAsFixed(2)}%'),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.yellow,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                          Text(
                              '${data['fetchRatingByGroupId']['ratings'][index + 1]}')
                        ],
                      );
                    },
                  ),
                  show == 1
                      ? MaterialButton(
                          color: Colors.blueGrey.withOpacity(0.3),
                          onPressed: () {
                            var route = MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    GiveRating(groupId, image, currentUserId));
                            Navigator.of(context).pop();
                            Navigator.of(context).push(route);
                          },
                          child: Text("Give a rating"),
                        )
                      : Container()
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
