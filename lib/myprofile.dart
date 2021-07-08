import 'package:flutter/material.dart';
import 'package:foodtrack/myshop.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
 
class MyProfile extends StatefulWidget {
  final User user;
  const MyProfile({Key key, this.user}) : super(key: key);
  
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:10),
              _getHeader(),
              _profileName("Syafiza Surani"),
              SizedBox(height:20),
              _heading("Personal Details"),
              _detailsCard(),
              SizedBox(height:10),
              _heading2("Others"),
              _detailsCard2(),
            ],
          ),
        ),
      )
    );
  }

  Widget _getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 100, width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  "https://crimsonwebs.com/s271304/foodtrack/images/profileimages/me.png",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileName(String name) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Center(
        child: Text(
          name,
          style: GoogleFonts.openSans(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _heading(String heading) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Text(
        heading,
        style: GoogleFonts.openSans(
          fontSize: 16, fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _detailsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.email),
              title: Text(
                widget.user.email,
                style: GoogleFonts.openSans(
                )
              ),
            ),
            Divider(
              height: 10, thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(
                "+60182556810",
                style: GoogleFonts.openSans(
                )
              ),
            ),
            Divider(
              height: 10, thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.task_alt),
              title: Text(
                widget.user.datereg,
                style: GoogleFonts.openSans(
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  _heading2(String heading2) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Text(
        heading2,
        style: GoogleFonts.openSans(
          fontSize: 16, fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _detailsCard2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.store),
              title: Text(
                "My Shop",
                style: GoogleFonts.openSans(
                ),
              ),
              onTap: (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (content) => MyShop(user: widget.user)),
                );
              }
            ),
            Divider(
              height: 10, thickness: 1,
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(
                "My Likes",
                style: GoogleFonts.openSans(
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}