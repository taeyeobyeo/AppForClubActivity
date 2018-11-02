import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sle/global/currentUser.dart' as cu;

class IntroPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => IntroState();
  
}

class IntroState extends State<IntroPage> {
  TextEditingController _classofController = TextEditingController();
  
  Future<Null> _fixDescription() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('동아리 소개'),
          contentPadding: EdgeInsets.all(30.0),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _classofController,
                  maxLines: 100,
                  decoration: InputDecoration.collapsed(
                    hintText: cu.currentUser.getClass(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('수정'),
              onPressed: () async{
                await Firestore.instance.collection('club').document('슬기짜기').updateData({
                  "description": _classofController.text,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  FloatingActionButton _fix(){
    if(cu.currentUser.getLevel() == "admin")
      return FloatingActionButton(
        backgroundColor: Colors.white70,
        child: Icon(Icons.subject, color: Theme.of(context).accentColor,),
        onPressed: (){
          _fixDescription();
        },
      );
    else return null;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: _fix(),
      body: Stack(
          children: <Widget>[
          Hero(
            tag:'image16',
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/16.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
              ),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text("동아리 소개",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  backgroundColor: Colors.white70,
                  centerTitle: true,
                  floating: true,
                  snap: true,
                  // pinned: true,
                ),
              ];
            },
            body: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance.collection('club').document('슬기짜기').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                _classofController.text = snapshot.data['description'].toString();
                return ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height/4*3,
                      margin: EdgeInsets.fromLTRB(20.0,40.0,20.0,20.0),
                      decoration: new BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: ListView(
                        padding: EdgeInsets.all(20.0),
                        children: <Widget>[
                          Text(_classofController.text)
                        ],
                      ),
                    )
                  ],
                );
              }
            ),
          ),
        ],
      )
    );
  }
}