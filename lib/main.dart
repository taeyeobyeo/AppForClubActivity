import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(RouteApp());

class RouteApp extends StatefulWidget {
  @override
  RouteState createState() => RouteState();
}

class RouteState extends State<RouteApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main',
      home: HomePage(),
      initialRoute: '/home',
      routes:{
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        // '/search': (context) => SearchPage(),
        // '/favorite':(context) => FavoritePage(),
        // '/ranking':(context) => RankingPage(),
        // '/mypage':(context) => MyPage(),
        // '/language':(context) => LanguagePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage("assets/images/7.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(height:140.0),
                FlatButton(
                  child: Text("슬기짜기",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80.0,
                    ),
                  ),
                  onPressed: ()=>{},
                ),
                SizedBox(height:250.0),
                FlatButton(
                  child: Text("Login With Google ID",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: ()=>{},
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}