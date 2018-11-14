import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sle/global/currentUser.dart' as cu;

import 'package:project_sle/route/home.dart';
import 'package:project_sle/route/intro.dart';
import 'package:project_sle/route/class/class.dart';
import 'package:project_sle/route/database/database.dart';
import 'package:project_sle/route/contact/contact.dart';
import 'package:project_sle/fail.dart';
import 'package:project_sle/route/configure/configure.dart';
import 'package:project_sle/route/configure/secretConfigure.dart';
import 'package:project_sle/route/configure/general/personalSetting.dart';
import 'package:project_sle/route/configure/general/mobileSpecification.dart';
import 'package:project_sle/route/database/addData.dart';
import 'package:project_sle/route/class/addClass.dart';
import 'package:project_sle/route/configure/member/addUser.dart';
import 'package:project_sle/route/configure/member/members.dart';
import 'package:project_sle/route/configure/member/admins.dart';
import 'package:project_sle/route/configure/member/active.dart';
import 'package:project_sle/route/board/board.dart';
import 'package:project_sle/route/board/announcement/announcement.dart';
import 'package:project_sle/route/board/smallTalk/smallTalk.dart';
import 'package:project_sle/route/board/seul/seul.dart';
import 'package:project_sle/route/board/class/classBoard.dart';

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
        accentColor: Colors.black,
      ),
      initialRoute: '/login',
      // onGenerateRoute: '/login',
      routes:{
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/intro': (context) => IntroPage(),
        '/database':(context) => DatabasePage(),
        '/class':(context) => ClassPage(),
        '/contact':(context) => ContactPage(),
        '/failed':(context) => LoginFailPage(),
        '/configure': (context) => ConfigurePage(),
        '/secret':(context) => SecretPage(),
        '/personal': (context) => PersonalPage(),
        '/mobile': (context)=> MobileSpecificationPage(),
        '/addData': (context) => AddDataPage(),
        '/addClass': (context) => AddClassPage(),
        '/addUser' : (context) => AddUserPage(),
        '/members' : (context) => MembersPage(),
        '/admins' : (context) => AdminPage(),
        '/active' : (context) => ActiveUsersPage(),
        '/board' : (context) => BoardPage(),
        '/announcement' : (context) => AnnouncementPage(),
        '/smallTalk' : (context) => SmallTalkPage(),
        '/seul' : (context) => SeulPage(),
        '/classBoard' : (context) => ClassBoardPage(),
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
  void initState() { 
    super.initState();
    _signIn();
  }

  void setCurrentUser(FirebaseUser user, DateTime logintime){
    cu.currentUser.setCurrentUser(
      user.displayName,
      user.email,
      logintime,
      user.photoUrl,
      user.uid
    );
  }

  void _updateUserData(FirebaseUser user)async {
    DateTime now = DateTime.now();
    setCurrentUser(user, now);
    Firestore.instance.collection('club').document('슬기짜기').collection('users').document(user.uid).get().then((doc){
      if(doc.exists){
        Firestore.instance.runTransaction((Transaction transaction)async{
          CollectionReference reference = Firestore.instance.collection('club').document('슬기짜기').collection('users');
          reference.document('${user.uid}').updateData({
            "uid": user.uid,
            "displayName": user.displayName,
            "photoUrl": user.photoUrl,
            "email": user.email,
            "finalLogin": now
          });
        });
        Navigator.pushNamed(context, '/home');
      }
      else{
        Firestore.instance.runTransaction((Transaction transaction)async{
        CollectionReference reference = Firestore.instance.collection('club').document('슬기짜기').collection('guest');
          reference.document('${user.uid}').setData({
            "uid": user.uid,
            "displayName": user.displayName,
            "email": user.email,
            "finalLogin": now,
          });
        });
        //입장권한이 안됨
        Navigator.pushNamed(context, '/failed');
      }
    }).catchError((e)=>print(e)); 
  }

  Future<FirebaseUser> _signIn()  async {
    GoogleSignInAccount googleSignInAccount = await cu.currentUser.getGoogleLogIn().signIn().catchError((e)=>print(e));
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    
    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );
    // print(user);

    // _googleSignIn.signOut();               
    // print("User Name : ${user.displayName}");
    return user;
  
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
        Hero(
           tag:'image13',
           child:
          Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/13.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
              ),
            ),
         ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text("슬기짜기",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 80.0,
                    ),
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, '/intro');
                  },
                ),
                FlatButton(
                  child: Text("Login With Google ID",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: ()async{
                    _signIn().then((user)=>_updateUserData(user))
                      .catchError((e)=>print(e));
                  },
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}