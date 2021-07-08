import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodtrack/authenticate/registrationscreen.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:foodtrack/mainscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
 
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController(); 
  SharedPreferences pref;
  ProgressDialog pr;
  double screenHeight, screenWidth;

  @override
  void initState(){
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Login...',
      borderRadius: 30,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
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
                    vertical: 100,
                  ),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('WELCOME',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),),
                    Text('Log In to continue',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                    SizedBox(height:30),
                    textEmail(),
                    SizedBox(height:20),
                    textPassword(),
                    btnForgotPassword(),
                    btnRememberMe(),
                    btnLogin(),
                    btnSignupAcc(),
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
            controller: _passwordController,
            keyboardType: TextInputType.emailAddress,
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

  Widget btnForgotPassword(){
    return Container(
      alignment: Alignment.centerRight,
      child: MaterialButton(
        onPressed: _forgotPassword,
        padding: EdgeInsets.only(right: 0),
        child: Text('Forgot Password?',
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget btnRememberMe(){
    return Container(
      height: 20,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.blue,
              activeColor: Colors.white,
              onChanged: (bool value){
                _onChanged(value);
              },
            ),
          ),
          Text('Remember Me',
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget btnLogin(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: MaterialButton(
        elevation: 5,
        onPressed: _onLogin,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: GoogleFonts.openSans(
            color: Color(0xff2171cc),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget btnSignupAcc(){
    return GestureDetector(
      onTap: _registerNewUser,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account? ',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
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

  void _onChanged(bool value) {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
  
    if(_email.isEmpty || _password.isEmpty){
      Fluttertoast.showToast(
        msg: "Email/password is empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    setState(() {
      _rememberMe = value;
      storePref (value, _email, _password);
    });
  }

  Future <void> _onLogin() async{
    pr = ProgressDialog(
      context, type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    http.post(
      Uri.parse("https://crimsonwebs.com/s271304/foodtrack/php/login_user.php"),
      body: {"email": _email, "password": _password}).then((response) {
        print(response.body);
        if (response.body=="failed"){
          Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
        }else{
          List userData = response.body.split(",");
          User user = User(
            email: _email, 
            password: _password, 
            datereg: userData[1],
            rating: userData[2],
            credit: userData[3],
            status: userData[4]
          );
          Navigator.push(
            context, MaterialPageRoute(builder: (content) => MainScreen(user: user)),
          );
        }
      }
    );
  }

  void _forgotPassword() {
    TextEditingController _useremailcontroller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0),),),
          title: Text("Forgot Your Password?",
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          content: new Container(
            height: 100,
            child: Column(children: [
              Text("Enter your email:",
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 18,
              ),),
              TextField(
                controller: _useremailcontroller,
                decoration: InputDecoration(
                  labelText: 'Email', 
                  icon: Icon(Icons.email)
                ),
              ),
            ],),
          ),
          actions: [
            TextButton(child: Text("Cancel",
            style: GoogleFonts.openSans(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),), 
            onPressed: (){
              Navigator.of(context).pop();
            },),
            TextButton(child: Text("Submit",
            style: GoogleFonts.openSans(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),), 
            onPressed: (){
              print(_useremailcontroller.text);
              _resetPassword(_useremailcontroller.text);
              Navigator.of(context).pop();
            },),
          ],
        );
      }
    );
  }

  void _registerNewUser() {
    Navigator.push(
      context, MaterialPageRoute(
        builder: (content) => RegistrationScreen(),
      ),
    );
  }

  void _resetPassword(String emailreset) {
    http.post(
      Uri.parse("https://crimsonwebs.com/s271304/foodtrack/php/forgot_password.php"),
      body: {"email": emailreset}).then((response) {
        print(response.body);
        if (response.body=="success"){
          Fluttertoast.showToast(
          msg: "Please check your email for reset password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
        }else{
          Fluttertoast.showToast(
          msg: "Please put the correct email",
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

  Future<void> storePref(bool value, String email, String password) async {
    pref = await SharedPreferences.getInstance();
    if(value){
      await pref.setString("email", email);
      await pref.setString("password", password);
      await pref.setBool("rememberme", value);
      Fluttertoast.showToast(
        msg: "Preference stored",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    else{
      await pref.setString("email", '');
      await pref.setString("password", '');
      await pref.setBool("rememberme", false);
      Fluttertoast.showToast(
        msg: "Preference removed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _emailController.text = "";
        _passwordController.text = "";
        _rememberMe = false;
      });
      return;
    }
  }

  Future<void> loadPref() async {
    pref = await SharedPreferences.getInstance();
    String _email = pref.getString("email")??'';
    String _password = pref.getString("password")??'';
    _rememberMe = pref.getBool("rememberme")?? false;

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }

}