import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleek/add_cart.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:mpesa/mpesa.dart';


class product extends StatefulWidget{

  final url;
  final name;
  final details;
  final price;
  final hotel;

  product({Key key,
    @required
    this.url, this.name, this.details, this.price,this.hotel
  }):
        super (key : key);
  @override
  products createState()=> products();
}

class products extends State<product> {
  String checkoutIds = '';
  int _itemCount = 0;
  int total = 0;
  int period = 0;
  int amount = 174379;
  int number = 0;

  Mpesa mpesa = Mpesa(
      clientKey: "tqynTw1B2kOtXJW1EpRsl1BNHAXXkCel",
      clientSecret: "tT7R9bNXDSPa7Xss",
      environment: "sandbox",
      initiatorPassword: "VeBVN1Fl987cBSW0+Mj3HAIJ1hacsTpum/W4Do1NpKcGro7TsxiMgP1FNXfwkT7AS4Kx0VLxYC6OrhMc4EXDrX/EqzSq41Puom7CRF2DqPOgJanOwnUioOA9hdaZCPKPOc8WYoJ/zEgM2mHJDyUgFwuj69gk/UNdFmc48R0yvIwbGA5E4fbe9KzeEr2mAWdOsBUFLE7sLmkHBVPja0Q1Y/ltuLICmbPqG2/Mdgc0t3ygtwbwmmmwrqBaW8g17wJzfZRedtEbyLAHPJ+SEkBAP3T1I3N9wWlloQbweBM86lvIBUjzqne1kjwlQEYixQuPiix0jXbPF+JZGovmAo45EQ==" ,
      passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919" );
  //dialog for phone number and username...
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _phonenumber = TextEditingController();

  //for show dialog
//  Widget buildz(BuildContext context) {
//    return Dialog(
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(16),
//      ),
//      elevation: 0.0,
//    //  backgroundColor: Colors.transparent,
//      child: dialogContent(context),
//    );
//  }

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
    phoneNumber:  number.toString(),
    amount: double.parse((_itemCount*int.parse(widget.price)).toString()),
    transactionDescription: "Nest",
    businessShortCode: amount.toString(),
    callbackUrl: "https://us-central1-arma-17c62.cloudfunctions.net/custommpesa"
    ).then((result)
    {
    print(result['CheckoutRequestID']);
    checkoutIds = result['CheckoutRequestID'].toString();
    Timer(Duration(seconds: 20), ()
    {
    getsuccess(checkoutIds);
    });
    final DocumentReference documentReference = Firestore.instance.collection("receipts_for_Mpesa").document();
    Map<String, dynamic> data = <String, dynamic>
    {
    'transaction': 'Mpesa',
    'Hotelname': widget.hotel.toString(),
    'Amount': (_itemCount*int.parse(widget.price)).toString(),
    'Serial no.': result['CheckoutRequestID'],
    'username': number.toString(),
    'Item': widget.name.toString(),
    'Qty': _itemCount.toString(),
    'price':widget.price.toString()
    };
    documentReference.setData(data).whenComplete(()async{
    await print ("Document Added");
    }).catchError((e)
    {
    print(e);
    });

    }).catchError((error){
    print(error.toString());
    });
    checkoutIds = '';
    succes = 0;
    confirm = 0;

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
  //for show dialog for details
//  dialogContent(BuildContext context ) {
//     return  Stack(
//      children: <Widget>[
//        Container(
//          padding: EdgeInsets.only(
//            top: 110,
//            bottom: 10,
//            left: 16,
//            right: 16,
//          ),
//          margin: EdgeInsets.only(top: 66),
//          decoration: new BoxDecoration(
//            color: Colors.white,
//            shape: BoxShape.rectangle,
//            borderRadius: BorderRadius.circular(16),
//            boxShadow: [
//              BoxShadow(
//                color: Colors.black26,
//                blurRadius: 10.0,
//                offset: const Offset(0.0, 10.0),
//              ),
//            ],
//          ),
//          child: Column(
//            mainAxisSize: MainAxisSize.min, // To make the card compact
//            children: <Widget>[
//              Text(
//                "Input username and phonenumber..",
//                style: TextStyle(
//                  fontSize: 24.0,
//                  fontWeight: FontWeight.w700,
//                ),
//              ),
//              SizedBox(height: 16.0),
//              Row(
//                children: <Widget>[
//                  Text("Username: ",
//                    style: TextStyle(
//                        fontSize: 20,
//                        fontWeight: FontWeight.w600
//                    ),
//                  )  ,
//                  TextField(
//                    controller: _textFieldController,
//                    decoration: InputDecoration(
//                        hintText: "Username"
//                    ),
//                  ),
//                ],
//              ),
//              Row(
//                children: <Widget>[
//                  Text("Phonenumber: ",
//                    style: TextStyle(
//                        fontSize: 20,
//                        fontWeight: FontWeight.w600
//                    ),
//                  ),
//                  SizedBox(
//                    width: 30,
//                    child: TextField(
//                      controller: _phonenumber,
//                      keyboardType: TextInputType.number,
//                      decoration: InputDecoration(
//                          hintText: "Phonenumber"
//                      ),
//                    ),
//                  )
//                ],
//              ),
//              SizedBox(height: 14.0),
//              Align(
//                alignment: Alignment.bottomRight,
//                child: FlatButton(
//                  onPressed: (){
//                    if(_phonenumber.toString().length == 0 )
//                    {
//
//                    }else if(_textFieldController.toString().length == 0 )
//                    {
//
//                    }
//                    else
//                      {
//                        final snackBar = SnackBar(
//                          duration: const Duration(seconds: 15  ),
//                          content: Text('PLEASE WAIT...!',
//                            style: TextStyle(
//                                fontSize: 15
//                            ),
//                          ),
//                        );
//                        Scaffold.of(context).showSnackBar(snackBar);
//                        //mpesa
//                        mpesa.lipaNaMpesa(
//                            phoneNumber: _phonenumber.toString(),
//                            amount: double.parse((_itemCount*int.parse(widget.price)).toString()),
//                            transactionDescription: "Nest",
//                            businessShortCode: amount.toString(),
//                            callbackUrl: "https://us-central1-arma-17c62.cloudfunctions.net/custommpesa"
//                        ).then((result)
//                        {
//                          print(result['CheckoutRequestID']);
//                          checkoutIds = result['CheckoutRequestID'].toString();
//                          Timer(Duration(seconds: 20),()
//                          {
//                            getsuccess(checkoutIds);
//                          });
//                        }).catchError((error){
//                          print(error.toString());
//                        });
//                        checkoutIds = '';
//                      }
//                  },
//                  child: Text("Continue..."),
//                ),
//              ),
//            ],
//          ),
//        ),
////        Positioned(
////          left: 60,
////          right: 60,
////          child: CircleAvatar(
////            backgroundColor: Colors.transparent,
////            backgroundImage: NetworkImage(imageurl),
////            radius: 90,
////          ),
////        ),
//      ],
//    );
//  }

int succes = 0;

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
        succes = 1;

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
    return Scaffold(
      body: Builder(
          builder: (context)=>SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Hero(
                          tag: widget.url,
                          child: new FadeInImage(
                            placeholder: new AssetImage("albums/beer.jpg"),
                            image: new NetworkImage(widget.url),
                            fit: BoxFit.fill,
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Colors.white,
                              iconSize: 25,
                              onPressed: (){
                                //action on press
                                Navigator.pop(context);
                              },
                            ),
                            Text(widget.name!=null?widget.name:'',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'PressStart2P-Regular.ttf'
                                )
                            ),
                            IconButton(
                                icon: Icon(Icons.favorite),
                                color: Colors.white,
                                onPressed: (){
                                  //action on press
                                }),

                          ],
                        ),
                      ),

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
                        Text("Details.",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Divider(),
                        Text(widget.details),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Price: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),
                            ),
                            SizedBox(width: 20),
                            Text('\$ '+widget.price,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            )
                          ],
                        )
                        ,
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Quantity: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),
                            ),

                            _itemCount!=0? new  IconButton(icon:
                            new Icon(Icons.remove),
                              onPressed: ()
                              =>setState(
                                      ()=>_itemCount--
                              ),
                            )
                                :new Container(),
                            new Text(_itemCount.toString()),
                            new IconButton(
                                icon:  new Icon(Icons.add),
                                onPressed: ()
                                =>setState(
                                        ()=>_itemCount++
                                )
                            ),
                            SizedBox(width: 10)
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Total: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),
                            ),
                            SizedBox(width: 20),
                            Text( (_itemCount*int.parse(widget.price)).toString() ,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 25),
                        SizedBox(height: 80),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton.icon(
                              onPressed: ()
                              {

                                if(_itemCount != 0)
                                {
                                  final DocumentReference documentReference = Firestore.instance.collection("cache_data").document();
                                  Map<String, String> data = <String, String>
                                  {
                                    'url': widget.url,
                                    'name': widget.name,
                                    'price':widget.price,
                                    'quantity':_itemCount.toString(),
                                    'username':"Dennis",
                                    'ID': "2"
                                  };
                                  documentReference.setData(data).whenComplete(()async{
                                    await print ("Document Added");
                                  }).catchError((e)
                                  {
                                    print(e);
                                  });
                                  Navigator.pop(context);
                                }
                                else
                                {
                                  //nothing happens...Add a notification.
                                }
                              },
                              icon: Icon(Icons.shopping_cart),
                              color: Colors.orange,
                              label: Text("Add to Cart",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            RaisedButton.icon(
                                onPressed: (){
                                  if(_itemCount != 0)
                                  {
                                    someFunction(context);
                                    final snackBar = SnackBar(
                                    duration: const Duration(seconds: 15),
                                    content: Text('PLEASE WAIT...!',
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
//                                    if(_phonenumber.text.toString().length == 10)
//                                    {

////                                      String makeup  = "254" + _phonenumber.text.toString().substring(1,10);
////                                      print(makeup);
////                                      mpesa.lipaNaMpesa(
////                                          phoneNumber: makeup,
////                                          amount: double.parse((_itemCount*int.parse(widget.price)).toString()),
////                                          transactionDescription: "Nest",
////                                          businessShortCode: amount.toString(),
////                                          callbackUrl: "https://us-central1-arma-17c62.cloudfunctions.net/custommpesa"
////                                      ).then((result)
////                                      {
////                                        print(result['CheckoutRequestID']);
////                                        checkoutIds = result['CheckoutRequestID'].toString();
////                                        Timer(Duration(seconds: 20), ()
////                                        {
////                                          getsuccess(checkoutIds);
////                                        });
////                                        final DocumentReference documentReference = Firestore.instance.collection("receipts_for_Mpesa").document();
////                                        Map<String, dynamic> data = <String, dynamic>
////                                        {
////                                          'transaction': 'Mpesa',
////                                          'Hotelname': widget.hotel.toString(),
////                                          'Amount': (_itemCount*int.parse(widget.price)).toString(),
////                                          'Serial no.': result['CheckoutRequestID'],
////                                          'username':"Dennis",
////                                          'Item': widget.name.toString(),
////                                          'Qty': _itemCount.toString(),
////                                          'price':widget.price.toString()
////                                        };
////                                        documentReference.setData(data).whenComplete(()async{
////                                          await print ("Document Added");
////                                        }).catchError((e)
////                                        {
////                                          print(e);
////                                        });
////
////                                      }).catchError((error){
////                                        print(error.toString());
////                                      });
////                                      checkoutIds = '';
////                                      succes = 0;
////                                      confirm = 0;
//
//                                    }
                                      
                                    //buildz(context);
                                    print("check error");
                                  }
                                  else
                                  {
                                    final snackBar = SnackBar(
                                      duration: const Duration(seconds: 4  ),
                                      content: Text('ADD QUANTITY...!',
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
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            )
                          ],
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                  SizedBox(height: 10)
                ]
            ),
          )
      ) ,
    );
  }
}