import 'package:flutter/material.dart';
import 'package:project_sle/global/currentUser.dart'as cu;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDataPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddDataState();
  
}

class AddDataState extends State<AddDataPage>{
  String title = "탭해서 제목 변경";
  TextEditingController _titleController = TextEditingController();
  TextEditingController body = TextEditingController();

  final List<String> _type = ['all','회계', '활동내역', '명단', '제출서류', '인수인계'].toList();
  String _selection2;
  void select2(String s){
    setState(() {
      _selection2 = s;
    });
  }

  @override
  void dispose() { 
    _titleController.dispose();
    body.dispose();
    super.dispose();
  }
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

  Container _filter(Function func,String value, List<DropdownMenuItem<String>> dropdownMenuOptions){
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 20.0),
      width: MediaQuery.of(context).size.width/4,
      // padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
      // decoration: BoxDecoration(
      //   color: Colors.white70,
      //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
      // ),
      child:  DropdownButton(
        value: value,
        items: dropdownMenuOptions,
        onChanged: (s){
          func(s);
        },
      ),
    );
  }

  Future<Null> _fixTitle() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('제목'),
          contentPadding: EdgeInsets.all(30.0),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration.collapsed(
                    hintText: "제목을 입력해주세요",
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
                title = _titleController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  FloatingActionButton _submit(){
    return FloatingActionButton(
      backgroundColor: Colors.white70,
      child: Icon(Icons.subdirectory_arrow_left, color: Theme.of(context).accentColor,),
      onPressed: ()async{
        if(_selection2=="all") _selection2 = "";
        await Firestore.instance.collection('club').document('슬기짜기').collection('database').document(title).setData({
          "head":{
            "author": cu.currentUser.getDisplayName(),
            "title": title,
            "type": _selection2,
          },
          "body": body.text
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownMenuOptions2 = _type
      .map((String item) =>
        new DropdownMenuItem<String>(value: item, child: new Text(item))
      )
      .toList();

    return Scaffold(
      floatingActionButton: _submit(),
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
                  title: Text("동아리 자료",
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
                  ListTile(
                    title: Text(title),
                    trailing: _filter(select2, _selection2, dropdownMenuOptions2),
                    onTap: (){
                      _fixTitle();
                    },
                  )
                ),
                _whiteEdgeBox(
                  TextField(
                    controller: body,
                    maxLines: 50,
                    decoration: InputDecoration(
                      hintText: "내용을 입력해 주세요"
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}