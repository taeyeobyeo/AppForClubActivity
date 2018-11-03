import 'package:flutter/material.dart';
import 'package:project_sle/global/currentUser.dart'as cu;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClassPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddClassState();
  
}

class AddClassState extends State<AddClassPage>{
  TextEditingController _title = TextEditingController();
  TextEditingController _proffessor = TextEditingController();
  TextEditingController _body = TextEditingController();
  List<dynamic> proffessors = List();


  Container _whiteEdgeBox (Widget widget){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.all(20.0),
      decoration: new BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: widget,
    );
  }

  FloatingActionButton _submit(){
    return FloatingActionButton(
      child: Icon(Icons.send,
        color: Theme.of(context).accentColor,
      ),
      backgroundColor: Colors.white70,
      onPressed: (){
        Firestore.instance.collection('club').document('슬기짜기').collection('classes').document(_title.text).setData({
          "head":{
            "title": _title.text,
            "교수님": proffessors,
          },
          "body": _body.text,
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _submit(),
      body: Stack(
          children: <Widget>[
          Hero(
            tag:'image15',
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/15.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken), fit: BoxFit.cover,),
              ),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text("수업지원",
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
            body: ListView(
              children: <Widget>[
                _whiteEdgeBox(
                  Column(
                    children: <Widget>[
                      ExpansionTile(
                        title: Text("과목이름"),
                        children: <Widget>[
                          TextField(
                            controller: _title,
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text("교수님"),
                        children: <Widget>[
                          Builder(
                            builder: (context){
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    // height: 40.0,
                                    width: MediaQuery.of(context).size.width/2 - 10,
                                    child: TextField(
                                      controller: _proffessor,
                                      maxLength: 20,
                                      maxLines: 1,
                                      decoration: InputDecoration.collapsed(
                                        hintText: "교수님을 추가해주세요",
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    child: Text("추가"),
                                    onPressed: (){
                                      String prof = _proffessor.text;
                                      _proffessor.clear();
                                      if(prof != ""){
                                        setState(() {
                                          proffessors.add(prof);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          Divider(
                            color: Colors.black87,
                          ), 
                          Container(
                            margin: EdgeInsets.all(20.0),
                            width: MediaQuery.of(context).size.width -20,
                            height: MediaQuery.of(context).size.height/4,
                            child: ListView.builder(
                              itemCount: proffessors.length,
                              itemBuilder: (context, index){
                                final proffessor = proffessors[index].toString();
                                return Dismissible(
                                  key: Key(proffessor),
                                  child: ListTile(title:Text(proffessor)),
                                  onDismissed: (direction){
                                    setState((){
                                      proffessors.removeAt(index);
                                    });
                                    // Firestore.instance.collection('club').document('슬기짜기').collection('classes').document(data['head']['title']).setData({
                                    //   "head":{
                                    //     "title": data['head']['title'],
                                    //     "교수님": proffessors,
                                    //   },
                                    //   "body": data['body'],
                                    // });
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(proffessor + " 삭제됨"),duration: Duration(milliseconds: 500),));
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text("설명"),
                        children: <Widget>[
                          TextField(
                            controller: _body,
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}