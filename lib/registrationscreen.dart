import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loginscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
 
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordControllera = new TextEditingController();
  TextEditingController _passwordControllerb = new TextEditingController();
  double screenHeight, screenWidth;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x662171cc),
                      Color(0x992171cc),
                      Color(0xcc2171cc),
                      Color(0xff2171cc),
                    ]
                  )
                ),
                child: SingleChildScrollView(
                  //physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 60,
                  ),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign Up',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),),
                    Text('Create Your Account Now',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                    SizedBox(height:30),
                    textEmail(),
                    SizedBox(height:15),
                    textPassword(),
                    SizedBox(height:15),
                    textPasswordAgain(),
                    SizedBox(height:15),
                    btnAcceptTerms(),
                    btnSignUp(),
                    btnLogin(),
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textEmail(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email:',
        style: GoogleFonts.openSans(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xff2171cc),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0,2),
              ),
            ],
          ),
          height: 60,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.openSans(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your email',
              hintStyle: GoogleFonts.openSans(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textPassword(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password:',
        style: GoogleFonts.openSans(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xff2171cc),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0,2),
              ),
            ],
          ),
          height: 60,
          child: TextField(
            controller: _passwordControllera,
            style: GoogleFonts.openSans(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your password',
              hintStyle: GoogleFonts.openSans(
                color: Colors.white70,
              ),
            ),
            obscureText: true,
          ),
        ),
      ],
    );
  }

  Widget textPasswordAgain(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Confirm Password:',
        style: GoogleFonts.openSans(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xff2171cc),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0,2),
              ),
            ],
          ),
          height: 60,
          child: TextField(
            controller: _passwordControllerb,
            style: GoogleFonts.openSans(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your password again',
              hintStyle: GoogleFonts.openSans(
                color: Colors.white70,
              ),
            ),
            obscureText: true,
          ),
        ),
      ],
    );
  }

  Widget btnAcceptTerms(){
    return Container(
      height: 20,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _isChecked,
              checkColor: Colors.blue,
              activeColor: Colors.white,
              onChanged: (bool value){
                _onChanged(value);
              },
            ),
          ),
          GestureDetector(
            onTap: _showEULA,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'I Agree to Terms & Conditions',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget btnSignUp(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: MaterialButton(
        elevation: 5,
        onPressed: _onSignUp,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        color: Colors.white,
        child: Text(
          'SIGN UP',
          style: GoogleFonts.openSans(
            color: Color(0xff2171cc),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget btnLogin(){
    return GestureDetector(
      onTap: _alreadySignUp,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account? ',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: 'Log In',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _alreadySignUp() {
    Navigator.push(
      context, MaterialPageRoute(
        builder: (content) => LoginScreen(),
      ),
    );
  }

  void _onChanged(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _onSignUp() {
    String _email = _emailController.text.toString();
    String _passworda = _passwordControllera.text.toString();
    String _passwordb = _passwordControllerb.text.toString();

    if(_email.isEmpty || _passworda.isEmpty || _passwordb.isEmpty){
      Fluttertoast.showToast(
        msg: "Please fill all the details needed before signing up",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    if(!validateEmail(_email)){
      Fluttertoast.showToast(
          msg: "Please check your email format",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if(_passworda != _passwordb){
      Fluttertoast.showToast(
          msg: "Confirm Password does not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (!validatePassword(_passworda)) {
      Fluttertoast.showToast(
          msg:"Password should contain atleast capital letter, small letter and number ",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept Terms & Conditions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    //checking data integrity
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0),),),
        title: Text("Sign Up an Account",
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        content: Text("Are you sure?",
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(child: Text("Cancel",
            style: GoogleFonts.openSans(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ), 
          onPressed: (){
            Navigator.of(context).pop();
          },),
          TextButton(child: Text("OK",
            style: GoogleFonts.openSans(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ), 
          onPressed: (){
            Navigator.of(context).pop();
            _registerUser(_email, _passworda);
          },),
        ],
      );
    });
  }

  Future <void> _registerUser(String email, String password) async {
    http.post(
      Uri.parse("https://crimsonwebs.com/s271304/foodtrack/php/register_user.php"),
        body: {"email": email, "password": password}).then((response) {
        print(response.body);
        if (response.body=="success"){
          Fluttertoast.showToast(
          msg: "Registration Success. Please check your email for verification link",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
          Navigator.push(
            context, MaterialPageRoute(
              builder: (content) => LoginScreen(),
            ),
          );
        }
        else{
          Fluttertoast.showToast(
          msg: "Registration Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
        }
      }
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$';
    RegExp regExp = new RegExp(pattern);
    print(regExp.hasMatch(value));
    return regExp.hasMatch(value);
  }

  void _showEULA() {
    showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("EULA"),
        content: new Container(
          height: screenHeight / 2,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: new SingleChildScrollView(
                  child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                      text:
                      "Welcome to CRIMSONWEBS (Company, we, our, us) These Terms of Service (Terms, Terms of Service) govern your use of our website located at foodtrack@crimsonwebs.com (together or individually “Service”) operated by CRIMSONWEBS. Our Privacy Policy also governs your use of our Service and explains how we collect, safeguard and disclose information that results from your use of our web pages. Your agreement with us includes these Terms and our Privacy Policy (Agreements). You acknowledge that you have read and understood Agreements, and agree to be bound of them. If you do not agree with (or cannot comply with) Agreements, then you may not use the Service, but please let us know by emailing at foodtrack@crimsonwebs.com so we can try to find a solution. These Terms apply to all visitors, users and others who wish to access or use Service. By using our Service, you agree to subscribe to newsletters, marketing or promotional materials and other information we may send. However, you may opt out of receiving any, or all, of these communications from us by following the unsubscribe link or by emailing at foodtrack@crimsonwebs.com. If you wish to purchase any product or service made available through Service (“Purchase”), you may be asked to supply certain information relevant to your Purchase including but not limited to, your credit or debit card number, the expiration date of your card, your billing address, and your shipping information. You represent and warrant that: (i) you have the legal right to use any card(s) or other payment method(s) in connection with any Purchase; and that (ii) the information you supply to us is true, correct and complete. We may employ the use of third party services for the purpose of facilitating payment and the completion of Purchases. By submitting your information, you grant us the right to provide the information to these third parties subject to our Privacy Policy. We reserve the right to refuse or cancel your order at any time for reasons including but not limited to: product or service availability, errors in the description or price of the product or service, error in your order or other reasons. We reserve the right to refuse or cancel your order if fraud or an unauthorized or illegal transaction is suspected. We respect the intellectual property rights of others. It is our policy to respond to any claim that Content posted on Service infringes on the copyright or other intellectual property rights (“Infringement”) of any person or entity. If you are a copyright owner, or authorized on behalf of one, and you believe that the copyrighted work has been copied in a way that constitutes copyright infringement, please submit your claim via email to foodtrack@crimsonwebs.com, with the subject line: “Copyright Infringement” and include in your claim a detailed description of the alleged Infringement as detailed below, under “DMCA Notice and Procedure for Copyright Infringement Claims”. You may be held accountable for damages (including costs and attorneys’ fees) for misrepresentation or bad-faith claims on the infringement of any Content found on and/or through Service on your copyright. BY USING SERVICE OR OTHER SERVICES PROVIDED BY US, YOU ACKNOWLEDGE THAT YOU HAVE READ THESE TERMS OF SERVICE AND AGREE TO BE BOUND BY THEM. Please send your feedback, comments, requests for technical support by email: foodtrack@crimsonwebs.com.",
                    )
                  ),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          new TextButton(
            child: new Text("Close",
              style: GoogleFonts.openSans(
                color: Color(0xff2171cc),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },);
  }

  String titleCase(str) {
    var retStr = "";
    List userdata = str.toLowerCase().split(' ');
    print(userdata[0].toString());
    for (int i = 0; i < userdata.length; i++) {
      retStr += userdata[i].charAt(0).toUpperCase + " ";
    }
    print(retStr);
    return retStr;
  }

}