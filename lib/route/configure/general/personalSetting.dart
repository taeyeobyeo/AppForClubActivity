import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:project_sle/global/currentUser.dart' as cu;

class PersonalPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PersonalState();
}

class PersonalState extends State<PersonalPage> with TickerProviderStateMixin {
  List<Widget> strings = List();
  TextEditingController _classofController = TextEditingController();

  Future<Null> _fixClass() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('학번'),
          contentPadding: EdgeInsets.all(30.0),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _classofController,
                  maxLength: 2,
                  decoration: InputDecoration.collapsed(
                    hintText: "'13','15'와 같이 학번을 입력해주세요",
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
                if(_classofController.text != ""){ 
                  await Firestore.instance.collection('club').document('슬기짜기').collection('users').document(cu.currentUser.getUid().toString()).updateData({
                    "classof": _classofController.text,
                  });
                  cu.currentUser.setClass(_classofController.text);
                  _classofController.clear();
                }
                else{
                  await Firestore.instance.collection('club').document('슬기짜기').collection('users').document(cu.currentUser.getUid().toString()).updateData({
                    "classof": null,
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _fixPhoneNumber() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('전화번호'),
          contentPadding: EdgeInsets.all(30.0),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _classofController,
                  maxLength: 3+4+4,
                  decoration: InputDecoration.collapsed(
                    hintText: "-없이 입력해주세요",
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
                if(_classofController.text != ""){ 
                  await Firestore.instance.collection('club').document('슬기짜기').collection('users').document(cu.currentUser.getUid().toString()).updateData({
                    "phoneNumber": _classofController.text,
                  });
                  cu.currentUser.setPhoneNumber(_classofController.text);
                  _classofController.clear();
                }
                else{
                  await Firestore.instance.collection('club').document('슬기짜기').collection('users').document(cu.currentUser.getUid().toString()).updateData({
                    "phoneNumber": null,
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  Text _subTitle (String text){
    return Text(text,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Widget _buildAnimation(BuildContext context, Widget child) {
  //   return Container(
  //     padding: padding.value,
  //     alignment: Alignment.bottomCenter,
  //     child: Opacity(
  //       opacity: opacity.value,
  //       child: Container(
  //         width: width.value,
  //         height: height.value,
  //         decoration: BoxDecoration(
  //           color: color.value,
  //           border: Border.all(
  //             color: Colors.indigo[300],
  //             width: 3.0,
  //           ),
  //           borderRadius: borderRadius.value,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                // title: const Text('개인 정보',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                centerTitle: true,
                // floating: true,
                // snap: true,
                backgroundColor: Colors.white70,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("개인정보관리",
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                  // background: Center(
                  //   child: AnimatedBuilder(
                  //     builder: _buildAnimation,
                  //     animation: controller,
                  //   ),
                  // ),
                  background: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("학번과 전화번호를 입력해주세요!",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _whiteEdgeBox(Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[ CircleAvatar(
                              backgroundImage: NetworkImage(cu.currentUser.getphotoUrl()),
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                      _subTitle(cu.currentUser.getDisplayName()),
                      Divider(color: Colors.black87),
                      ListTile(
                        leading: Text("학번"),
                        trailing: Text(cu.currentUser.getClass()),
                        onTap: (){
                          _fixClass();
                        },
                      ),
                      ListTile(
                        leading: Text("전화번호"),
                        trailing: Text(cu.currentUser.getPhoneNumber()),
                        onTap: (){
                          _fixPhoneNumber();
                        },
                      ),
                      ListTile(
                        leading: Text("email"),
                        trailing: Text(cu.currentUser.getEmail()),
                        onTap: (){},
                      ),
                      ListTile(
                        leading: Text("마지막 로그인"),
                        trailing: Text(cu.currentUser.getFinalLogin().toString()),
                        onTap: (){},
                      ),
                    ],
                  ),
                )]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
