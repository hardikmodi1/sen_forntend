import 'package:flock/eventsTab/eventDetailScreen.dart';
import 'package:flock/graphql/events/query/futureEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FutureEvents extends StatefulWidget {
  final String id;
  FutureEvents(this.id);
  @override
  _FutureEventsState createState() => _FutureEventsState();
}

class _FutureEventsState extends State<FutureEvents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Query(futureEvents, variables: {
        'id': widget.id,
      }, builder: ({
        bool loading,
        Map data,
        Exception error,
      }) {
        if (loading) {
          return Text("Loading...");
        }
        if (error != null) {
          return Text("Some error fetching data");
        }
        if (data != null && data['futureEvents'].length == 0) {
          return Center(
              child: Text(
            "No upcoming events for you!",
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
                        EventDetailScreen(data['futureEvents'][index]['_id']));
                Navigator.of(context).push(route);
              },
              child: Column(
                children: <Widget>[
                  Image.network(
                    data['futureEvents'][index]['imageLink'],
                    fit: BoxFit.fill,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new Icon(
                            Icons.calendar_today,
                            color: Colors.cyan,
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                new Text(data['futureEvents'][index]['date']),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          new Icon(
                            Icons.watch_later,
                            color: Colors.cyan,
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                new Text(data['futureEvents'][index]['time']),
                          )
                        ],
                      ),
                    ],
                  ),
                  Text(data['futureEvents'][index]['name']),
                ],
              ),
            );
          },
          itemCount: data['futureEvents'].length,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
        );
      }),
    );
  }
}
