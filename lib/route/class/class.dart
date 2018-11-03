import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailClass.dart';

class ClassPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ClassState();
}

class ClassState extends State<ClassPage>{
  final List<String> _years = ['All','1', '2', '3', '4'].toList();
  String _selection;
  void select1(String s){
    setState(() {
          _selection = s;
        });
  }
  final List<String> _type = ['C프로그래밍', 'Java', 'OODP', 'C++',''].toList();
  String _selection2;
  void select2(String s){
    setState(() {
          _selection2 = s;
        });
  }
  
  @override
  void initState() {
    _selection = _years.first;
    _selection2 = _type.first;
    super.initState();
  }

  Container _filter(Function func,String value, List<DropdownMenuItem<String>> dropdownMenuOptions){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      width: MediaQuery.of(context).size.width/2 -20,
      padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child:  DropdownButton(
        value: value,
        items: dropdownMenuOptions,
        onChanged: (s){
          func(s);
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    Map<String, dynamic> map = data.data;
    String title = data.data["head"]["title"];
    String body = data.data["body"];
    // print(title + body);
    return FlatButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => DetailClassPage(data: map),
        ));
      },
      child: Container(
        key: ValueKey(title),
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        width: MediaQuery.of(context).size.width-20.0,
        height: 200.0,
        padding: EdgeInsets.all(20.0),
        decoration: new BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          children: <Widget>[
            Text(title,style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    body,
                    maxLines: 5,
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  FloatingActionButton _fix(){
    return FloatingActionButton(
      backgroundColor: Colors.white70,
      child: Icon(Icons.add, color: Theme.of(context).accentColor,),
      onPressed: (){
        Navigator.pushNamed(context, '/addClass');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownMenuOptions = _years
      .map((String item) =>
        new DropdownMenuItem<String>(value: item, child: new Text(item))
      )
      .toList();
    final dropdownMenuOptions2 = _type
      .map((String item) =>
        new DropdownMenuItem<String>(value: item, child: new Text(item))
      )
      .toList();

    return Scaffold(
      floatingActionButton: _fix(),
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
            body:StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('club').document('슬기짜기').collection('classes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _filter(select1,_selection, dropdownMenuOptions),
                        _filter(select2,_selection2, dropdownMenuOptions2),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: snapshot.data.documents.map((data)=>_buildListItem(context, data)).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      )
    );
  }
}