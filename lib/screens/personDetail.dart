import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/user/query/singleUserDetail.dart' as query;

class PersonDetail extends StatefulWidget {
  final String detailId, id;
  PersonDetail(this.id, this.detailId);
  _PersonDetailState createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffededed),
        body: Query(query.singleUserDetail,
            variables: {'id': widget.detailId, 'visitorId': widget.id},
            builder: ({
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
                    title: Text(
                      data['singleUserDetail']['username'] == null
                          ? data['singleUserDetail']['email']
                          : data['singleUserDetail']['username'],
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    background: GestureDetector(
                      child: data['singleUserDetail']['image'] == null
                          ? Image.asset("assets/user.png", fit: BoxFit.cover)
                          : Image.network(data['singleUserDetail']['image']),
                    )),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 50.0,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.account_circle),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                          Text(
                            data['singleUserDetail']['username'] == null
                                ? data['singleUserDetail']['email']
                                : data['singleUserDetail']['username'],
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w400),
                          ),
                        ],
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
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.phone),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                          Text(
                            data['singleUserDetail']['phone'],
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
