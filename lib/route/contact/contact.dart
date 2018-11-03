import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailContact.dart';
import 'package:project_sle/global/record.dart';

class ContactPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ContactState();
}

class ContactState extends State<ContactPage> {
  
  Container builder(Record record){
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: ListTile(
        leading: record.level =="admin"? Icon(Icons.star):SizedBox(),
        title: Text(record.displayName),
        trailing: Text(record.phoneNumber),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(record: record),
            )
          );
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: builder(record)
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
          Hero(
            tag:'image11',
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/11.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken), fit: BoxFit.cover,),
              ),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text("연락처",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  centerTitle: true,
                  backgroundColor: Colors.white70,
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
