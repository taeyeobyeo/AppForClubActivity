import 'package:flutter/material.dart';

class SecretPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SecretState();
}

class SecretState extends State<SecretPage>{
  List<Widget> strings = List();
  
  Container _whiteEdgeBox ( String title, Widget widget){
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
            tag:'image37',
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/37.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.overlay), fit: BoxFit.cover,),
              ),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text("동아리 회원 관리",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  backgroundColor: Colors.white70,
                  centerTitle: true,
                  // pinned: true,
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
                      _whiteEdgeBox("승인요청",
                        ListView(
                          children: <Widget>[
                            ListTile(
                              title: Text("새로운 승인요청"),
                              onTap: ()=>Navigator.pushNamed(context, '/addUser'),
                            ),
                          ],
                        ),
                      ),
                      _whiteEdgeBox("회원관리",
                        ListView(
                          children: <Widget>[
                            ListTile(
                              title: Text("임원단"),
                              onTap: (){
                                Navigator.pushNamed(context, '/admins');
                              },
                            ),
                            ListTile(
                              title: Text("회원관리"),
                              onTap: (){
                                Navigator.pushNamed(context, '/members');
                              },
                            ),
                            ListTile(
                              title: Text("활동인원"),
                            ),
                          ],
                        ),
                      ),
                      // _whiteEdgeBox("아직 안정함",
                      //   ListView(
                      //     children: <Widget>[
                      //       ListTile(
                      //         title: Text("임원단"),
                      //       ),
                      //       ListTile(
                      //         title: Text("회원관리"),
                      //       ),
                      //       ListTile(
                      //         title: Text("활동인원"),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // _whiteEdgeBox("뭐로할까",
                      //   ListView(
                      //     children: <Widget>[
                      //       ListTile(
                      //         title: Text("임원단"),
                      //       ),
                      //       ListTile(
                      //         title: Text("회원관리"),
                      //       ),
                      //       ListTile(
                      //         title: Text("활동인원"),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
