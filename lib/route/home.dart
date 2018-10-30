import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Widget imageButton (String text, int pic, BuildContext context, String navigator){
    return FlatButton(
      padding: EdgeInsets.all(10.0),
      onPressed: (){
        Navigator.pushNamed(context, navigator);
      },
      child: Stack(
        children: <Widget>[
          Hero(
            tag: "image$pic",
            child: Container(
              width: 360.0,
              height: 140.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: new AssetImage("assets/images/$pic.jpg"),
                  colorFilter: ColorFilter.mode(Colors.black38, BlendMode.colorBurn),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                // border: Border.all(color: Colors.black),
              ),
              
            ),
            
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "\n"+text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            semanticLabel: 'menu',
          ),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text("슬기짜기"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              // margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/23.jpg"),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/32.jpg"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            ListTile(
              title: Text("계정관리"),
            ),
            ListTile(
              title: Text("알림허용"),
            ),
            ListTile(
              title: Text("검은화면"),
            ),
            ListTile(
              title: Text("로그아웃"),
            ),
          ],
        ),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.fromLTRB(10.0,20.0,10.0,10.0),
          children: <Widget>[
            imageButton("동아리 소개", 7, context,'/intro'),
            imageButton("동아리 자료", 13, context,""),
            imageButton("자유 계시판", 18, context,''),
            imageButton("수업지원", 14, context,''),
            imageButton("연락처", 11, context,''),
          ],
        ),
      ),
    );
  }
}