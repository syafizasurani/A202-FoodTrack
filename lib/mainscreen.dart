import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodtrack/cartpage.dart';
import 'package:foodtrack/drawer.dart';
import 'package:foodtrack/detailsscreen.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
 
class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenHeight, screenWidth;
  List _userProductList = [];
  String _titlecenter = "Loading...";
  TextEditingController _prnameController = new TextEditingController();
  int cartitem = 0;
  SharedPreferences prefs;
  String email = "";

  @override
  void initState() {
    super.initState();
    _loadProducts("all");
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('Food Track',
        style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (content) => MyCart(user: widget.user))),
            icon: Icon(Icons.shopping_cart, color: Colors.white,
            ),
            label: Text(
              cartitem.toString(),
              style: GoogleFonts.openSans(color: Colors.white),
            ),
          ),
        ]
      ),
      drawer: MyDrawer(user: widget.user),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Column(
            children: [
              SizedBox(height: 5),
              TextFormField(
                controller: _prnameController,
                decoration: InputDecoration(
                  hintText: "Search product", 
                  hintStyle: GoogleFonts.openSans(fontSize: 15, color:Colors.black),
                  suffixIcon: IconButton(
                    onPressed: () => _searchProducts(_prnameController.text),
                    icon: Icon(Icons.search, color: Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(28.0)),
                    borderSide: BorderSide(color: Colors.black)
                  ),
                ),
                maxLines: 3,
                minLines: 1,
              ),
              SizedBox(height: 5),
              if (_userProductList.isEmpty)
              Flexible(
                child: Center(child:Text(_titlecenter),),
              )
              else 
              Flexible(
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
                                SizedBox(height:4),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(titleSub("" +_userProductList[index]['prname']),
                                  style: GoogleFonts.openSans(fontSize:14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height:1),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text("Price: RM" +_userProductList[index]['prprice'],
                                  style: GoogleFonts.openSans(fontSize:14,),
                                  ),
                                ),
                                SizedBox(height:10),
                                Container(
                                  width: double.infinity,
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () => {
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (content) => DetailsScreen(
                                          user: widget.user,
                                          productimage:
                                          CachedNetworkImage(
                                            imageUrl: "https://crimsonwebs.com/s271304/foodtrack/images/products/${_userProductList[index]['prid']}.png",
                                            fit: BoxFit.cover,
                                          ),
                                          productname: _userProductList[index]['prname'],
                                          productType: _userProductList[index]['prtype'],
                                          productPrice: _userProductList[index]['prprice'],
                                          productQty: _userProductList[index]['prqty'],
                                        ))
                                      )
                                    },
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)), 
                                    child: Text("View More",
                                    style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff2171cc))
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () => {_addtocart(index)},
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff2171cc))), 
                                    child: Text("Add to Cart",
                                    style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold)
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
    );
  }
  
  String titleSub(String title) {
    if (title.length > 18) {
      return title.substring(0, 15) + "...";
    } else {
      return title;
    }
  }

  void _loadProducts(String prname) {
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/loadproduct.php"),
      body: {"prname": prname}).then((response){
        if (response.body == "nodata") {
          _titlecenter = "No product";
          _userProductList = [];
          return;
        } 
        else {
          var jsondata = json.decode(response.body);
          print(jsondata);
          _userProductList = jsondata["products"];
        }
        setState(() {});
      }
    );
  }

  _addtocart(int index) {
    String prid = _userProductList[index]['prid'];
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/insertcart.php"),
      body: {"email": widget.user.email, "prid": prid}).then((response){
        if (response.body == "failed") {
          Fluttertoast.showToast(
            msg: "Failed to add to cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 18.0
          );
        } 
        else {
          Fluttertoast.showToast(
            msg: "Added to cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey[300],
            textColor: Colors.black,
            fontSize: 18.0,
          );
          _loadCart();
        }
      }
    );//}
  }

  _searchProducts(String prname) {
    print(prname);
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/loadproduct.php"),
      body: {"prname": prname}).then((response){
        if (response.body == "nodata") {
          _titlecenter = "No product";
          return;
        } 
        else {
          setState(() {
            print(_userProductList);
            var jsondata = json.decode(response.body);
            _userProductList = jsondata["products"];
          });
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      }
    );
  }

  void _loadCart() {
    print(widget.user.email);
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/loadcartitem.php"),
      body: {"email": widget.user.email}).then((response){
        setState(() {
          cartitem = int.parse(response.body);
          print(cartitem);
        });
      }
    );
  }

}