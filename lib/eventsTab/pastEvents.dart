import 'package:flock/eventsTab/eventDetailScreen.dart';
import 'package:flock/graphql/events/query/pastEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PastEvents extends StatefulWidget {
  final String id;
  PastEvents(this.id);
  @override
  _PastEventsState createState() => _PastEventsState();
}

class _PastEventsState extends State<PastEvents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Query(pastEvents, variables: {
        'id': widget.id,
      }, builder: ({
        bool loading,
        Map data,
        Exception error,
      }) {
        print(data);
        if (loading) {
          return Text("Loading...");
        }
        if (error != null) {
          return Text("Some error fetching data");
        }
        if (data == null) {
          return Center(
              child: Text(
            "error",
            style: TextStyle(color: Colors.grey),
          ));
        }
        if (data != null && data['pastEvents'].length == 0) {
          return Center(
              child: Text(
            "You have not participated in any event",
            style: TextStyle(color: Colors.grey),
          ));
        }
        return Swiper(
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                var route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EventDetailScreen(data['pastEvents'][index]['_id']));
                Navigator.of(context).push(route);
              },
              child: Column(
                children: <Widget>[
                  Image.network(
                    data['pastEvents'][index]['imageLink'],
                    fit: BoxFit.fill,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(data['pastEvents'][index]['date']),
                      Text(data['pastEvents'][index]['time'])
                    ],
                  ),
                  Text(data['pastEvents'][index]['name']),
                ],
              ),
            );
          },
          itemCount: data['pastEvents'].length,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
        );
      }),
    );
  }
}
