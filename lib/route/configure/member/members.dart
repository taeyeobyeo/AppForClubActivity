import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sle/global/record.dart';

class MembersPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MembersState();
}

class MembersState extends State<MembersPage> {
  
  Container builder(Record record){
    bool a = record.level == "admin"? true : false;
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
      child: SwitchListTile(
        value: a,
        title: Text(record.displayName), 
        onChanged: (bool value) {
          if (value)
            Firestore.instance.collection('club').document('슬기짜기').collection('users').document(record.uid).updateData({
              "level": "admin",
              "specific": "미입력"
            });
          else 
            Firestore.instance.collection('club').document('슬기짜기').collection('users').document(record.uid).updateData({
              "level": "member",
            });
          setState(() {
            a = value;
          });
        },
      ),
    );
  }
  
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('club').document('슬기짜기').collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.displayName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: builder(record)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage("assets/images/37.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.overlay), fit: BoxFit.cover,),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  // title: Text("회원 관리",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  // )),
                  centerTitle: true,
                  backgroundColor: Colors.white70,
                  expandedHeight: 200.0,
                  primary: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("회원 관리",
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    background: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("주의: toggle시 관리자권한이 주어집니다.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.redAccent
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // pinned: true,
                  floating: true,
                  snap: true,
                ),
              ];
            },
            body: _buildBody(context),
          ),
        ],
      )
    );
  }
}
