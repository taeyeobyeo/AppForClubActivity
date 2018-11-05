import 'package:flutter/material.dart';
import 'package:project_sle/global/currentUser.dart' as cu;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigurePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ConfigureState();

}

class ConfigureState extends State<ConfigurePage> {
  bool alarmON = true;
  bool lowQuality = false;
  
  /*Only a widget is allowed
   *Multiple widgets will create error */
  Container _whiteEdgeBox( String title, Widget widget){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.all(20.0),
      decoration: new BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Column(
        children: <Widget>[
          _subTitle(title),
          Divider(color: Colors.black87),
          Expanded(
            child: widget,
          ),
        ],
      ),
    );
  }

  Future<Null> _fixDescription() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("회원탈퇴"),
          contentPadding: EdgeInsets.all(30.0),
          content: SingleChildScrollView(
            child: Text("주의: 탈퇴시 재가입하려면 새로 승인을 받아야 합니다.",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold
              ),
              softWrap: true,
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
              child: Text('확인'),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
                Firestore.instance.collection('club').document('슬기짜기').collection('users').document(cu.currentUser.getUid()).delete();
                cu.currentUser.googleLogOut();
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: "image37",
            child:  Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/37.jpg"), 
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.overlay), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text("설정",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  backgroundColor: Colors.white70,
                  centerTitle: true,
                  floating: true,
                  snap: true,
                ),
              ];
            },
            body: Center(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return GridView.count(
                    crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                    padding: EdgeInsets.all(16.0),
                    childAspectRatio: 1.5,
                    children: <Widget>[
                      _whiteEdgeBox("계정정보",
                        ListView(
                          padding: EdgeInsets.all(0.0),
                          children: <Widget>[
                            ListTile(
                              title: Text("정보 수정"),
                              onTap: (){
                                Navigator.pushNamed(context, '/personal');
                                // fixPersonal();
                              },
                            ),
                            ListTile(
                              title: Text("회원탈퇴"),
                              onTap: (){
                                _fixDescription();
                              },
                            ),
                          ],
                        )
                      ),
                      _whiteEdgeBox("알림 설정",
                        ListView(
                          children: <Widget>[
                            ListTile(
                              title: Text("푸쉬알림 허용"),
                              trailing: Switch(
                                value: alarmON,
                                onChanged: (bool s){
                                  setState(() {
                                    alarmON = s;
                                  });
                                },
                              ),
                            )
                          ]
                        )
                      ),
                      _whiteEdgeBox("앱 설정",
                        ListView(
                          children: <Widget>[
                            ListTile(
                              title: Text("저사양 모드"),
                              trailing: Switch(
                                value: lowQuality,
                                onChanged: (bool s){
                                  setState(() {
                                    lowQuality = s;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      _whiteEdgeBox("버전 정보",
                        ListView(
                          children: <Widget>[
                            ListTile(
                              title: Text("앱 버전"),
                              trailing: Text("v1.0"),
                              onLongPress: (){
                                Navigator.pushNamed(context, '/mobile');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      )
    );
  }
}