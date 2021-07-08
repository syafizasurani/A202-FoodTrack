import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
 
class MyPurchases extends StatefulWidget {
  final User user;
  const MyPurchases({Key key, this.user}) : super(key: key);

  @override
  _MyPurchasesState createState() => _MyPurchasesState();
}

class _MyPurchasesState extends State<MyPurchases> {
  double screenHeight, screenWidth;
  List _purchasesItem = [];
  String _titlecenter = "Loading...";
  double _totalpurchased = 0.0;

  @override
  void initState(){
    super.initState();
    _loadPurchasedItem();
  }
  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('My Purchases',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold, color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              if (_purchasesItem.isEmpty)
              Flexible(
                child: Center(child:Text("No Purchases Item"),),
              )
              else
              Flexible(
                child: OrientationBuilder(builder: (context, orientation){
                  return GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1,
                    children: List.generate(_purchasesItem.length, (index){
                      return Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                          child: Card(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: orientation == Orientation.portrait
                                      ? 100
                                      : 150,
                                    width: orientation == Orientation.portrait
                                      ? 100
                                      : 150,
                                    child: CachedNetworkImage(
                                      imageUrl: "https://crimsonwebs.com/s271304/foodtrack/images/products/${_purchasesItem[index]['prid']}.png",
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  child: VerticalDivider(color: Colors.grey)
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text( _purchasesItem[index]['prname'], 
                                          style: GoogleFonts.openSans(
                                            fontSize: 15, 
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text("RM " + double.parse(_purchasesItem[index]['prprice']).toStringAsFixed(2) + " /item"),
                                        SizedBox(height: 5),
                                        Text("Quantity: " + _purchasesItem[index]['purchased_qty']),
                                        SizedBox(height: 5),
                                        Text("RM " + 
                                          (int.parse(_purchasesItem[index]['purchased_qty']) * double.parse(_purchasesItem[index]['prprice'])).toStringAsFixed(2),
                                          style: GoogleFonts.openSans(
                                            fontSize: 16, 
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff2171cc),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.add_task, color: Colors.green),
                                        onPressed: (){
                                          //_deleteCartDialog(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          )
                        )
                      );
                    })
                  );
                }),
              ),
              Container(
                height: 55,
                decoration: new BoxDecoration(
                  color: Color(0xff2171cc),
                ),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Divider(height:1, thickness:4.0),
                    SizedBox(height: 3),
                    Text("Total Purchases: RM" + _totalpurchased.toStringAsFixed(2),
                      style: GoogleFonts.openSans(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  void _loadPurchasedItem() {
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/loadpurchaseditem.php"),
      body: {"email": widget.user.email}).then((response){
        if (response.body == "nodata") {
          _titlecenter = "No product";
          _purchasesItem = [];
          return;
        } 
        else {
          var jsondata = json.decode(response.body);
          print(jsondata);
          _purchasesItem = jsondata["purchased"];
          _totalpurchased = 0.0;
          for (int i = 0; i < _purchasesItem.length; i++) {
            _totalpurchased = _totalpurchased + double.parse(_purchasesItem[i]['prprice']) * int.parse(_purchasesItem[i]['purchased_qty']);
          }
        }
        setState(() {});
      }
    );
  }
}