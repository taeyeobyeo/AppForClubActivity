import 'package:flutter/material.dart';

class BoardPage extends StatelessWidget {
  Widget imageButton (String text BuildContext context, String navigator){
    return FlatButton(
      padding: EdgeInsets.all(10.0),
      onPressed: (){
        Navigator.pushNamed(context, navigator);
      },
      child: Container(
        width: MediaQuery.of(context).size.width-20,
        height: MediaQuery.of(context).size.height/2,
        decoration: new BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text(text,
            style: TextStyle(
              fontSize: 36.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
          Hero(
            tag:'image18',
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/18.jpg"), 
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), 
                fit: BoxFit.cover,),
              ),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text("자유게시판",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  backgroundColor: Colors.white70,
                  centerTitle: true,
                  floating: true,
                  snap: true,
                  // pinned: true,
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
                      imageButton("공지", context,'/announcement'),
                      imageButton("잡담", context,'/smallTalk'),
                      imageButton("슬년회", context,'/seul'),
                      imageButton("수업", context,'/classBoard'),
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