import 'package:flutter/material.dart';

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
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/37.jpg"), 
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.overlay), 
                fit: BoxFit.cover,
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
                            ),
                            ListTile(
                              title: Text("회원탈퇴"),
                            ),
                            ListTile(
                              title: Text("회원탈퇴"),
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