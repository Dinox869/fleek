import 'package:flutter/material.dart';
import 'package:fleek/curve/customecurve.dart';
import 'package:fleek/results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleek/screen_reducer.dart';
import 'app_localization.dart';




class home extends StatefulWidget{
  @override
  homes createState () => homes();
}
class homes extends State<home>
{
  final search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body:Container(
          child: Column(
            children: <Widget>[
              Container(
                child: CustomPaint(
                  painter: Curvez(),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: screenHeight(context,dividedBy: 3),
                        width: screenWidth(context,dividedBy: 1),
                        padding: EdgeInsets.only(top: 10),
                        child: Image.asset('albums/hotel.jpg'),
                      ),
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).translate('first_string'),
                            style: TextStyle(
                                color: Color(0xff25242A),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'GreatVibes-Regular.ttf'
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(padding: EdgeInsets.symmetric(horizontal: 32),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.all(Radius.circular(30.0),),
                  child: TextField(
                    controller: search,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        suffixIcon: Material(
                          elevation: 5.0,
                          color: Color(0xff25242A),
                          borderRadius: BorderRadius.all(Radius.circular(30.0),),
                          child: IconButton(
                              icon: new Icon(Icons.search),color: Colors.white,
                              onPressed:(){
                                //   _addDatabase("Corner hotel");
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                    Results(
                                      string: search.text.toString(),
                                    )
                                ));
//                              Navigator.push(context,MaterialPageRoute(builder: (context)=>
//                              profile()
//                              ));
                              }
                          ),
                        ),
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth(context,dividedBy: 3),
                height: screenHeight(context,dividedBy: 6),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('albums/beatnik.png'),
                        fit: BoxFit.cover ),
                    borderRadius: BorderRadius.circular(80.0),
                    border: Border.all(
                        color: Colors.white,
                        width: 10.0
                    )
                ),
              ),
              SizedBox(height: 20),
              Text("Hello Gabriel",
                style: TextStyle(
                    color: Color(0xff25242A),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GreatVibes-Regular.ttf'
                ),)
            ],
          ),
        )
    );
  }
}
void _addDatabase(String name)
{
  List<String> splitList = name.split(" ");
  List<String> indexLists = [];
  for(int i= 0; i < splitList.length; i++)
  {
    for(int y = 1; y< splitList[i].length + 1;y++)
    {
      indexLists.add(splitList[i].substring(0,y).toLowerCase());
    }
  }
  print(indexLists);

  Firestore.instance.collection('hotel entry').document('gu9CwUS8HMne74niYHdW').setData({
    'searchIndex': indexLists
  },
      merge: true
  );

}