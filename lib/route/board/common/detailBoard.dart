import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_sle/global/article.dart';
import 'package:project_sle/global/currentUser.dart' as cu;

class DetailAnnouncementPage extends StatefulWidget {
  final Article data;
  DetailAnnouncementPage({Key key, @required this.data})
    : assert(data != null),
    super(key: key);
  @override
  State<StatefulWidget> createState() => DetailAnnouncementState(data: data);
}

class DetailAnnouncementState extends State<DetailAnnouncementPage>{
  final Article data;
  List<dynamic> proffessors;
  TextEditingController _reply = new TextEditingController();
  DetailAnnouncementState({Key key, @required this.data})
    : assert(data != null);
  
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
                    width: MediaQuery.of(context).size.width/2,
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
                    width: MediaQuery.of(context).size.width/2,
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
                    width: MediaQuery.of(context).size.width*2/3,
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
                        width: MediaQuery.of(context).size.width/3,
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
                            width: MediaQuery.of(context).size.width/3,
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
                            width: MediaQuery.of(context).size.width/3,
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

  
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Column(
      children: snapshot.map((dataD) => _buildListItem(context, dataD)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot dataD) {
    return Padding(
      key: ValueKey(dataD.data['id']),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width - 10,
        // height: 68.0,
        child: 
        Column(
          children: <Widget>[
             Row(
              children: <Widget>[
                CircleAvatar(backgroundImage: NetworkImage(dataD.data['photoUrl']),
                    radius: 12.0,),
                SizedBox(width: 14.0,),
                Container(
                  width: MediaQuery.of(context).size.width*2/3,
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: dataD.data['name']+": ", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: dataD.data['content'],),
                      ],
                    ),
                  )
                ),
                
                dataD.data['uid']==cu.currentUser.getUid()?
                IconButton(icon: Icon(Icons.delete,size: 20.0,),onPressed: (){
                  Firestore.instance.collection('club').document('슬기짜기').collection('announcement').document(data.id).collection('댓글').document(dataD.data['id']).delete();
                },):SizedBox(),
              ],
            ),
            
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // floatingActionButton: _fix(),
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
                  title: Text(data.date.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  centerTitle: true,
                  backgroundColor: Colors.white70,
                  floating: true,
                  snap: true,
                ),
              ];
            },
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white70
              ),
              child: ListView(
                children: <Widget>[
                  imageController(data),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data.photoUrl),
                    ),
                    title: Text(data.name),
                    subtitle: Text(data.date.toLocal().toString()),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.body,
                      style: TextStyle(
                        fontSize: 16.0
                      ),
                      maxLines: 100,
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
                          Text("   " + data.like.toString()),
                        ],),
                        onPressed: (){},
                      ),
                      SizedBox(),
                      SizedBox(),
                      SizedBox(),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('club').document('슬기짜기').collection('announcement').document(data.id).collection('댓글').snapshots(),
                    builder: (context,snapshot){
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      // return SizedBox(height: 200.0,);
                      return _buildList(context, snapshot.data.documents);
                    },
                  ),
                  //댓글창
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(backgroundImage: NetworkImage(cu.currentUser.getphotoUrl())),
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          child: TextField(
                            controller: _reply,
                          ),
                        ),
                        RaisedButton(
                          child: Text("댓글달기"),
                          onPressed: ()async {
                            if(_reply.text == "") return;
                            DateTime now = DateTime.now();
                            await Firestore.instance.collection('club').document('슬기짜기').collection('announcement').document(data.id).collection('댓글').document(now.toString()).setData({
                              "id": now.toString(),
                              "uid": cu.currentUser.getUid(),
                              "name": cu.currentUser.getDisplayName(),
                              "photoUrl": cu.currentUser.getphotoUrl(),
                              "date": now,
                              "content": _reply.text,
                            });
                            _reply.clear();
                          }
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      )
    );
  }
  @override
    void dispose() {
      _reply.dispose();
      super.dispose();
    }
}
