import 'dart:convert';
import 'package:foodtrack/user.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

 
class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key key, this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight, screenWidth;
  List _userProductList = [];
  String _titlecenter = "Loading...";
  TextEditingController _prnameController = new TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadProducts(_prnameController.text);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                  hintStyle: GoogleFonts.openSans(fontSize: 15),
                  suffixIcon: IconButton(
                    onPressed: () => _searchProducts(_prnameController.text),
                    icon: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(28.0)),
                    borderSide: BorderSide(color: Colors.white24)
                  ),
                ),
                maxLines: 3,
                minLines: 1,
              ),
              SizedBox(height: 5),
              if (_userProductList == null)
              Flexible(
                child: Center(child:Text(_titlecenter),),
              )
              else 
              Flexible(
                child: Center(child:GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.81,
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
                                    onPressed: () => {_addtocart(index)}, 
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

  void _loadProducts(String prname) {
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/loadproduct.php"),
      body: {"email": widget.user.email}).then((response){
        if (response.body == "nodata") {
          _titlecenter = "No product";
          _userProductList = [];
          return;
        } 
        else {
          var jsondata = json.decode(response.body);
          print(jsondata);
          _userProductList = jsondata["products"];
          setState(() {});
        }
      }
    );
  }

  _addtocart(int index) {}

  String titleSub(String title) {
    if (title.length > 18) {
      return title.substring(0, 15) + "...";
    } else {
      return title;
    }
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
}