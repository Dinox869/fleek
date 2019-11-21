import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class mapping extends StatefulWidget
{
  @override
  mappings  createState()=> mappings();

}

class mappings extends State<mapping>
{
  //new variables
  Map<MarkerId, Marker> markers = <MarkerId,Marker>{};

  bool mapToggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;
  var currentLocation;
  var clients = [];
  var currentCLient;
  var currentBearing;
//old GMC
  Completer<GoogleMapController> _controller = Completer();
  //addation code
  static const LatLng _center = const LatLng(-0.397779, 36.957493);

  Geolocator geolocator = Geolocator();
  final Set<Polyline> _polylines = {};

  LatLng _lastMapPosition = _center;
//Wick
  List<LatLng> latlng = [
    LatLng(-0.397779,36.9574939),
    LatLng(-0.397479,36.956763),
    LatLng(-0.399732,36.954854),
    LatLng(-0.399882,36.954339),
    LatLng(-0.399496,36.951742),
    LatLng(-0.399968,36.951098),
    LatLng(-0.400955,36.950519),
    LatLng(-0.401813,36.945648),
    LatLng(-0.402328,36.945369),
    LatLng(-0.403937,36.945283),
    LatLng(-0.404474,36.946335),
    LatLng(-0.405439,36.947343),
    LatLng(-0.405911,36.949124),
    LatLng(-0.406341,36.949189),
    LatLng(-0.409087,36.945391),
    LatLng(-0.409581,36.945498),
    LatLng(-0.409538,36.946743),
    LatLng(-0.412027,36.950004),
    LatLng(-0.415138,36.959767),
  ];
  //Corner
  List<LatLng> latlngs = [
    LatLng(-0.397779,36.9574939),
    LatLng(-0.397479,36.956763),
    LatLng(-0.399732,36.954854),
    LatLng(-0.399882,36.954339),
    LatLng(-0.399496,36.951742),
    LatLng(-0.399968,36.951098),
    LatLng(-0.400955,36.950519),
    LatLng(-0.401813,36.945648),
    LatLng(-0.402328,36.945369),
    LatLng(-0.403937,36.945283),
    LatLng(-0.404474,36.946335),
    LatLng(-0.405439,36.947343),
    LatLng(-0.405911,36.949124),
    LatLng(-0.406341,36.949189),
    LatLng(-0.409087,36.945391),
    LatLng(-0.409581,36.945498),
    LatLng(-0.409538,36.946743),
    LatLng(-0.412027,36.950004),
    LatLng(-0.412284,36.949189),
    LatLng(-0.413014,36.946743),
    LatLng(-0.414709,36.944039),
    LatLng(-0.415288,36.943738),
    LatLng(-0.418528,36.945412),
    LatLng(-0.418807,36.946163),
    LatLng(-0.418507,36.948030),
    LatLng(-0.419065,36.949039),
    LatLng(-0.422154,36.948159),
    LatLng(-0.422712,36.950240),
    LatLng(-0.428162,36.955647),
  ];
  //freg
  List<LatLng> latlngz = [
    LatLng(-0.397779,36.9574939),
    LatLng(-0.397479,36.956763),
    LatLng(-0.399732,36.954854),
    LatLng(-0.399882,36.954339),
    LatLng(-0.399496,36.951742),
    LatLng(-0.399968,36.951098),
    LatLng(-0.400955,36.950519),
    LatLng(-0.401813,36.945648),
    LatLng(-0.402328,36.945369),
    LatLng(-0.403937,36.945283),
    LatLng(-0.404474,36.946335),
    LatLng(-0.405439,36.947343),
    LatLng(-0.405911,36.949124),
    LatLng(-0.406341,36.949189),
    LatLng(-0.409087,36.945391),
    LatLng(-0.409581,36.945498),
    LatLng(-0.409538,36.946743),
    LatLng(-0.412027,36.950004),
    LatLng(-0.412284,36.949189),
    LatLng(-0.413014,36.946743),
    LatLng(-0.414709,36.944039),
    LatLng(-0.415288,36.943738),
    LatLng(-0.418528,36.945412),
    LatLng(-0.418807,36.946163),
    LatLng(-0.418507,36.948030),
    LatLng(-0.419065,36.949039),
    LatLng(-0.422154,36.948159),
  ];
//function
  void _onAddMarkerButtonPressed() { //wick hotel
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        points: latlng,
        width: 2,
        color: Colors.black,
      ));
    });
  }
  void _onAddMarkerButtonPressedz() {  //freg hotel
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        points: latlngz,
        width: 2,
        color: Colors.black,
      ));
    });
  }
  void _onAddMarkerButtonPresseds() { //corner hotel
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        points: latlngs,
        width: 2,
        color: Colors.black,
      ));
    });
  }
  //current location
  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future<void> _gotoLocation(double lat,double long)async
  {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat,long),zoom: 13,tilt: 50.0)));
      if( long == 36.948159)
      {
        _onAddMarkerButtonPressedz();
      }
      else if( long == 36.955647 )
      {
        _onAddMarkerButtonPresseds();
      }
      else if(long == 36.959767)
      {
        _onAddMarkerButtonPressed();
      }
  }
  //new GMC
  GoogleMapController mapController;

  @override
  void iniState(){
    populateClients();
    super.initState();
//gets the devices location before loading the page..
//    Geolocator().getCurrentPosition().then((currloc){
//      setState(() {
//        currentLocation = currloc;
//        mapToggle = true;
//      });
//    });

  }

  @override
  void dispose()
  {
    super.dispose();
  }
  //dialog..
  _showTime(){
    return showDialog (
        context: context,
        barrierDismissible: true,
        child: AlertDialog(
          title: new Text("Guide",style: TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.bold,fontSize: 18.0),
          ),
          content: Text("Check for hotels within your region..."),
          actions: <Widget>[
            new FlatButton(
                onPressed: (){
                  populateClients();
                },
                child: Text("Cancel",style: TextStyle(
                    color: Colors.red
                ),
                )
            )
          ],
        )
    );
  }

// used to create the marker.
  populateClients()
  {
    clients = [];
    Firestore.instance.collection('hotel entry').getDocuments().then((docs)
    {
      for(int i =0; i<docs.documents.length; i++)
      {
        // clients.add(docs.documents[i].data);
        initMarker(docs.documents[i].data,docs.documents[i].documentID);
      }
    });
    return clients;
  }
//adding markers with a fuction or method way thats easier than before...Error recognizing
  initMarker(client,markerRef)
  {
    var markerIdVal = markerRef;
    final MarkerId markerId = MarkerId(markerIdVal);
    final  Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
            client['location'].latitude,
            client['location'].longitude
        ),
        infoWindow: InfoWindow(
          title: client['name'],
          // snippet: '*'
        )
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void onMapCreate(controller)
  {
    setState(() {
      mapController = controller;
    });
  }

  double zoomVal = 5.0;
  Widget _buildGoogleMap(BuildContext context)
  {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
          mapType: MapType.normal,
          polylines: _polylines,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
              target: LatLng(-0.416665,36.94759 ),
              zoom: 9
          ),
          onMapCreated:(GoogleMapController controller){
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values),
    ),
    );
  }

  Widget _zoomminusfunction()
  {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(Icons.indeterminate_check_box,
            color: Color(0xff6200ee),
          ),
          onPressed: ()
          {

            zoomVal--;
            _minus(zoomVal);
          }
      ),
    );
  }

  Widget _zoomplusfunction()
  {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(Icons.add_box,
            color: Color(0xff6200ee),
          ),
          onPressed: ()
          {
            zoomVal++;
            _plus(zoomVal);
//            _onAddMarkerButtonPressed();
          }
      ),
    );
  }

  Future<void> _minus(double zoomVal) async
  {
    final GoogleMapController controller =  await _controller.future;
    controller.animateCamera((CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(-0.416665,36.94759), zoom: zoomVal))));

  }

  Future<void> _plus(double zoomVal) async
  {
    final GoogleMapController controller =  await _controller.future;
    controller.animateCamera((CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(-0.416665,36.94759), zoom: zoomVal))));

  }

  Widget _buildContainer(){
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("hotel entry").snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot>snapshot) {
          if (snapshot.hasError)
          {
            print("==========failed=====");
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      height: 150,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: buildList(snapshot.data.documents, context)
                      )
                  )
              );
          }
        }
    );
  }

  List<Widget> buildList(List<DocumentSnapshot> documents, BuildContext context) {
    List<Widget> _list = [];
    for(DocumentSnapshot document in documents)
    {
      _list.add(buildListitems(document,context));
    }
    return _list;
  }
  Widget buildListitems(DocumentSnapshot document, BuildContext context)
  {
    return
      _boxes(
          document.data['url'],
          document.data['location'].latitude,
          document.data['location'].longitude,
          document.data['name'],
          document.data['distance']
      );
  }


//better than the new one in design...
  Widget _boxes(String _image, double lat,double long,String restaurantName,String distance)
  {
    return GestureDetector(
      onTap: (){
        if(clients.length == 0){ populateClients();
        _gotoLocation(lat, long);
        }
        else
        {
          _gotoLocation(lat,long);
        }
        //  populateClients();
      },
      child: Container(
        child: new FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14,
            borderRadius: BorderRadius.circular(24),
            shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(_image),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: myDetailsContainer1(restaurantName,distance),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName,String distance)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Container(
            child: Text(restaurantName,
              style: TextStyle(
                  color: Color(0xff6200ee),
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Text(
                    "4.0",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    )
                ),
              ),
              Container(
                child:SmoothStarRating(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: 4,
                  size: 20,
                  color: Colors.cyan[800],
                  spacing: 0.0,
                ) ,
              ),
              Container(
                  child: Text(
                    "(946)",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          child: Text(
            distance,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }

//    old widget without firebase...
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: ()
            {
              //go back to the result page...
              Navigator.pop(context);
            }
        ),
        title: Text("Google Map Page"),
        backgroundColor: Color(0xff25242A),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: ()
              {
                //search bar pops up..
              }
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _zoomminusfunction(),
              _zoomplusfunction(),
            ],
          ),
          _buildContainer(),
        ],
      ),
    );
  }
}