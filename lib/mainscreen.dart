import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodtrack/cartpage.dart';
import 'package:foodtrack/drawer.dart';
import 'package:foodtrack/homescreen.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chatscreen.dart';
import 'profilescreen.dart';
import 'package:http/http.dart' as http;
 
class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Widget> tabchildren;
  String _titlecenter = "Loading...";
  String maintitle = "Main Screen";
  List _userProductList = [];
  double screenHeight, screenWidth;
  SharedPreferences prefs;
  int cartitem = 0;

  @override
  void initState() {
    super.initState();
    tabchildren=[
      HomeScreen(user: widget.user),
      MessagesScreen(),
      MyProfile(),
    ];
    _loadProducts();
    _loadCarts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xff2171cc),
        unselectedItemColor: Colors.black54,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Messages",
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
      ),
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
      body: tabchildren[_currentIndex],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if(_currentIndex == 0){
        maintitle = "Main Screen";
      }
      if(_currentIndex == 1){
        maintitle = "Notification Screen";
      }
      if(_currentIndex == 2){
        maintitle = "Profile Screen";
      }
    });
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

  void _loadCarts() {
    http.post(
      Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/load_cart.php"),
      body: {"email": widget.user.email}).then((response){
        if (response.body == "failed") {
          cartitem = 0;
        } 
        else {
          cartitem = int.parse(response.body);
        }
      }
    );
  }
}