import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mpesa/mpesa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleek/screen_reducer.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:fleek/display.dart';
import 'package:fleek/receipt.dart';

class cart extends StatefulWidget
{

  @override
  carts createState() => carts();
}

class carts extends State<cart>
{
  int period = 0;
  String checkoutIds = '';
  int amount = 174379;
  String Amount = '';
  String Serial = '';
  List< String> Item = [];
  List<String> Qty = [];
  List<String> price = [];

  int number = 0;
  StreamSubscription<QuerySnapshot> subsription;
  TextEditingController _phonenumber = TextEditingController();
  diff2(DocumentSnapshot document)

  {
    var check_in = document.data['check in'];
    var check_out = document.data['check out'];
    final checkout = DateTime(int.parse(check_out.toString().substring(0,4)),
        int.parse(check_out.toString().substring(6,7)),int.parse(check_out.toString().substring(8,10)));
    final checkin = DateTime(int.parse(check_in.toString().substring(0,4)),
        int.parse(check_in.toString().substring(6,7)),int.parse(check_in.toString().substring(8,10)));
    final difference = checkout.difference(checkin).inDays;
    int periods = int.parse(difference.toString());
    if(periods<0)
    {
      periods = -periods ;
    }
    print(document.data['check out']);
    print(document.data['check in']);

    print(periods);
    print(check_out);
    print(check_in);
    period = period + periods;

  }
  int Sum = 0;
  //for the dialog for phonenumber
  Future<String> someFunction(BuildContext context) async {
    await voo(context);
    return _phonenumber.toString();
  }
  int confirm = 0;
  voo(BuildContext buildContext){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Input phone number...'),
            content:TextField(
              controller: _phonenumber,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "phonenumber"
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Continue..',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 17
                  ),
                ),
                onPressed: () {
                  if(_phonenumber.toString().length != 0  )
                  {
                    print("254"+_phonenumber.text.toString().substring(1,10));
                    number = int.parse("254"+_phonenumber.text.toString().substring(1,10));
                    if(_phonenumber.text.toString().length == 10  )
                    {
                      print("done here");
                      Navigator.pop(context);
                      //mpesa
                      mpesa.lipaNaMpesa(
                          phoneNumber: number.toString(),
                          amount: double.parse(Sum.toString()),
                          transactionDescription: "Nest",
                          businessShortCode: amount.toString(),
                          callbackUrl: "https://us-central1-arma-17c62.cloudfunctions.net/custommpesa"
                      ).then((result)
                      {
                        print(result['CheckoutRequestID']);
                        checkoutIds = result['CheckoutRequestID'].toString();
                        Timer(Duration(seconds: 20),()
                        {
                          getsuccess(checkoutIds);
                        });
                      }).catchError((error){
                        print(error.toString());
                      });
                      //Fetch the results from firebase for mpesa transaction.
                      checkoutIds = '';

                    }
                  }
                  else
                  {
                    Navigator.pop(context);
                  }
                  _phonenumber.clear();
                },
              )
            ],
          );
        });
  }



  TextEditingController _Controller = TextEditingController();
  //for listview
  List<Widget> buildList(List<DocumentSnapshot> documents, BuildContext context) {
    List<Widget> _list = [];
    Sum = 0 ;
    period = 0;
    for(DocumentSnapshot document in documents)
    {

      if(document.data['ID'].toString() == "2")
      {
        int totals = int.parse(document.data['price'])*(int.parse(document.data['quantity']));
        Sum = Sum + totals;
        _list.add(buildListitems(document,context));
      }
      else if (document.data['ID'].toString() == "1")
      {
        diff2(document);
        int total = period * int.parse(document.data['price']);
//          int total =  (
//             // int.parse(document.data['check out'].toString().substring(9,10))-int.parse(document.data['check in'].toString().substring(9,10))
//              //DateTime( int.parse(document.data['check out'].toString().substring(1,5), int.pars))
//          )
//              *int.parse(document.data['price']);
        Sum = Sum + total;
        _list.add(buildListitem_checkin(document,context,total));
      }
    }
    return _list;
  }
  //for listview for Quantity
  Widget buildListitems(DocumentSnapshot document, BuildContext context)
  {
    return GestureDetector
      (
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                buildz(
                    context,
                    document.data['name'],
                    document.data['url'],
                    document.data['price'],
                    document.data['quantity'],
                    document.documentID
                ),
          );
        },
        child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            margin: EdgeInsets.only(top:03, bottom: 03 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 9, left: 9, right: 40,bottom: 9),
                      child:CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(document.data['url']),
                      ) ,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(document.data['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.black
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Price: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(document.data['price'])
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Quantity: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(document.data['quantity'])
                          ],
                        ),
                        Divider(),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Text("TOTAL:   ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "\$"+(
                                  int.parse(document.data['price'])
                                      *
                                      int.parse(document.data['quantity'])
                              )
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.cancel,
                            color: Colors.red,
                          ),
                          //color: Colors.red,
                          onPressed: ()
                          {
                            Firestore.instance.collection('cache_data').document(document.documentID).delete();
                          }
                      )
                    ],
                  ) ,
                ),
              ],
            )
        )
    );
  }

  //for listview for check in
  Widget buildListitem_checkin(DocumentSnapshot document, BuildContext context, int total)
  {
    return GestureDetector
      (
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                build_checkin(
                    context,
                    document.data['name'],
                    document.data['url'],
                    document.data['price'],
                    document.data['check in'],
                    document.data['check out'],
                    document.documentID
                ),
          );
        },
        child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            margin: EdgeInsets.only(top:03, bottom: 03 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 9,bottom: 9,right: 40,left: 9),
                      child:CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(document.data['url']),
                      ) ,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(document.data['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.black
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Price: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(document.data['price'])
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Check in : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(document.data['check in'])
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Check out: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(document.data['check out'])
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Text("TOTAL:   ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "\$"+total.toString(),
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.cancel,
                            color: Colors.red,
                          ),
                          //color: Colors.red,
                          onPressed: ()
                          {
                            Firestore.instance.collection('cache_data').document(document.documentID).delete();
                            Sum =  Sum -  (
                                int.parse(document.data['check out'].toString().substring(9,10))-int.parse(document.data['check in'].toString().substring(9,10))
                            )
                                *int.parse(document.data['price']);
                          }
                      )
                    ],
                  ) ,
                ),
              ],
            )
        )
    );
  }

  //for show dialog for check in
  Widget build_checkin(BuildContext context,String name,String imageurl,String price,String checkin ,String checkout, String documentID) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context,name,imageurl,price,checkin,checkout,documentID),
    );
  }

  //for show dialog for check in
  dialogContent(BuildContext context, String name,String imageurl,String price,String checkin,String checkout,String documentID ) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 110,
            bottom: 10,
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(top: 66),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Text("Price: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),
                  )  ,
                  Text( "\$"+price,
                    style: TextStyle(
                        fontSize: 20
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Check in: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(checkin,
                    style: TextStyle(
                        fontSize: 20
                    ),)
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Check out: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(checkout,
                    style: TextStyle(
                        fontSize: 20
                    ),)
                ],
              ),
              SizedBox(height: 14.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: ()  {
                    if(_Controller.text!=null)
                    {
                      // await _updateData(documentID,price,price);
                      Navigator.of(context).pop();
                      _Controller.dispose();// To close the dialog
                    }
                    else
                    {
                      print("Failed..");
                    }
                  },
                  child: Text("done"),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 60,
          right: 60,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(imageurl),
            radius: 90,
          ),
        ),
      ],
    );
  }

  //for show dialog
  Widget buildz(BuildContext context,String name,String imageurl,String price,String quantity,String documentID) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContentz(context,name,imageurl,price,quantity,documentID),
    );
  }

  //to update quantity number...
  _updateData(String documentID,String price,String quantity)async
  {
    await Firestore.instance.collection('cache_data').document(documentID).updateData({'quantity':_Controller.text});
    // Sum = Sum - (int.parse(price)*int.parse(quantity));
    //Sum = Sum + (int.parse(price)*int.parse(_Controller.text));
  }

  //for show dialog for quantity
  dialogContentz(BuildContext context, String name,String imageurl,String price,String quantity,String documentID ) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 110,
            bottom: 10,
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(top: 66),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Text("Price: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),
                  )  ,
                  Text( "\$"+price)
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Quantity: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: TextField(
                      controller: _Controller,
                      decoration: InputDecoration(
                          hintText: quantity
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 14.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () async {
                    if(_Controller.text!=null)
                    {
                      await _updateData(documentID,price,quantity);
                      Navigator.of(context).pop();
                      _Controller.dispose();// To close the dialog
                    }
                    else
                    {
                      print("Failed..");
                    }
                  },
                  child: Text("done"),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 60,
          right: 60,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(imageurl),
            radius: 90,
          ),
        ),
      ],
    );
  }

  var list = "three";

  //mpesa.dart
  Mpesa mpesa = Mpesa(
      clientKey: "tqynTw1B2kOtXJW1EpRsl1BNHAXXkCel",
      clientSecret: "tT7R9bNXDSPa7Xss",
      environment: "sandbox",
      initiatorPassword: "VeBVN1Fl987cBSW0+Mj3HAIJ1hacsTpum/W4Do1NpKcGro7TsxiMgP1FNXfwkT7AS4Kx0VLxYC6OrhMc4EXDrX/EqzSq41Puom7CRF2DqPOgJanOwnUioOA9hdaZCPKPOc8WYoJ/zEgM2mHJDyUgFwuj69gk/UNdFmc48R0yvIwbGA5E4fbe9KzeEr2mAWdOsBUFLE7sLmkHBVPja0Q1Y/ltuLICmbPqG2/Mdgc0t3ygtwbwmmmwrqBaW8g17wJzfZRedtEbyLAHPJ+SEkBAP3T1I3N9wWlloQbweBM86lvIBUjzqne1kjwlQEYixQuPiix0jXbPF+JZGovmAo45EQ==" ,
      passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919" );

  //To send array to firebase...
  void Con()async
  {
    await Firestore.instance.collection('cache_data').where("username", isEqualTo: 'Dennis').getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        //set data in array List<Strings>
        print(doc.data['name']+" "+ doc.data['quantity']+" "+ doc.data['price']);
//             Item = doc.data['name'];
//              Qty = doc.data['quantity'];
//             price = doc.data['price'];
        setState(() {
          Item.add(doc.data['name'].toString());
          Qty.add(doc.data['quantity'].toString());
          price.add(doc.data['price'].toString());
          print(Item);
          print(Qty);
          print(price);
        });
        //deletes all the records from the cache data.
        doc.reference.delete();
      }});
    print("==========start==========");
    print(Item);
    print(Qty);
    print(price);
    print("=======end=============");
    //Add data to
    final DocumentReference documentReference = Firestore.instance.collection("receipts_for_Mpesa").document();
    Map<String, dynamic> data = <String, dynamic>
    {
      'transaction': 'Mpesa',
      'Hotelname': 'find it',
      'Amount': Amount,
      'Serial no.': Serial,
      'username': number.toString(),
      'Item': Item,
      'Qty': Qty,
      'price':price
    };
    documentReference.setData(data).whenComplete(()async{
      await print ("Document Added");
      Item.clear();
      Qty.clear();
      price.clear();
    }).catchError((e)
    {
      print(e);
    });
  }
  //Success capture from firebase
  void  getsuccess( String checkout)async
  {
    await Firestore.instance.collection('mpesa').
    where('checkoutId', isEqualTo: checkout).snapshots().listen((datas){
      if( datas.documents.length != 0  )
      {
        print(datas);
        showDialog(
            context: context,
            builder: (BuildContext context){
              return RichAlertDialog(
                  alertTitle: richTitle("Transaction Successful"),
                  alertSubtitle: richSubtitle("Your mpesa transaction was succesful") ,
                  alertType: RichAlertType.SUCCESS
              );
            }
        );
        for (DocumentSnapshot doc in datas.documents) {
          Amount = doc.data['amount'].toString();
          Serial = doc.data['MpesaReceiptNumber'].toString();
        }
        //delete all records from the database after payment.
        Con();
//          Navigator.push(context,MaterialPageRoute(builder: (context)=>
//          receipts()
//          ));
      }
      else
      {

        showDialog(
            context: context,
            builder: (BuildContext context){
              return RichAlertDialog(
                  alertTitle: richTitle("Transaction Failed"),
                  alertSubtitle: richSubtitle("Mpesa transaction wasn't completed") ,
                  alertType: RichAlertType.ERROR
              );
            }
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("cache_data").where("username", isEqualTo: 'Dennis').snapshots(),
        builder : (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasError)
            return new Text('${snapshot.error}');
          switch(snapshot.connectionState)
          {
            case ConnectionState.waiting:
            //change to a hovering page waiting for the actual data...
              return  new Center(
                  child: new CircularProgressIndicator()
              );
            default:
              return Scaffold(
                  appBar: AppBar(

                    title: Text(
                      "Cart",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Color(0xff25242A),
                    actions: <Widget>[
                      new Padding(padding: const EdgeInsets.all(10.0),
                        child: new Container(
                            height: 150.0,
                            width: 30.0,
                            child: new GestureDetector(
                              onTap: () {
//                              Navigator.of(context).push(
//                                  new MaterialPageRoute(
//                                      builder:(BuildContext context) =>
//                                      new CartItemsScreen()
//                                  )
//                              );
                              },
                              child: new Stack(
                                children: <Widget>[
                                  new IconButton(icon: new Icon(Icons.shopping_cart,
                                    color: Colors.white,),
                                    onPressed: null,
                                  ),
                                  snapshot.data.documents.length ==0 ? new Container() :
                                  new Positioned(

                                      child: new Stack(
                                        children: <Widget>[
                                          new Icon(
                                              Icons.brightness_1,
                                              size: 20.0, color: Colors.deepOrangeAccent),
                                          new Positioned(
                                              top: 3.0,
                                              right: 4.0,
                                              child: new Center(
                                                child: new Text(
                                                  snapshot.data.documents.length.toString(),
                                                  style: new TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              )),
                                        ],
                                      )),
                                ],
                              ),
                            )
                        )
                        ,)
                    ],
                  ),
                  body: Builder(
                    builder: (context)=>SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ListView(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            primary: false,
                            shrinkWrap: true,
                            children: buildList(snapshot.data.documents, context),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 15),
                              Text(
                                "TOTAL:  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                              Text(" \$"+Sum.toString(),
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ButtonTheme(
                                height: screenHeight(context,dividedBy: 13),
                                minWidth: 150,
                                child: RaisedButton.icon(
                                    onPressed: ()
                                    {
                                      if(Sum != 0)
                                      {
                                        final snackBar = SnackBar(
                                          duration: const Duration(seconds: 15  ),
                                          content: Text('PLEASE WAIT...!',
                                            style: TextStyle(
                                                fontSize: 15
                                            ),
                                          ),
                                        );
                                        Scaffold.of(context).showSnackBar(snackBar);
                                        // action of payments.
                                        someFunction(context);
                                      }
                                      else
                                      {
                                        final snackBar = SnackBar(
                                          duration: const Duration(seconds: 05  ),
                                          content: Text('NO ITEM FOUND...!',
                                            style: TextStyle(
                                                fontSize: 15
                                            ),
                                          ),
                                        );
                                        Scaffold.of(context).showSnackBar(snackBar);
                                      }
                                    },
                                    icon: Icon(Icons.payment),
                                    color: Colors.green,
                                    label: Text("Pay",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                          SizedBox(height:20)
                        ],
                      ),
                    ),
                  )
              );
          }
        }
    );
  }
}