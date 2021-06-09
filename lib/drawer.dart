import 'package:flutter/material.dart';
import 'package:foodtrack/loginscreen.dart';
import 'package:foodtrack/myshop.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
 
class MyDrawer extends StatefulWidget {
  final User user;

  const MyDrawer({Key key, this.user}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // ignore: missing_required_param
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.android
              ? Colors.white
              : Colors.black,
              child: Text(widget.user.email.toString().substring(0,1).toUpperCase(),
              style: TextStyle(
                fontSize: 40,
              ),),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.store, color: Color(0xff2171cc)),
            title: Text("My Product",
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context, MaterialPageRoute(builder: (content) => MyShop(user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xff2171cc)),
            title: Text("Settings",
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.update, color: Color(0xff2171cc)),
            title: Text("Updates",
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xff2171cc)),
            title: Text("Log Out",
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: (){
              Navigator.push(
                context, MaterialPageRoute(builder: (content) => LoginScreen()),
              );
            },
          ),
        ],
      )
    );
  }
}