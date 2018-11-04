import 'package:flutter/material.dart';
import 'package:project_sle/global/record.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final Record record;
  DetailPage({Key key, @required this.record})
    : assert(record != null),
    super(key: key);
  ListView info(){
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        record.level == "admin"?
        ListTile(
          leading: Icon(Icons.star,
            color: Colors.yellow,
          ),
          title: Text("serving as"),
          trailing: Text(record.specific),
        )
        :SizedBox(),
        ListTile(
          leading: Icon(Icons.school,
            color: Colors.black,
          ),
          title: Text("학번:"),
          trailing: Text(record.classof),
        ),
        ListTile(
          leading: Icon(Icons.email,
            color: Colors.white,
          ),
          title: Text("email:"),
          trailing: Text(record.email,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          onTap: ()=>_mail(record.email),
        ),
        
        ListTile(
          leading: Icon(Icons.call,
            color: Colors.green,
          ),
          title: Text("전화번호:"),
          trailing: Text(record.phoneNumber,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          onTap: ()=>_call(record.phoneNumber),
        ),
      ],
    );
  }
  _call(url) async {
    String call = "tel://" + url;
    if (await canLaunch(call)) {
      await launch(call);
    } else {
      print("failed");
    }
  }

  _mail(url) async {
    if (url != ""){
      String call = "mailto:" + url;
      if (await canLaunch(call)) {
        await launch(call);
      } else {
        print("failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage("assets/images/11.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken), fit: BoxFit.cover,),
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
