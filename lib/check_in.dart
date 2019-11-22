import 'dart:async';

import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:fleek/add_cart.dart';
import 'package:mpesa/mpesa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rich_alert/rich_alert.dart';



class check extends StatefulWidget{

  final url;
  final name;
  final price;
  final detail;
  final hotel;
  final roomz;
  check({Key key,
    @required
    this.url, this.name, this.price, this.detail,this.hotel,this.roomz
  }):
        super(key:key);

  @override
  checks createState()=> checks();
}

class checks extends State<check>
{
  String clause = "";
  int period = 0;
  int amount = 174379;
  int number = 0;
  String checkin = "";
  String checkoutIds = '';
  TextEditingController _phonenumber = TextEditingController();
  StreamSubscription<DocumentSnapshot> subscriptions;
  int rooming = 0;


  Mpesa mpesa = Mpesa(
      clientKey: "tqynTw1B2kOtXJW1EpRsl1BNHAXXkCel",
      clientSecret: "tT7R9bNXDSPa7Xss",
      environment: "sandbox",
      initiatorPassword: "VeBVN1Fl987cBSW0+Mj3HAIJ1hacsTpum/W4Do1NpKcGro7TsxiMgP1FNXfwkT7AS4Kx0VLxYC6OrhMc4EXDrX/EqzSq41Puom7CRF2DqPOgJanOwnUioOA9hdaZCPKPOc8WYoJ/zEgM2mHJDyUgFwuj69gk/UNdFmc48R0yvIwbGA5E4fbe9KzeEr2mAWdOsBUFLE7sLmkHBVPja0Q1Y/ltuLICmbPqG2/Mdgc0t3ygtwbwmmmwrqBaW8g17wJzfZRedtEbyLAHPJ+SEkBAP3T1I3N9wWlloQbweBM86lvIBUjzqne1kjwlQEYixQuPiix0jXbPF+JZGovmAo45EQ==" ,
      passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919" );

  // for the room number
  rooms()
  {
    DocumentReference documentReferences = Firestore.instance.collection("accomodation rooms").document(widget.hotel.toString());
    subscriptions = documentReferences .snapshots().listen((datasnapshot) {
      setState(() {
        rooming = int.parse(datasnapshot.data['number'].toString()) ;
      });
    });

  }




  //for phone number dialog
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
                          amount: double.parse((period*int.parse(widget.price)).toString()),
                          transactionDescription: "Nest",
                          businessShortCode: amount.toString(),
                          callbackUrl:"https://us-central1-arma-17c62.cloudfunctions.net/custommpesa"
                      ).then((result)
                      {
                        print(result['CheckoutRequestID']);
                        checkoutIds = result['CheckoutRequestID'].toString();
                        Timer(Duration(seconds: 20),()
                        {
                          getsuccess(checkoutIds);
                        });
                        final DocumentReference documentReferences = Firestore.instance.collection("accomodation rooms").document(widget.hotel.toString());
                        Map<String, dynamic> datas = <String, dynamic>
                        {
                          'number': widget.roomz - 1,
                        };
                        documentReferences.setData(datas, merge: true).whenComplete(()async{
                          await print ("Changed number");
                        }).catchError((e)
                        {
                          print(e);
                        });

                        final DocumentReference documentReference = Firestore.instance.collection("receipts_for_Mpesa").document();
                        Map<String, dynamic> data = <String, dynamic>
                        {
                          'transaction': 'Mpesa',
                          'Hotelname': widget.hotel.toString(),
                          'Amount': double.parse((period*int.parse(widget.price)).toString()),
                          'Serial no.': result['CheckoutRequestID'],
                          'username': number.toString(),
                          'Item':widget.name.toString(),
                          'Qty': "1",
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


  diff2(String checkins,String checkouts)

  {
    var check_in = checkins;
    var check_out = checkouts;
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

    print(periods);
    print(check_out);
    print(check_in);
    period = period + periods;

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                    tag: widget.url,
                    child: FadeInImage(
                      placeholder: AssetImage("albums/bed.jpg"),
                      image:NetworkImage(widget.url),
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
                              fontSize: 20
                          )
                      ),
                      IconButton(
                          icon: Icon(Icons.favorite),
                          color: Colors.white,
                          onPressed: (){
                            //action on press
                          })
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
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
                  Text(
                    'Details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  ),
                  Divider(),
                  Text(
                    widget.detail,
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Available rooms: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      ),
                      SizedBox(width: 20),
                      Text('\$ '+widget.roomz,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      )
                    ],
                  ),
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
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child:RaisedButton.icon(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: ()async
                          {
                            final List<DateTime> picked = await DateRagePicker.showDatePicker(
                                context: context,
                                initialFirstDate: new DateTime.now(),
                                initialLastDate: (new DateTime.now()).add(new Duration(days: 3)),
                                firstDate: new DateTime(2019),
                                lastDate: new DateTime(2028)
                            );
                            if (picked != null && picked.length == 2) {
                              setState(() {
                                print(picked);
                                clause = picked.toString();
                              });
                            }
                          },
                          label: Text("Check in  "),
                        ) ,
                      ),
                      Text(
                          clause.length!= 0 ? clause.substring(1,11):''
                      ),
                    ],
                  ),
                  SizedBox(height: 05),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child:  new RaisedButton.icon(
                            onPressed: (){
                              //...calendar
                            },
                            icon: Icon(Icons.arrow_back),
                            label: Text("Check out")
                        ),
                      ),
                      Text(
                        //   clause.substring(26,36)
                          clause.length!= 0 ? clause.substring(26,36):''
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton.icon(
                        onPressed: ()
                        {
//                          Navigator.push(context,MaterialPageRoute(builder: (context)=>
//                              cart()
//                          ));
                          if(clause.length != 0)
                          {
                            final DocumentReference documentReference = Firestore.instance.collection("cache_data").document();
                            Map<String, String> data = <String, String>
                            {
                              'url': widget.url,
                              'name': widget.name,
                              'price':widget.price,
                              'check in': clause.length!= 0 ? clause.substring(1,11):'',
                              'check out': clause.length!= 0 ? clause.substring(26,36):'',
                              'username':"Dennis",
                              'ID': "1"
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
                            String cls = clause.substring(1,11);
                            String lcs = clause.substring(26,36);
                            diff2(cls , lcs );
                            if(clause.length != 0 ){
//                              Fluttertoast.showToast(
//                                  msg: "Please wait...",
//                                  toastLength: Toast.LENGTH_SHORT,
//                                  gravity: ToastGravity.BOTTOM,
//                                  timeInSecForIos: 3,
//                                  backgroundColor: Color(0xff25242A),
//                                  textColor: Colors.white
//                              );
                            someFunction(context);
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 15  ),
                                content: Text('PLEASE WAIT...!',
                                  style: TextStyle(
                                      fontSize: 15
                                  ),
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                              //mpesa...

                            }
                            else
                            {

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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}