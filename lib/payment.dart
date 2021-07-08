import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodtrack/customer.dart';
import 'package:foodtrack/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
 
class PaymentScreen extends StatefulWidget {
  final User user;
  final Customer customer;
  const PaymentScreen({Key key, this.customer, this.user}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('Payment',
          style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // leading: IconButton(
        //   onPressed: (){
        //     Navigator.pop(context);
        //       Navigator.push(
        //         context, MaterialPageRoute(builder: (content) => MainScreen(user: widget.user)),
        //       );
        //   },
        //   icon: Icon(Icons.arrow_back, color: Colors.white,)
        // ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                    'https://crimsonwebs.com/s271304/foodtrack/php/generate_bill.php?email=' +
                      widget.customer.email +
                      '&mobile=' +
                      widget.customer.phone +
                      '&name=' +
                      widget.customer.name +
                      '&amount=' +
                      widget.customer.amount,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}