import 'package:flutter/material.dart';
import 'package:foodtrack/loginscreen.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
 
class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("User Profile",
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text("eShop",
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("My Shop",
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Cart",
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Notification",
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Log Out",
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (content) => LoginScreen()),);
              },
            ),
          ],
        )
      ),
      body: Center(
        child: Column(
          children: [
            Text("Hello "+ widget.user.email),
            Text("Date Register "+ widget.user.datereg),
            Text("Credit "+ widget.user.credit),
            Text("Status "+ widget.user.status),
          ],
        ),
      ),
    );
  }
}