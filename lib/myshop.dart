import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodtrack/newproduct.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ndialog/ndialog.dart';

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
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('My Shop',
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
                  childAspectRatio: (screenWidth / screenHeight) / 0.8,
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
                                    onPressed: () => {
                                      _deleteProductDialog(index),
                                    }, 
                                    style: ElevatedButton.styleFrom(primary: Colors.white60),
                                    child: Text("Delete",
                                    style: GoogleFonts.openSans(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)
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

  _deleteProductDialog(int index) {
    showDialog(
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        title: new Text('Delete ' + _userProductList[index]['prname'] + ' ?',
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
      actions: <Widget>[
        TextButton(
          child: Text("No",
            style: GoogleFonts.openSans(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        TextButton(
          child: Text("Yes",
            style: GoogleFonts.openSans(
              color: Color(0xff2171cc),
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _deleteProduct(index);
          },
        ),
      ]),
      context: context
    );
  }

  Future <void> _deleteProduct(int index) async {
    ProgressDialog progressDialog = ProgressDialog(context,
      message: Text("Remove this product"), title: Text("Progress..."));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/deleteproduct.php"),
      body: {
        "email": widget.user.email, 
        "prid": _userProductList[index]['prid'],
        }).then((response){
        if (response.body == "success") {
          Fluttertoast.showToast(
            msg: "Product Successfully Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey[300],
            textColor: Colors.black,
            fontSize: 18.0,
          );
          _loadProducts();
        } 
        else {
          Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 18.0
          );
        }
        progressDialog.dismiss();
      }
    );
  }

}