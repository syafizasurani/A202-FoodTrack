import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodtrack/authenticate/loginscreen.dart';
import 'package:foodtrack/myprofile.dart';
import 'package:foodtrack/purchasesscreen.dart';
import 'package:foodtrack/setting.dart';
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
      // drawer: Theme(
      //   data: Theme.of(context).copyWith(
      //     canvasColor: Colors.black,
      //   )
      // ),
      child: ListView(
        children: [
          // ignore: missing_required_param
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff2171cc),
            ),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.android
              ? Colors.white
              : Colors.black,
              child: Text(widget.user.email.toString().substring(0,1).toUpperCase(),
              style: GoogleFonts.openSans(
                fontSize: 40,
              ),),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xff2171cc)),
            title: Text("Profile",
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context, MaterialPageRoute(builder: (content) => MyProfile(user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined, color: Color(0xff2171cc)),
            title: Text("My Purchases",
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context, MaterialPageRoute(builder: (content) => MyPurchases(user: widget.user)),
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
              Navigator.push(
                context, MaterialPageRoute(builder: (content) => Setting()),
              );
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
              // ProgressDialog progressDialog = ProgressDialog(context,
              //   message: Text("Checking for update"), title: Text("Checking...")
              // );
              //progressDialog.show();
              Fluttertoast.showToast(
                msg: "No New Update Available",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.grey[300],
                textColor: Colors.black,
                fontSize: 18.0,
              );
              //progressDialog.dismiss();
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