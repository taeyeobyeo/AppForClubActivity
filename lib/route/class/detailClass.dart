import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sle/global/currentUser.dart' as cu;

class DetailClassPage extends StatefulWidget {
  final Map<String,dynamic> data;
  DetailClassPage({Key key, @required this.data})
    : assert(data != null),
    super(key: key);

  @override
  State<StatefulWidget> createState() => DetailClassState(data: data);

}

class DetailClassState extends State<DetailClassPage>{
  TextEditingController _classofController = TextEditingController();
  final Map<String,dynamic> data;
  List<dynamic> proffessors;
  DetailClassState({Key key, @required this.data})
    : assert(data != null);

  @override
  initState(){
    _classofController.text = data["body"];
    proffessors = data["head"]["교수님"].toList();
    // print(proffessors);
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
                await Firestore.instance.collection('club').document('슬기짜기').collection('classes').document(data["head"]["title"]).updateData({
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
        child: Icon(Icons.subject, color: Theme.of(context).accentColor,),
        onPressed: (){
          _fixDescription();
        },
      );
    else return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: _fix(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage("assets/images/24.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
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
                      leading: Text("교수님:"),
                      title: Text(proffessors.toString()),
                    ),
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
