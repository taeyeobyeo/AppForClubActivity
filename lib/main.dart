import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'route/home.dart';
import 'route/intro.dart';

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
      home: LoginPage(),
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.transparent,
      ),
      initialRoute: '/login',
      routes:{
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/intro': (context) => IntroPage(),
        // '/favorite':(context) => FavoritePage(),
        // '/ranking':(context) => RankingPage(),
        // '/mypage':(context) => MyPage(),
        // '/language':(context) => LanguagePage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new LoginState();
}

class LoginState extends State<LoginPage>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );
    print("User Name : ${user.displayName}");
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
         Hero(
            tag:'image7',
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/7.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
              ),
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
                  onPressed: (){
                    Navigator.pushNamed(context, '/intro');
                  },
                ),
                SizedBox(height:250.0),
                FlatButton(
                  child: Text("Login With Google ID",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: (){
                    _signIn()
                      .then((FirebaseUser user)=>print(user)
                      )
                      .catchError((e)=>print(e));
                    Navigator.pushNamed(context, '/home');
                  }
                  ,
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}