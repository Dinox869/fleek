import 'package:flutter/material.dart';
import 'package:fleek/screen_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:fleek/display.dart';
import 'package:fleek/mapping.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class Results extends StatefulWidget{
  String string;
  Results({
    Key key, this.string,}): super(key : key);

  @override
  result createState()=> result();
}

class result extends State<Results> with TickerProviderStateMixin {




  @override
  final search = TextEditingController();
  bool inivar = true;
  Stream<QuerySnapshot> _stream;
  @override
  void iniState()
  {
    super.initState();
    setState(() {
      _stream = (widget.string == null || widget.string.trim() == "")?
      Firestore.instance.collection("hotel entry").snapshots():
      Firestore.instance.collection("hotel entry").where("searchIndex",arrayContains: widget.string.toString().toLowerCase()).snapshots();
    });
    //Cause the widget not to reload...
  }
  @override
  void dispose(){
    super.dispose();
  }
//  void didUpdateWidget( Results oldWidget)
//  {
//    super.didUpdateWidget(oldWidget);
//
//  }

  Widget _Stream(){
    return new StreamBuilder<QuerySnapshot>(
        stream: (widget.string == null || widget.string.trim() == "")?
        Firestore.instance.collection("hotel entry").snapshots():
        Firestore.instance.collection("hotel entry").where("searchIndex",arrayContains: widget.string.toString().toLowerCase()).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot>snapshot) {
          if (snapshot.hasError)
          {
            return Center(
                child:Text("Error occured..")
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height:screenHeight(context,dividedBy: 1),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              );
            default:
              return ListView(
                padding: EdgeInsets.only(left: 15, right: 15),
                primary: false,
                shrinkWrap: true,
                children: buildList(snapshot.data.documents, context),
              );
          }
        }
    );
  }



  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0xff25242A),
              child: Padding(
                padding: EdgeInsets.only(top: 29, bottom: 10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          dispose();
                          Navigator.pop(context);
                        }),
                    SizedBox(width: 20),
                    Flexible(
                      child: TextField(
                        autofocus: false,

                        cursorColor: Colors.white,
                        controller: search,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Satisfy-Regular.ttf',
                            fontWeight: FontWeight.bold
                        ),
                        decoration: InputDecoration(
                            hintText: "  Search here!",
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Satisfy-Regular.ttf'
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 01, vertical: 10),
                            suffixIcon: Material(
                              elevation: 4.0,
                              color: Color(0xfff7f7f7),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),),
                              child: IconButton(
                                  icon: new Icon(Icons.search),
                                  color: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              Results(
                                                string: search.text.toString(),)
                                      ));
//                                            widget.string = search.text.toString();
//                                            print("======rer======");
                                    });
                                  }
                              ),
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    Column(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.map,
                          color: Colors.white,

                        ), onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                              mapping()
                          ));
                        }),
                        Text("Maps.",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white
                          ),
                        )
                      ],

                    ),

                  ],
                ),
              ),
            ),
            _Stream(),
          ],
        ),
      ),
    );
  }
}

List<Widget> buildList(List<DocumentSnapshot> documents, BuildContext context) {
  List<Widget> _list = [];
  for(DocumentSnapshot document in documents)
  {
    _list.add(buildListitems(document,context));
  }
  return _list;
}
Widget buildListitems(DocumentSnapshot document, BuildContext context) {
  return GestureDetector
    (
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          display(name: document.data['name'],)
      ));
    },
    child: Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: EdgeInsets.only(top: 05, bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            child: FadeInImage
              (
              placeholder: new AssetImage("albums/bird.jpg"),
              image: new NetworkImage(document.data['url']),
              fit: BoxFit.fill,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 05, right: 05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  document.data['name'],
                  style: TextStyle(
                      color: Colors.cyan[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                SmoothStarRating(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: 4,
                  size: 20,
                  color: Colors.cyan[800],
                  spacing: 0.0,
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 05, right: 05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.location_on),
                      Text(
                        document.data['distance'],
                        //"frefw",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),)
                    ],
                  ),
                  Text(
                    document.data['rating'],
                    //"ewfwef",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                    ),)
                ],
              )
          ),
        ],
      ),
    ),
  );
}