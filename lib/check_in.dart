import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:fleek/add_cart.dart';
import 'package:mpesa/mpesa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';



class check extends StatefulWidget{

  final url;
  final name;
  final price;
  final detail;

  check({Key key,
    @required
    this.url, this.name, this.price, this.detail
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
  int number = 254704446191;
  String checkin = "";


  Mpesa mpesa = Mpesa(
      clientKey: "tqynTw1B2kOtXJW1EpRsl1BNHAXXkCel",
      clientSecret: "tT7R9bNXDSPa7Xss",
      environment: "sandbox",
      initiatorPassword: "VeBVN1Fl987cBSW0+Mj3HAIJ1hacsTpum/W4Do1NpKcGro7TsxiMgP1FNXfwkT7AS4Kx0VLxYC6OrhMc4EXDrX/EqzSq41Puom7CRF2DqPOgJanOwnUioOA9hdaZCPKPOc8WYoJ/zEgM2mHJDyUgFwuj69gk/UNdFmc48R0yvIwbGA5E4fbe9KzeEr2mAWdOsBUFLE7sLmkHBVPja0Q1Y/ltuLICmbPqG2/Mdgc0t3ygtwbwmmmwrqBaW8g17wJzfZRedtEbyLAHPJ+SEkBAP3T1I3N9wWlloQbweBM86lvIBUjzqne1kjwlQEYixQuPiix0jXbPF+JZGovmAo45EQ==" ,
      passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919" );

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
                              Fluttertoast.showToast(
                                  msg: "Please wait...",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 3,
                                  backgroundColor: Color(0xff25242A),
                                  textColor: Colors.white
                              );
                              //snackbar display
//                              final snackBar = SnackBar(
//                                content: Text('Please wait...!'),
//                              );
//                              Scaffold.of(context).showSnackBar(snackBar);
                              //mpesa...
                              mpesa.lipaNaMpesa(
                                  phoneNumber: number.toString(),
                                  amount: double.parse((period*int.parse(widget.price)).toString()),
                                  transactionDescription: "Nest",
                                  businessShortCode: amount.toString(),
                                  callbackUrl: "https://webhook.site/e09a95ae-6b53-4845-8bc4-021c1bf4ba66"
                              ).then((result)
                              {
                                print(result.toString());
                              }).catchError((error){
                                print(error.toString());
                              });
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