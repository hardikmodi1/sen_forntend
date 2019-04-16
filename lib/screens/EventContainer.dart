import 'package:flock/eventsTab/events.dart';
import 'package:flock/eventsTab/futureEvents.dart';
import 'package:flock/eventsTab/pastEvents.dart';
import 'package:flutter/material.dart';

class EventContainer extends StatefulWidget {
  final String id;
  EventContainer(this.id);
  @override
  _EventContainerState createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flock"),
        elevation: 0.7,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: "EVENTS"),
            Tab(
              text: "PAST",
            ),
            Tab(text: "FUTURE")
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Events(widget.id),
          PastEvents(widget.id),
          FutureEvents(widget.id),
        ],
      ),
    );
  }
}
