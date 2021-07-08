import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
 
class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  double screenHeight, screenWidth;
  bool valNotify1 = true;
  bool valNotify2 = false;
  bool valNotify3 = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('Account Settings',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold, color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Color(0xff2171cc),
                ),
                SizedBox(width: 10),
                Text("Account",
                  style: GoogleFonts.openSans(
                    fontSize: 22, fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(
              height: 20, thickness: 1,
            ),
            SizedBox(height: 10),
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Shop Settings"),
            buildAccountOption(context, "Profile"),
            buildAccountOption(context, "Language"),
            buildAccountOption(context, "Privacy and Security"),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.volume_up_outlined, color: Color(0xff2171cc)),
                SizedBox(width: 10),
                Text("Notifications",
                  style: GoogleFonts.openSans(
                    fontSize: 22, fontWeight: FontWeight.bold,
                  ),
                )
              ]
            ),
            Divider(
              height: 20, thickness: 1,
            ),
            SizedBox(height: 10),
            buildNotificationOption("Push Notifications", valNotify1, onChangedFunction1),
            buildNotificationOption("Email Notifications", valNotify2, onChangedFunction2),
            buildNotificationOption("Message Shortcuts", valNotify3, onChangedFunction3),
          ]
        )
      ),
    );
  }

  Padding buildNotificationOption(String title, bool value, Function onChangedMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, 
            style: GoogleFonts.openSans(
              fontSize: 20, fontWeight: FontWeight.w500,
              color: Colors.grey[600]
            ),
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Color(0xff2171cc),
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue){
                onChangedMethod(newValue);
              },
            ),
          )
        ],
      )
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title){
    return GestureDetector(
      onTap: (){
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Option 1"),
                Text("Option 2"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Close")
              )
            ]
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Text(title, 
              style: GoogleFonts.openSans(
                fontSize: 20, fontWeight: FontWeight.w500,
                color: Colors.grey[600]
              )
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  onChangedFunction1(bool newValue1){
    setState(() {
      valNotify1 = newValue1;
    });
  }

  onChangedFunction2(bool newValue2){
    setState(() {
      valNotify2 = newValue2;
    });
  }

  onChangedFunction3(bool newValue3){
    setState(() {
      valNotify3 = newValue3;
    });
  }

}