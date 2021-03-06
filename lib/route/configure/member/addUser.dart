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
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("승인요청",
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    background: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("<<Swipe Left to Delete",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.redAccent
                            ),
                          ),
                          Text("Swipe Right to ADD>>",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.indigoAccent
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // pinned: true,
                  // centerTitle: true,
                  floating: true,
                  snap: true,
                ),
              ];
            },
            body: ListView(
              children: <Widget>[
                _whiteEdgeBox(
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('club').document('슬기짜기').collection('guest').snapshots(),
                    builder: (context, snapshot){
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      return Container(
                        width: MediaQuery.of(context).size.width-20,
                        height: MediaQuery.of(context).size.height/3*2,
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
                                  ),
                                  child: ExpansionTile(
                                    title: Text("이름:   " + data['displayName']),
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            ListTile(
                                              leading: Text("email: "),
                                              trailing: Text(data['email']),
                                            ),
                                            ListTile(
                                              leading: Text("Request at: "),
                                              trailing: Text(data['finalLogin'].toString()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onDismissed: (direction){
                                  if(direction == DismissDirection.endToStart){
                                    //delete
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(data['displayName']+" 삭제됨"),));
                                  }
                                  else{
                                    Firestore.instance.collection('club').document('슬기짜기').collection('users').document(data['uid']).setData({
                                      "displayName":data['displayName'],
                                      "uid": data['uid'],
                                      "email": data['email'],
                                      "level": "member",
                                    });
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(data['displayName']+" 추가됨"),));
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