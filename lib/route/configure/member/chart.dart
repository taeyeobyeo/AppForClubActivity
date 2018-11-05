import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyzeUserPage extends StatefulWidget {
  final List<String> list;
  AnalyzeUserPage({Key key, @required this.list})
    : assert(list != null),
    super(key: key);
  @override
  State<StatefulWidget> createState() => AnalyzeUserState(list: list);
}

class AnalyzeUserState extends State<AnalyzeUserPage> {
  final List<String> list;
  List<charts.Series<Item, String>> finalList;
  AnalyzeUserState({Key key, @required this.list})
    : assert(list != null);
  
  @override
  void initState() {
    finalList = _initList();
    super.initState();
  }

  Container _whiteEdgeBox(Widget widget){
    return Container(
      height: MediaQuery.of(context).size.height/3,
      width: MediaQuery.of(context).size.width -20,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.all(20.0),
      decoration: new BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: widget
    );
  }

  List<charts.Series<Item, String>> _initList(){
    int a=0, b=0, c=0, d=0,e=0;
    list.forEach((f){
      if(f == "활동") a++;
      else if(f == "비활동") b++;
      else if(f == "졸업생") c++;
      else if(f == "임원단") d++;
      else if(f == "") e++;
    });
    final data = [
      new Item('활동', a),
      new Item('비활동', b),
      new Item('졸업생', c),
      new Item('임원단', d),
      new Item('미설정', e),
    ];

    return [
      new charts.Series<Item, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Item sales, _) => sales.name,
        measureFn: (Item sales, _) => sales.value,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage("assets/images/37.jpg"), colorFilter: ColorFilter.mode(Colors.grey, BlendMode.overlay), fit: BoxFit.cover,),
            ),
          ),
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text("활동 회원 그래프",
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
                _whiteEdgeBox(
                  charts.PieChart(finalList,animate: true,
                    defaultRenderer: charts.ArcRendererConfig(
                      arcWidth: 40,
                      startAngle: 2/5 * 3.141592, arcLength: 6 / 4 * 3.141592,
                      arcRendererDecorators: [
                        charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.inside
                        )
                      ]
                    ),
                  ), 
                ),
                _whiteEdgeBox(charts.PieChart(finalList,animate: true,
                    defaultRenderer: charts.ArcRendererConfig(
                      arcWidth: 60,
                      arcRendererDecorators: [
                        charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.inside
                        )
                      ]
                    ),
                  ),
                ),
              ],
            )
                
          ),
        ],
      ),
    );
  }
}

class Item {
  final String name;  //label
  final int value;
  Item(this.name, this.value);
}