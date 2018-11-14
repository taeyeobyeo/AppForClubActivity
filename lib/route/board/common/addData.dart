import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sle/global/currentUser.dart' as cu;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddAnnouncementPage extends StatefulWidget {
  final int from;
  @override
  AddAnnouncementPage({@required this.from}):assert(from!=null);
  State<StatefulWidget> createState() =>AddAnnouncementState(from: from);
}

class AddAnnouncementState extends State<AddAnnouncementPage>{
  List<String> _types = ["공지","잡담","슬년회","수업"].toList();
  String type = "announcement";
  DateTime now = DateTime.now();
  TextEditingController _content = new TextEditingController();
  List<File> _images = List();
  int from;
  int length;
  String _selection;
  void _select(String s){
    setState(() {
      _selection = s;
    });
  }
  
  AddAnnouncementState({@required this.from}):assert(from!=null);

  @override
  void initState() {
    switch(from){
      case 1: _selection = _types.first;
      break;
      case 2: _selection = _types.elementAt(1);
      break;
      case 3: _selection = _types.elementAt(2);
      break;
      case 4: _selection = _types.elementAt(3);
      break;
    }
    super.initState();
  }

  @override
  void dispose() { 
    _content.dispose();
    super.dispose();
  }

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image ==null) return;
    setState(() {
      _image = image;
      _images.add(_image);
    });
  }

  Container _filter(Function func,String value, List<DropdownMenuItem<String>> dropdownMenuOptions){
    return Container(
      width: MediaQuery.of(context).size.width/4,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
      child:  DropdownButton(
        value: value,
        items: dropdownMenuOptions,
        onChanged: (s){
          func(s);
        },
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownMenuOptions = _types
      .map((String item) =>
        new DropdownMenuItem<String>(value: item, child: new Text(item))
      )
      .toList();
    return Scaffold(
      body: Stack(
          children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage("assets/images/18.jpg"), 
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn), 
              fit: BoxFit.cover,),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text("글쓰기",
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
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70
                  ),
                ),
                ListView(
                  children: <Widget>[
                    //image upload
                    //이름 및 작성자 정보
                    Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(cu.currentUser.getphotoUrl()),
                            ),
                            title: Text(cu.currentUser.getDisplayName(),style: TextStyle(color: Colors.white),),
                            subtitle: Text(now.toString(),style: TextStyle(color: Colors.white),),
                            trailing: _filter(_select, _selection, dropdownMenuOptions),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.image),
                                onPressed: ()=>getImage(),
                              ),
                              FlatButton(
                                child: Text("글쓰기",style:TextStyle(color:Colors.white)),
                                onPressed: ()async{
                                  if(_content.text =="") showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text("내용이 없습니다!"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("확인"),
                                            onPressed: ()=>Navigator.pop(context),
                                          )
                                        ],
                                      );
                                    }
                                  );
                                  else{
                                    Navigator.pop(context);
                                    List<String> data = List();
                                    for(int i =0;i<_images.length;i++){
                                      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child('$type/${now.toString()}/$i').putFile(_images[i]);
                                      data.add(await (await uploadTask.onComplete).ref.getDownloadURL());
                                    }
                                    switch(_selection){
                                      case "공지":
                                        type = "announcement";
                                      break;
                                      case "잡담":
                                        type = "smallTalk";
                                      break;
                                      case "슬년회":
                                        type = "seul";
                                      break;
                                      case "수업":
                                        type = "classBoard";
                                      break;
                                    }
                                    Firestore.instance.collection('club').document('슬기짜기').collection(type).document(now.toString()).setData({
                                      "date": now,
                                      "body": _content.text,
                                      "id": now.toString(),
                                      "like": 0,
                                      "image": data,
                                      "writer":{
                                        "id": cu.currentUser.getUid(),
                                        "name": cu.currentUser.getDisplayName(),
                                        "photoUrl": cu.currentUser.getphotoUrl(),
                                      }
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            width: MediaQuery.of(context).size.width-20,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 70.0,
                                  height: 70.0,
                                  padding: EdgeInsets.all(1.0),
                                  child: Image.file(_images[index], fit: BoxFit.cover),
                                );
                              },
                            )
                          )
                        ],
                      ),
                    ),
                    //본문
                    Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: TextFormField(
                        controller: _content,
                        keyboardType: TextInputType.multiline,
                        maxLines: 15,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "내용을 입력해주세요!"
                        ),
                      ),
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