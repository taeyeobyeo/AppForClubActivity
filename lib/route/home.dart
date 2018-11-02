import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_sle/global/currentUser.dart' as cu;


class HomePage extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => HomeState();

}

class HomeState extends State<HomePage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final String photo = cu.currentUser.getphotoUrl();
  @override
  void initState(){
    super.initState();
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await cu.currentUser.googleLogOut();
    Navigator.pop(context);
    Navigator.pop(context);
  }

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
              // width: MediaQuery.of(context).size.width -40,
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

  Drawer createDrawer(){
    if(cu.currentUser.getLevel() == "admin"){
      return Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(cu.currentUser.getDisplayName()),
              accountEmail: Text(cu.currentUser.getEmail()),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: NetworkImage(photo),
              ),
              decoration: BoxDecoration(
                // border: Border.all(width: 0.5),
                image: DecorationImage(
                  image: AssetImage("assets/images/7.jpg"),
                  fit: BoxFit.cover,
                )
              ),
            ),
            ListTile(
              title: Text("설정"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context,'/configure');
              },
            ),
            ListTile(
              title: Text("동아리 회원관리"),
              onTap: (){
                Navigator.pushNamed(context, '/secret');
              },
            ),
            ListTile(
              title: Text("로그아웃"),
              onTap: ()=>_signOut(context),
            ),
          ],
        ),
      );
    }
    else return Drawer(
      child: ListView(
        children: <Widget>[
         UserAccountsDrawerHeader(
            accountName: Text(cu.currentUser.getDisplayName()),
            accountEmail: Text(cu.currentUser.getEmail()),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: NetworkImage(photo),
            ),
            decoration: BoxDecoration(
              // border: Border.all(width: 0.5),
              image: DecorationImage(
                image: AssetImage("assets/images/7.jpg"),
                fit: BoxFit.cover,
              )
            ),
          ),
          ListTile(
            title: Text("설정"),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context,'/configure');
            },
          ),
          ListTile(
            title: Text("로그아웃"),
            onTap: ()=>_signOut(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.menu,
      //       semanticLabel: 'menu',
      //     ),
      //     onPressed: (){
      //       _scaffoldKey.currentState.openDrawer();
      //     },
      //   ),
      //   title: Text("슬기짜기",
      //             style: TextStyle(
      //               fontWeight: FontWeight.bold,
      //             )),
      //   centerTitle: true,
      // ),
      drawer: createDrawer(),
      body: 
      NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height /5,
              pinned: true,
              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  semanticLabel: 'menu',
                ),
                onPressed: (){
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("슬기짜기",
                    style: TextStyle(
                      fontSize: 16.0,
                    )),
                background: Hero(
                  tag:'image13',
                  child: Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(image: new AssetImage("assets/images/13.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Center(
          child: OrientationBuilder(
            builder: (context, orientation) {
              return GridView.count(
                crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                padding: EdgeInsets.all(16.0),
                childAspectRatio: 2.4,
                children: <Widget>[
                  imageButton("동아리 소개", 16, context,'/intro'),
                  imageButton("동아리 자료", 21, context,'/database'),
                  imageButton("자유 계시판", 18, context,''),
                  imageButton("수업지원", 24, context,'/class'),
                  imageButton("연락처", 11, context,'/contact'),
                ],
              );
            },
          ),
        ),
      ),
      
    );
  }
}