import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodtrack/checkoutpage.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

class MyCart extends StatefulWidget {
  final User user;
  const MyCart({Key key, this.user}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  double screenHeight, screenWidth;
  String _titlecenter = "Loading...";
  List _cartList = [];
  double _totalprice = 0.0;

  @override
  void initState(){
    super.initState();
    _loadShoppingCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('Shopping Cart',
        style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              if (_cartList.isEmpty)
              Flexible(
                child: Center(child:Text("Cart is Empty"),),
              )
              else
              Flexible(
                child: OrientationBuilder(builder: (context, orientation){
                  return GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1,
                    children: List.generate(_cartList.length, (index){
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
                                      imageUrl: "https://crimsonwebs.com/s271304/foodtrack/images/products/${_cartList[index]['prid']}.png",
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
                                        Text( _cartList[index]['prname'], 
                                          style: GoogleFonts.openSans(
                                            fontSize: 15, 
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("RM " + double.parse(_cartList[index]['prprice']).toStringAsFixed(2) + " /item"),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: (){
                                                _editQty(index, "removeqty");
                                              },
                                            ),
                                            Text(_cartList[index]['cartqty']),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: (){
                                                _editQty(index, "addqty");
                                              },
                                            ),
                                          ],
                                        ),
                                        Text("RM " + 
                                          (int.parse(_cartList[index]['cartqty']) * double.parse(_cartList[index]['prprice'])).toStringAsFixed(2),
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
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: (){
                                          _deleteCartDialog(index);
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
                decoration: new BoxDecoration(
                  color: Color(0xff2171cc),
                ),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Divider(height:1, thickness:2.0),
                    SizedBox(height: 3),
                    Text("SubTotal: RM" + _totalprice.toStringAsFixed(2),
                      style: GoogleFonts.openSans(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _payDialog();
                      },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                      child:Text("CHECKOUT",
                        style: GoogleFonts.openSans(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2171cc),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadShoppingCart() {
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/loadusercart.php"),
      body: {"email": widget.user.email}).then((response){
        if (response.body == "nodata") {
          _titlecenter = "No product";
          _cartList = [];
          return;
        } 
        else {
          var jsondata = json.decode(response.body);
          print(jsondata);
          _cartList = jsondata["cart"];
          _totalprice = 0.0;
          for (int i = 0; i < _cartList.length; i++) {
            _totalprice = _totalprice + double.parse(_cartList[i]['prprice']) * int.parse(_cartList[i]['cartqty']);
          }
        }
        setState(() {});
      }
    );
  }

  Future <void> _editQty(int index, String s) async{
    ProgressDialog progressDialog = ProgressDialog(context,
      message: Text("Update cart"), title: Text("Progress..."));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/updatecart.php"),
      body: {
        "email": widget.user.email, 
        "op": s,
        "prid": _cartList[index]['prid'],
        "cartqty": _cartList[index]['cartqty']
        }).then((response){
        if (response.body == "success") {
          Fluttertoast.showToast(
            msg: "Cart updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey[300],
            textColor: Colors.black,
            fontSize: 18.0,
          );
          _loadShoppingCart();
        } 
        else {
          Fluttertoast.showToast(
            msg: "Only one item in cart. Please click delete button to remove.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 18.0,
          );
        }
        progressDialog.dismiss();
      }
    );
  }

  void _deleteCartDialog(int index) {
    showDialog(
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        title: new Text('Delete from your cart?',
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
            _deleteCart(index);
          },
        ),
      ]),
      context: context
    );
  }

  Future <void> _deleteCart(int index) async {
    ProgressDialog progressDialog = ProgressDialog(context,
      message: Text("Remove from cart"), title: Text("Progress..."));
    progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/deletecart.php"),
      body: {
        "email": widget.user.email, 
        "prid": _cartList[index]['prid'],
        }).then((response){
        if (response.body == "success") {
          Fluttertoast.showToast(
            msg: "Item Successfully Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey[300],
            textColor: Colors.black,
            fontSize: 18.0,
          );
          _loadShoppingCart();
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

  void _payDialog() {
    if (_totalprice == 0.0) {
      Fluttertoast.showToast(
        msg: "Nothing to checkout.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    } else {
      showDialog(
        builder: (context) => new AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: new Text('Proceed with checkout?',
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
              onPressed: () async {
                Navigator.of(context).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CheckOutPage(
                      user: widget.user, total: _totalprice, //payListItem: _cartList,
                    ),
                  ),
                );
              },
            ),
          ]
        ),
        context: context
      );
    }
  }
}