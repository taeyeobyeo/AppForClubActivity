import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddUserState();

}

class AddUserState extends State<AddUserPage>{
  Container _whiteEdgeBox(Widget widget){
    return Container(
      // height: MediaQuery.of(context).size.height/4,
      width: MediaQuery.of(context).size.width -20,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.all(20.0),
      decoration: new BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: widget
    );
  }
  @override
  void initState() {
    // Firestore.instance.collection('club').document('슬기짜기').collection('guest').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/37.jpg"), 
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.overlay), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  // title: Text("승인요청",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  // )),
                  backgroundColor: Colors.white70,
                  expandedHeight: 150.0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("승인요청",
                        style: TextStyle(
                          fontSize: 16.0,
                        )),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black54
                          ]
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("<<Swipe Left to Delete",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.black
                            ),
                          ),
                          Text("Swipe Right to ADD>>",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pinned: true,
                  // centerTitle: true,
                  // floating: true,
                  // snap: true,
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                _whiteEdgeBox(
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('club').document('슬기짜기').collection('guest').snapshots(),
                    builder: (context, snapshot){
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      return Container(
                        width: MediaQuery.of(context).size.width-20,
                        height: MediaQuery.of(context).size.height/2,
                        child: ListView(
                          padding: EdgeInsets.all(20.0),
                          children: snapshot.data.documents.map((data){
                            return Dismissible(
                                key: Key(data['uid']),
                                child: 
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    // gradient: LinearGradient(
                                    //   colors: [
                                    //     Colors.blue,
                                    //     Colors.red
                                    //   ]
                                    // ),
                                  ),
                                  child: ExpansionTile(
                                    title: Text(data['displayName']),
                                    children: <Widget>[
                                      Text(data['email']),
                                      Text(data['finalLogin'].toString()),
                                    ],
                                  ),
                                ),
                                onDismissed: (direction){
                                  if(direction == DismissDirection.endToStart){
                                    //delete
                                  }
                                  else{
                                    Firestore.instance.collection('club').document('슬기짜기').collection('users').document(data['uid']).setData({
                                      "uid": data['uid'],
                                      "level": "member",
                                    });
                                  }
                                  Firestore.instance.collection('club').document('슬기짜기').collection('guest').document(data['uid']).delete();
                                },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}