import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  TextEditingController _addProffessor = TextEditingController();

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

  String _add(){
    String prof = _addProffessor.text;
    _addProffessor.clear();
    if(prof != ""){
      setState(() {
        proffessors.add(prof);
      });
    }
    Firestore.instance.collection('club').document('슬기짜기').collection('classes').document(data['head']['title']).setData({
      "head":{
        "title": data['head']['title'],
        "교수님": proffessors,
      },
      "body": data['body']
    });
    return prof;
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
    return FloatingActionButton(
      backgroundColor: Colors.white70,
      child: Icon(Icons.subject, color: Theme.of(context).accentColor,),
      onPressed: (){
        _fixDescription();
      },
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
              image: new DecorationImage(image: new AssetImage("assets/images/15.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken), fit: BoxFit.cover,),
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
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        Firestore.instance.collection('club').document("슬기짜기").collection('classes').document(data['head']['title']).delete();
                        Navigator.pop(context);
                      },
                    ),
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
                    ExpansionTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.school),
                          Text(" 교수님"),
                        ],
                      ),
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
                                    controller: _addProffessor,
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
                                    String prof = _add();
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content:Text(prof+ " 추가됨"),
                                    ));
                                  },
                                ),
                              ],
                            );
                          },
                        ),           
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(00.0),
                              child: ListTile(
                                trailing: Text("밀어서 삭제"),
                                // leading: Text("Scroll to search"),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(),
                              ),
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
                                      Firestore.instance.collection('club').document('슬기짜기').collection('classes').document(data['head']['title']).setData({
                                        "head":{
                                          "title": data['head']['title'],
                                          "교수님": proffessors,
                                        },
                                        "body": data['body'],
                                      });
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(content: Text(proffessor +" 삭제됨"),)
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text("설명"),
                      children: <Widget>[
                        Text(
                          _classofController.text,
                          softWrap: true,
                        ),
                      ],
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
