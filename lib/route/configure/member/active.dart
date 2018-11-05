import 'package:flutter/material.dart';
import 'package:project_sle/global/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sle/route/configure/member/chart.dart';

class ActiveUsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ActiveUsersState();

}
class ActiveUsersState extends State<ActiveUsersPage>{
  List<String> items = ["","활동","비활동","졸업생","임원단"].toList();
  List<String> chart = List();

  void initState() { 
    makeChart();
    super.initState();
  }
  void makeChart()async{
    chart.clear();
    var db = await Firestore.instance.collection('club').document('슬기짜기').collection('users').getDocuments();
    db.documents.forEach((document){
      chart.add(document.data["state"]);
    });
  }

  Container builder(RecordS record){
    final dropdownMenuOptions = items
      .map((String item) =>
        new DropdownMenuItem<String>(value: item, child: new Text(item))
      )
      .toList();
    String v = record.state;
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
              "state": value,
            });
            makeChart();
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
    final record = RecordS.fromSnapshot(data);
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
                  title: Text("활동 회원 설정",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  backgroundColor: Colors.white70,
                  centerTitle: true,
                  // pinned: true,
                  floating: true,
                  snap: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.insert_chart),
                      onPressed: (){
                        Navigator.push(context, 
                          MaterialPageRoute(
                            builder: (context) => AnalyzeUserPage(list: chart,),
                          )
                        );
                      },
                    ),
                  ],
                ),
              ];
            },
            body: _buildBody(context),
          ),
        ],
      ),
    );
  }

}