import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_read_more_text/flutter_read_more_text.dart';
import 'package:fleek/screen_reducer.dart';

class receipts extends StatefulWidget
{
  @override
  Receipts createState() => Receipts();
}

class Receipts extends State<receipts>
{
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("receipts_for_Mpesa").snapshots(),
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
}

// Receipt Listview generation...
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
//Item list generation...
List<Widget> buildLists(DocumentSnapshot document, BuildContext context, int num) {
  List<Widget> _list = [];
  List<String> price = List.from(document['price']);
  List<String> Qty = List.from(document['Qty']);
  List<String> Item = List.from(document['Item']);

  for(String document in Item)
  {
    for(String qty in Qty)
    {
      for(String Price in price)
      {
        _list.add(buildItem(document,qty,Price,context,num));
      }
    }
  }
  return _list;
}
//Item generation..
Widget buildItem(String Item,String Qty,String Price,BuildContext context,int num)
{
  return ListTile(
      leading: Text(Item,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold
        ),
      ),
      trailing: Text(Qty +" * "+Price,
        style: TextStyle(
            fontSize: 10,
            color: Colors.grey
        ),
      )
  );
}

//Listview generation...
Widget buildListitems(DocumentSnapshot document, BuildContext context,int num)
{
  return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: EdgeInsets.only(top:05 , bottom: 10),
      child:Column(
        children: <Widget>[
          Text("Freg Hotel",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Transaction.",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 07
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Mpesa",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13
                        ),
                      )
                    ],
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Receipt number.",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 07
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("NHE43J2DK",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          Divider(),
          ListView(
            padding: EdgeInsets.only(left: 15, right: 15),
            primary: false,
            shrinkWrap: true,
            children: buildLists(document, context,8),
          )
        ],
      )
  );
}