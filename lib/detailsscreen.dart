import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
 
class DetailsScreen extends StatefulWidget {
  final User user;
  final productimage;
  final productname;
  final productType;
  final productPrice;
  final productQty;
  final index;
  const DetailsScreen({Key key, this.productimage, this.productname, this.productType, this.productPrice, this.productQty, this.index, this.user, }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double screenHeight, screenWidth;
  int cartitem = 0;
  List _userProductList = [];

  @override
  void initState() {
    super.initState();
    //_loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text(widget.productname,
        style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   TextButton.icon(
        //     onPressed: () => Navigator.push(
        //       context, MaterialPageRoute(builder: (content) => MyCart(user: widget.user))),
        //     icon: Icon(Icons.shopping_cart, color: Colors.white,
        //     ),
        //     label: Text(
        //       cartitem.toString(),
        //       style: GoogleFonts.openSans(color: Colors.white),
        //     ),
        //   ),
        // ]
      ),
      body: Column(
        children: [
          //SizedBox(height: 5),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: 1 / 2.5 * screenHeight,
                  color: Colors.lightBlue[50],
                  child: widget.productimage,
                ),
              ],
            ),
          ),
          // Divider(
          //   height: 1,
          //   color: Colors.grey,
          // ),
          Expanded(
            flex: 3,
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20,5,20,5),
                    child: Column(
                      children: [
                        Text( widget.productname,
                          style: GoogleFonts.openSans(
                            fontSize: 22, fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("This product is Halal Certified, local product and safe to eat.",
                          style: GoogleFonts.openSans(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text("RM " + double.parse(widget.productPrice).toStringAsFixed(2), 
                          style: GoogleFonts.openSans(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff2171cc),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Product Type: " + widget.productType,
                          style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Quantity Available: " + widget.productQty + " unit",
                          style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 1 / 1.5 * screenWidth,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () => {_addtocart(widget.index)},
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
              ],
            ),
          ),
        ],
      )
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
            backgroundColor: Color(0xff2171cc),
            textColor: Colors.white,
            fontSize: 18.0,
          );
          //_loadCart();
        }
      }
    );//}
  }

  // void _loadCart() {
  //   print(widget.user.email);
  //   http.post(
  //     Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/loadcartitem.php"),
  //     body: {"email": widget.user.email}).then((response){
  //       setState(() {
  //         cartitem = int.parse(response.body);
  //         print(cartitem);
  //       });
  //     }
  //   );
  // }
}