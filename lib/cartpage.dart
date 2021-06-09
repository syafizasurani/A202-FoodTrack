import 'package:flutter/material.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCart extends StatefulWidget {
  final User user;

  const MyCart({Key key, this.user}) : super(key: key);
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('Shopping Cart',
        style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          child: Text('Your Cart'),
        ),
      ),
    );
  }
}