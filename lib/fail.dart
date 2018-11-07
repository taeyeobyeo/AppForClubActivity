import 'package:flutter/material.dart';
import 'package:project_sle/global/currentUser.dart' as cu;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginFailPage extends StatelessWidget{
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
         Hero(
            tag:'image13',
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/13.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[                
                _whiteEdgeBox(
                  Text(
                    "이 앱은 \"슬기짜기\" 동아리원이 아니면 사용할 수 없습니다.\n 현재 동아리 임원단에게 승인요청을 보냈으며, 승인이 된 이후에 사용이 가능합니다.\n *승인요청을 취소하시려면 \'요청 취소\'버튼을 눌러주십시오.\n *다른 아이디로 로그인하시려면 \'뒤로\'버튼을 눌러주십시오.\n 승인이 완료 또는 거절되면 푸쉬알림을 받으실 수 있습니다.",
                    style: TextStyle(
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.black45,
                      textColor: Colors.white,
                      child: Text("요청 취소"),
                      onPressed: ()async {
                        String id = cu.currentUser.getUid().toString();
                        //로그아웃
                        cu.currentUser.googleLogOut();
                        await FirebaseAuth.instance.signOut();
                        //db삭제
                        Firestore.instance.collection('club').document('슬기짜기').collection('guest').document(id).delete();
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      child: Text("뒤로"),
                      onPressed: ()async{
                        cu.currentUser.googleLogOut();
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}