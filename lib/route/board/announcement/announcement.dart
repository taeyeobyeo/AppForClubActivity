import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:project_sle/global/article.dart';
import 'package:project_sle/global/currentUser.dart' as cu;
import 'package:project_sle/route/board/common/detailBoard.dart';
import 'package:project_sle/route/board/common/addData.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>AnnouncementState();
}

class AnnouncementState extends State<AnnouncementPage>{
  int view = 5;
  void initState() {
    super.initState();
  }

  Widget imageController (Article article){
    if(article.image.length == 0) return SizedBox();
    else {
      int len = article.image.length;
      switch(len){
        case 1:
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              child: Hero(
                tag: article.id,
                child: Image(
                  height: 240.0,
                  image: NetworkImage(article.image[0]),
                  fit: BoxFit.cover,
                ),
              ),
              onPressed: (){},
            ),
          );
          break;

        case 2: 
        return 
        Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                FlatButton(
                  child: SizedBox(
                    height: 240.0,
                    width: MediaQuery.of(context).size.width/2 -20,
                    child: Hero(
                      tag: article.id,
                      child: Image(
                        image: NetworkImage(article.image[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(0.0),
                  onPressed: (){
                    // print("page1");
                  },
                ),
                FlatButton(
                  child: SizedBox(
                    height: 240.0,
                    width: MediaQuery.of(context).size.width/2 - 20,
                    child: Hero(
                      tag: article.id+"1",
                      child: Image(
                        image: NetworkImage(article.image[1]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(0.0),
                  onPressed: (){},
                ),
              ],
            ),
          );
          break;

        default:
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                FlatButton(
                  child: SizedBox(
                    height: 240.0,
                    width: MediaQuery.of(context).size.width*2/3 -20,
                    child: Hero(
                      tag: article.id,
                      child: Image(
                        image: NetworkImage(article.image[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(0.0),
                  onPressed: (){
                    // print("page1");
                  },
                ),
                Column(
                  children: <Widget>[
                    FlatButton(
                      child: SizedBox(
                        height: 120.0,
                        width: MediaQuery.of(context).size.width/3 - 20,
                        child: Hero(
                          tag: article.id+"1",
                          child: Image(
                            image: NetworkImage(article.image[1]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(0.0),
                      onPressed: (){},
                    ),
                    FlatButton(
                      child: Stack(
                        children: <Widget>[
                          SizedBox(
                            height: 120.0,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            child: Hero(
                              tag: article.id+"2",
                              child: Image(
                                image: NetworkImage(article.image[2]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: 120.0,
                            width: MediaQuery.of(context).size.width/3 - 20,
                            decoration:BoxDecoration(
                              color: Colors.black26
                            ),
                            child: Center(
                              child:Text("+${len - 2}",
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(0.0),
                      onPressed: (){
                        print(3);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
          break;
      }
    }
  }

  Card card(Article article){
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        children: <Widget>[
          imageController(article),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(article.photoUrl),
            ),
            title: Text(article.name),
            subtitle: Text(article.date.toLocal().toString()),
            trailing: article.uid == cu.currentUser.getUid()?IconButton(icon: Icon(Icons.close),
              onPressed: (){
                int count = article.image.length;
                StorageReference storageRef = FirebaseStorage.instance.ref().child('/announcement/${article.id}');
                for(int i = 0;i < count; i++){
                  storageRef.child('$i').delete();
                }
                Firestore.instance.collection('club').document('슬기짜기').collection('announcement').document(article.id).delete();
              },
            ):SizedBox(),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
            child: Text(
              article.body,
              style: TextStyle(
                fontSize: 16.0
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  Icon(Icons.thumb_up,
                  ),
                  Text("   " + article.like.toString()),
                ],),
                onPressed: (){},
              ),
              FlatButton(
                child: Text("더보기"),
                onPressed: (){
                  Navigator.push(context, 
                    MaterialPageRoute(
                      builder: (context) => DetailAnnouncementPage(data: article),
                    )
                  );
                },
              ),
              FlatButton(
                child: Text("댓글달기"),
                onPressed: (){},
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final article = Article.fromSnapshot(data);
    return Padding(
      key: ValueKey(article.id),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: card(article)
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("글쓰기",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white70,
        onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => AddAnnouncementPage(from:1)),
          );
        },
      ),
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
                  title: Text("공지",
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
            body: Column(
              children: <Widget>[
                Flexible(
                  child:
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('club').document('슬기짜기').collection('announcement').orderBy("id", descending: true).limit(view).snapshots(),
                  builder: (context,snapshot){
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return _buildList(context, snapshot.data.documents);
                  },
                ),
                ),
                IconButton(
                  icon: Icon(Icons.replay,color: Colors.white,),
                  onPressed: ()async{
                    setState(() {
                      view+=5;   
                    });
                    // print(view);
                  },
                )
                
              ],
            )
            
          ),
        ],
      )
    );
  }

}