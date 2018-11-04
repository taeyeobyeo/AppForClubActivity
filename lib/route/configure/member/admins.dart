import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sle/global/record.dart';

class AdminPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AdminState();
}

class AdminState extends State<AdminPage> {
  List<String> items = ["회장","부회장","총무","전임원","미입력"].toList();
  
  Container builder(Record record){
    final dropdownMenuOptions = items
      .map((String item) =>
        new DropdownMenuItem<String>(value: item, child: new Text(item))
      )
      .toList();
    String v = record.specific;
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
      child: ListTile(
        title: Text(record.displayName),
        trailing: DropdownButton(
          items: dropdownMenuOptions,
          value: v,
          onChanged: (value) {
            Firestore.instance.collection('club').document('슬기짜기').collection('users').document(record.uid).updateData({
              "specific": value,
            });
            setState(() {
              v = value;
            });
          },
        ),
      ),
    );
  }
  
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('club').document('슬기짜기').collection('users').where("level", isEqualTo: "admin").snapshots(),
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
                  centerTitle: true,
                  backgroundColor: Colors.white70,
                  expandedHeight: 200.0,
                  primary: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("임원단 관리",
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    background: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("임원단 역활을 알려주세요",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
