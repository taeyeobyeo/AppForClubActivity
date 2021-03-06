import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sle/global/currentUser.dart' as cu;

class DetailDataPage extends StatefulWidget {
  final Map<String,dynamic> data;
  DetailDataPage({Key key, @required this.data})
    : assert(data != null),
    super(key: key);

  @override
  State<StatefulWidget> createState() => DetailDataState(data: data);

}

class DetailDataState extends State<DetailDataPage>{
  TextEditingController _classofController = TextEditingController();
  final Map<String,dynamic> data;

  @override
  void dispose() { 
    _classofController.dispose();
    super.dispose();
  }

  DetailDataState({Key key, @required this.data})
    : assert(data != null);

  @override
  initState(){
    _classofController.text = data["body"];
    super.initState();
  }

  Future<Null> _fixDescription() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data["head"]["title"]),
          contentPadding: EdgeInsets.all(30.0),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _classofController,
                  maxLines: 100,
                  decoration: InputDecoration.collapsed(
                    hintText: "내용을 입력하세요",
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
                await Firestore.instance.collection('club').document('슬기짜기').collection('database').document(data["head"]["title"]).updateData({
                  "body": _classofController.text,
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
        child: 
        Text("편집",
          style: TextStyle(
            color: Colors.black
          ),
        ), 
        // Icon(Icons.subject, color: Theme.of(context).accentColor,),
        onPressed: (){
          _fixDescription();
        },
      );
    else return null;
  }

  IconButton _delete(){
    return IconButton(
      icon: Icon(Icons.delete),
      disabledColor: Colors.transparent,
      onPressed: cu.currentUser.getLevel() == "admin"?(){
        Firestore.instance.collection('club').document('슬기짜기').collection('database').document(data["head"]["title"]).delete();
        Navigator.pop(context);
      }:null,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: _fix(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage("assets/images/2.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(data["head"]["title"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  centerTitle: true,
                  backgroundColor: Colors.white70,
                  floating: true,
                  snap: true,
                  actions: <Widget>[
                    _delete(),
                  ],
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
                ListView(
                  padding: EdgeInsets.all(20.0),
                  children: <Widget>[
                    ListTile(
                      leading: Text("분류: " + data['head']['type']),
                      trailing: Text("작성자: "+ data['head']["author"]),
                    ),
                    Divider(color: Colors.black ,),
                    Text(
                      _classofController.text,
                      softWrap: true,
                    ),
                  ],
                ),
              ],)
            ),
          ),
        ],
      )
    );
  }
}
