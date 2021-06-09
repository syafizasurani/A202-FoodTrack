import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodtrack/newproduct.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class MyShop extends StatefulWidget {
  final User user;

  const MyShop({Key key, this.user}) : super(key: key);
  @override
  _MyShopState createState() => _MyShopState();
}

class _MyShopState extends State<MyShop> {
  double screenHeight, screenWidth;
  List _userProductList;
  String _titlecenter = "Loading...";

  @override
  void initState(){
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('My Product',
        style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              _userProductList == null
              ? Flexible(
                child: Center(child:Text(_titlecenter),),
              )
              : Flexible(
                child: Center(child:GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.793,
                  children:
                    List.generate(_userProductList.length, (index) {
                      return Padding(
                        padding: EdgeInsets.all(7),
                        child: Card(
                          elevation:8,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: screenHeight / 6.2,
                                  width: screenWidth / 1,
                                  child: CachedNetworkImage(
                                    imageUrl: "https://crimsonwebs.com/s271304/foodtrack/images/products/${_userProductList[index]['prid']}.png",
                                  ),
                                ),
                                SizedBox(height:5),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text("" +_userProductList[index]['prname'],
                                  style: GoogleFonts.openSans(fontSize:14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height:1),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text("Type: " +_userProductList[index]['prtype'],
                                  style: GoogleFonts.openSans(fontSize:14,),
                                  ),
                                ),
                                SizedBox(height:1),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text("Price: RM" +_userProductList[index]['prprice'],
                                  style: GoogleFonts.openSans(fontSize:14,),
                                  ),
                                ),
                                SizedBox(height:1),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text("Quantity: " +_userProductList[index]['prqty'],
                                  style: GoogleFonts.openSans(fontSize:14,),
                                  ),
                                ),
                                SizedBox(height:10),
                                Container(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () => {}, 
                                    style: ElevatedButton.styleFrom(primary: Colors.white60),
                                    child: Text("Edit Product",
                                    style: GoogleFonts.openSans(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },),
                ),),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('New Product'),
        backgroundColor: Color(0xff2171cc),
        onPressed: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (content) => NewProduct(user: widget.user))
          );
        },
      ),
    );
  }

  void _loadProducts() {
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/loadproduct.php"),
      body: {"email": widget.user.email}).then((response){
        if (response.body == "nodata") {
          _titlecenter = "Sorry no product found";
          return;
        } 
        else {
          var jsondata = json.decode(response.body);
          _userProductList = jsondata["products"];
          setState(() {
            print(_userProductList);
          });
        }
      }
    );
  }

}