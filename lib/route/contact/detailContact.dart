import 'package:flutter/material.dart';
import 'package:project_sle/global/record.dart';

class DetailPage extends StatelessWidget {
  final Record record;
  DetailPage({Key key, @required this.record})
    : assert(record != null),
    super(key: key);
  ListView info(){
    
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        ListTile(
          title: Text("email:"),
          trailing: Text(record.email),
        ),
        ListTile(
          title: Text("학번:"),
          trailing: Text(record.classof),
        ),
        ListTile(
          title: Text("전화번호:"),
          trailing: Text(record.phoneNumber),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage("assets/images/11.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(record.displayName,
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
            body: Container(
              padding: EdgeInsets.all(20.0),
              child: Stack(children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )
                ),
                info(),
              ],)
            ),
          ),
          
        ],
      )
    );
  }
}
