import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fleek/add_cart.dart';
import 'package:fleek/screen_reducer.dart';
import 'package:fleek/add_cart.dart';
import 'package:cache_image/cache_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_read_more_text/flutter_read_more_text.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:fleek/product.dart';
import 'package:fleek/check_in.dart';
import 'package:fleek/mapping.dart';

class display extends StatefulWidget {
  final name;
  display({Key key,
    this.name}): super(key : key);


  @override
  displays createState() => displays();
}

class displays extends State<display> with SingleTickerProviderStateMixin
{
  final gone = TextEditingController();
  final text = 'Among the finest five star hotel in Nyeri, the Wick hotel is set in beautifully landscaped tropical gardens,'
      ' on a superb location in the exclusive Amathus area and 11km from Nyeri town center. Standing in extensive grounds,'
      ' the resort offers an impressive range of facilities and an unrivalled standard of personal service and sheer comfort.';
  StreamSubscription<QuerySnapshot> subsription,subscriptionz;
  StreamSubscription<DocumentSnapshot> subscriptions;
  int photoIndex = 0;
  int photoIndexs = 0;
  int peg;
  String  map;
  List<DocumentSnapshot>maps,details,imageUrls,dataz,imageUrl;
  //create collection pic folder.

  TabController _tabController;
  ScrollController _scrollController;

  void _previousImage()
  {
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex - 1 : 0 ;
    });
  }

  void _nextImage(){
    setState(() {
      photoIndex = photoIndex < imageUrl.length - 1 ? photoIndex + 1 : photoIndex;
    });
  }
  int _page = 0;
  @override
  void initState()
  {
    super.initState();
    final CollectionReference documentReference = Firestore.instance.collection(widget.name.toString());
    subsription = documentReference.snapshots().listen((datasnapshot){
      setState(() {
        imageUrl = datasnapshot.documents;
      });
    });
    final CollectionReference documentReferencez = Firestore.instance.collection("cache_data");
    subscriptionz = documentReference.snapshots().listen((datasnapshot){
      setState(() {
        imageUrl = datasnapshot.documents;

      });
    });
    DocumentReference documentReferences = Firestore.instance.collection("google_map").document(widget.name.toString());
    subscriptions = documentReferences .snapshots().listen((datasnapshot) {
      setState(() {
        map = datasnapshot.data['url'].toString();
      });
    });
    rooms();


    _tabController = TabController(length: 2, vsync:  this );
    _scrollController =  ScrollController();
  }

  @override
  void dispose(){
    subsription?.cancel();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget states()
  {
    if (_page == 0)
    {
      //widget for details page
      return info();
    }
    else if (_page == 1)
    {
      //widget for food page
      return food();
    }
    else if (_page == 2)
    {
      //widget for drinks page.
      return drink();
    }
    else if (_page == 3)
    {
      //widget for accomodation.
      return accomodation();
    }
    else if (_page == 4)
    {
      //widget for extra's.
      return extras();
    };
  }

  Widget info()
  {

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: screenHeight(context,dividedBy: 2.75),
                  child: Hero(
                      tag: imageUrl[photoIndex].data[widget.name.toString()],
                      child: new FadeInImage(
                        placeholder: new AssetImage("albums/bird.jpg"),
                        image: new NetworkImage(imageUrl[photoIndex].data[widget.name.toString()]),
                        fit: BoxFit.fill,
                      )
                  ),
                ),
                GestureDetector(
                    child: Container(
                        height: screenHeight(context,dividedBy: 2.75),
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent
                    ),
                    onTap: _nextImage
                ),
                GestureDetector(
                    child: Container(
                        height: screenHeight(context,dividedBy: 2.75),
                        width: MediaQuery.of(context).size.width / 2,
                        color: Colors.transparent
                    ),
                    onTap: _previousImage
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15,top: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                        iconSize: 25,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      Text(widget.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PressStart2P-Regular.ttf',
                              fontSize: 13
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.favorite),
                              color: Colors.white,
                              onPressed: (){
                                //action on press
                              }),
                          IconButton(
                            icon: Icon(Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                  cart()
                              ));
                            },
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                Positioned(
                    top: screenHeight(context,dividedBy: 3),
                    left: screenWidth(context,dividedBy: 2.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        selectedPhoto(
                            numberofDots: imageUrl.length,
                            photoIndex: photoIndex
                        )
                      ],
                    )
                )
              ],
            ),
            SizedBox(height: 05),
            Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                margin: EdgeInsets.only(top: 10,right: 10, left: 10),
                child: Column(
                  children: <Widget>[
                    Text("About "+ widget.name,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Divider(),
                    ReadMoreText(text)
                  ],
                )
            ),
            SizedBox(height: 05),
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              margin: EdgeInsets.only(top: 05,right: 10, left: 10),
              child: Stack(
                children: <Widget>[
                  Hero(
                      tag: map,
                      child: new FadeInImage(
                        placeholder: new AssetImage("albums/bird.jpg"),
                        image: new NetworkImage(map),
                        fit:BoxFit.fill,
                      )
                  ),
                  Text("Location",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Divider(),
                  Align(
                    alignment: Alignment.topRight,
                    child:
                    FloatingActionButton.extended(
                      onPressed: ()
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>
                            mapping()
                        ));
                      },
                      label: Text("Go",
                        style: TextStyle(
                            fontSize: 08
                        ),
                      ),
                      backgroundColor: Color(0xff25242A),
                      icon: Icon(Icons.location_searching),
                    ),
                  )
                ],
              ),
            ),
//                 Card(
//                     semanticContainer: true,
//                     clipBehavior: Clip.antiAliasWithSaveLayer,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 5,
//                     margin: EdgeInsets.only(top: 10),
//                     child: Column(
//                       children: <Widget>[
//                         Text("Amenities",
//                           style: TextStyle(
//                               color: Colors.blueAccent,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold
//                           ),
//                         ),
//                         Divider(),
//                       ],
//                     )
//                 ),
            GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(9,(index)
              {
                return  ChoiceCard(
                    choice: choices[index]
                )
                ;
              }),
            ),
            Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text("Contact Us.",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Divider(),

                    Row(
                      children: <Widget>[
                        Icon(Icons.phone),
                        SizedBox(width: 05),
                        Text("General phone: +254 722 205 894",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone),
                        SizedBox(width: 05),
                        Text("Reservations : +254 733 205 894",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone),
                        SizedBox(width: 05),
                        Text("Group/Event Sales : +254 712 205 894",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        SizedBox(width: 05),
                        Text("General email : sales@freg_leaves_hotel.co.ke",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        SizedBox(width: 05),
                        Text("Reservation email : sales@freg_leaves_hotel.co.ke",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        SizedBox(width: 05),
                        Flexible(
                            child: Text("General manager : sales@freg_leaves_hotel_manager.co.ke",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        SizedBox(width: 05),
                        Text("Sales email : sales@freg_leaves_hotel_sales.co.ke",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.local_post_office),
                        SizedBox(width: 05),
                        Text("P.O Box 74888-00200",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 28),
                        Text("Nyeri",
                          style: TextStyle(
                              color: Colors.black,

                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 28),
                        Text("Kenya",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }

  Widget extras()
  {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Freg leaves hotel").snapshots(),
        builder : (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasError)
            return new Text('${snapshot.error}');
          switch(snapshot.connectionState)
          {
            case ConnectionState.waiting:
            //change to a hovering page waiting for the actual data...
              return  new  Column(
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
              return  SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListView(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        primary: false,
                        shrinkWrap: true,
                        children: buildList(snapshot.data.documents, context,9),
                      )
                    ]
                ),
              );
          }
        }
    );
  }
  // Listview generation...
  List<Widget> buildList(List<DocumentSnapshot> documents, BuildContext context, int num) {
    List<Widget> _list = [];
    for(DocumentSnapshot document in documents)
    {
      if (document.data['ID'] == num )
      {
        _list.add(buildListitems(document,context,num));
      }

    }
    return _list;
  }

  Widget food()
  {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Freg leaves hotel").snapshots(),
        builder : (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasError)
            return new Text('${snapshot.error}');
          switch(snapshot.connectionState)
          {
            case ConnectionState.waiting:
            //change to a hovering page waiting for the actual data...
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
              return  SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top:35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("BREAKFAST",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'SpecialElite-Regular.ttf',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        )
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: buildGrid(snapshot.data.documents,context,0),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top:15),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("LUNCH",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'SpecialElite-Regular.ttf',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],

                        )
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: buildGrid(snapshot.data.documents,context,1),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top:15),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Dinner",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'SpecialElite-Regular.ttf',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],

                        )
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: buildGrid(snapshot.data.documents,context,2),
                    ),
                    SizedBox(height: 15)
                  ],
                ),
              );
          }
        }
    );
  }

  //to get the rooms number
  // for the room number
  int rooming = 0;
  rooms()
  {
    DocumentReference documentReferences = Firestore.instance.collection("accomodation rooms").document(widget.name.toString());
    subscriptions = documentReferences .snapshots().listen((datasnapshot) {
      setState(() {
        rooming = int.parse(datasnapshot.data['number'].toString()) ;
      });
    });

  }


  Widget buildListitems(DocumentSnapshot document, BuildContext context,int num)
  {

    return GestureDetector
      (

      onTap: (){
        if(num ==8)
        {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>
              check(
                  price: document.data['price'],
                  name: document.data['name'],
                  detail: document.data['detail'],
                  url: document.data['url'],
                  hotel:widget.name,
                roomz:rooming.toString()
              )
          ));
        }
        else
        {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>
              product(
                price: document.data['price'],
                name: document.data['name'],
                details: document.data['detail'],
                url: document.data['url'],
                hotel: widget.name,
              )
          ));
        }
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        margin: EdgeInsets.only(top:05 , bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              child: FadeInImage
                (
                placeholder: new AssetImage("albums/bed.jpg"),
                image: NetworkImage(document.data['url']),
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(document.data['name'],
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
            Padding(
              padding: EdgeInsets.only(left: 05,right: 05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.attach_money),
                      Text(document.data['price'],
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),)
                    ],
                  ),
                  Text(document.data['rating'],
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                    ),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drink()
  {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Freg leaves hotel").snapshots(),
        builder : (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasError)
            return new Text('${snapshot.error}');
          switch(snapshot.connectionState)
          {
            case ConnectionState.waiting:
            //change to a hovering page waiting for the actual data...
              return  Column(
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
              return  SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top:15),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("TEA",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'SpecialElite-Regular.ttf',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],

                        )
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: buildGrid(snapshot.data.documents,context,3),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top:15),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("SOFT DRINK",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'SpecialElite-Regular.ttf',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],

                        )
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: buildGrid(snapshot.data.documents,context,7),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top:15),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("BEER",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'SpecialElite-Regular.ttf',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],

                        )
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: buildGrid(snapshot.data.documents,context,5),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top:15),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("WINE",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'SpecialElite-Regular.ttf',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],

                        )
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: buildGrid(snapshot.data.documents,context,4),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top:15),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("WHISKEY",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'SpecialElite-Regular.ttf',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],

                        )
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: buildGrid(snapshot.data.documents,context,6),
                    ),
                    SizedBox(height: 15)
                  ],
                ),
              );
          }
        }
    );
  }

  Widget accomodation()
  {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Freg leaves hotel").snapshots(),
        builder : (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasError)
            return new Text('${snapshot.error}');
          switch(snapshot.connectionState)
          {
            case ConnectionState.waiting:
            //change to a hovering page waiting for the actual data...
              return  Column(
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
              return  SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListView(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        primary: false,
                        shrinkWrap: true,
                        children: buildList(snapshot.data.documents, context,8),
                      )
                    ]
                ),
              );
          }
        }
    );
  }


  //Grid view ...
  List<Widget> buildGrid(List<DocumentSnapshot> documents,BuildContext context,int num)
  {
    List<Widget> _gridview = [];

    for(DocumentSnapshot document in documents){
      if (document.data['ID'] == num){
        _gridview.add(buildGridItem(document,context,num));
      }

    }
    return _gridview;
  }
  //oN TAP FOR GRIDVIEW is here.
  Widget buildGridItem(DocumentSnapshot document,BuildContext context, int num)
  {

    return new GestureDetector(
        child: new Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2.0,
          margin: const EdgeInsets.only(left: 2, right: 2, bottom: 2,top: 2),
          child: new Stack(
            children: <Widget>[
              new Hero(
                tag: document.data['url'],
                child: new FadeInImage(
                  placeholder: new AssetImage("albums/bird.jpg"),
                  image: new NetworkImage(document.data['url']),
                  fit: BoxFit.fill,
                  height: screenHeight(context,dividedBy: 3.5),
                ),
              ),
              new Align(
                child: new Container(
                  padding: const EdgeInsets.all(3.0),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                          document.data['name'],
                          //  "Bird meat",
                          style:new TextStyle(color: Colors.white)
                      ),
                      new Text("\$" +'${
                          document.data['price']
                      // "200"
                      }',
                          style: new TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                          )
                      ),
                    ],
                  ),
                  color: Colors.black.withOpacity(0.7),
                  width: double.infinity,
                ),
                alignment: Alignment.bottomCenter,
              )
            ],
          ),
        ),
        onTap: ()
        {
          Navigator.push(context,new MaterialPageRoute(builder: (context)=>
              product(
                  url: document.data['url'],
                  details: document.data['detail'],
                  name: document.data['name'],
                  price: document.data['price'],
                  hotel: widget.name.toString()
              )
          )
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.dehaze, size: 30,color: Colors.white),
          Icon(Icons.local_dining, size: 30,color: Colors.white),
          Icon(Icons.local_bar, size: 30,color: Colors.white),
          Icon(Icons.hotel, size: 30,color: Colors.white),
          Icon(Icons.accessibility, size: 30,color: Colors.white)
        ],
        color: Color(0xff25242A),
        backgroundColor: Color(0xfff7f7f7),
        animationCurve: Curves.easeOutCubic,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index)
        {
          setState(() {
            _page = index;
          });
        },
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:Container(
            color: Color(0xfff7f7f7),
//        child: Center(
//          child: Text(_page.toString(),textScaleFactor: 10.0),
//        ),
            child: Column(
              children: <Widget>[
                states(),
              ],
            ),
          )
      ),
    );
  }
}

class selectedPhoto extends StatelessWidget
{
  final int numberofDots;
  final int photoIndex;

  selectedPhoto({this.numberofDots,this.photoIndex});

  Widget _inactivePhoto(){
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4.0)
          ),
        ),
      ),
    );
  }

  Widget _activePhoto(){
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(5.0)
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDots(){
    List<Widget> dots = [];
    for(int i=0;i < numberofDots; ++i){
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(),
      ),
    );
  }

}

class Choice {
  const Choice ({this.title,this.icon});
  final String title;
  final IconData icon;

}

const List<Choice> choices = const <Choice>
[
  const Choice(title: 'Free wifi', icon: Icons.wifi),
  const Choice(title: 'Spa', icon: Icons.spa),
  const Choice(title: 'Beach', icon: Icons.beach_access),
  const Choice(title: 'Restaurant', icon: Icons.local_cafe),
  const Choice(title: 'Pool', icon: Icons.pool),
  const Choice(title: 'Bar', icon: Icons.local_bar),
  const Choice(title: 'Gym', icon: Icons.fitness_center),
  const Choice(title: 'A/C', icon: Icons.ac_unit),
  const Choice(title: 'Parking', icon: Icons.local_parking),
];

class ChoiceCard extends StatelessWidget
{
  const ChoiceCard({
    Key key,this.choice
  }) :super (key: key);
  final Choice choice;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(choice.icon,size: 30,color: Colors.blueAccent,),
            Text(choice.title)
          ],
        ),
      ),
    );
  }


}


//Listview generation...
