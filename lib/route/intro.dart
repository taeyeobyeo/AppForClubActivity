import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("동아리 소개"),
        centerTitle: true,
      ),
      body: Stack(
          children: <Widget>[
          Hero(
            tag:'image7',
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("assets/images/7.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), fit: BoxFit.cover,),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Stack(children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                )
              ),
              ListView(
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  Text("hello")
                ],
              ),
            ],)
          ),
        ],
      )
    );
  }
}