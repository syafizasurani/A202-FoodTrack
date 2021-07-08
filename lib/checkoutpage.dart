import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodtrack/customer.dart';
import 'package:foodtrack/delivery.dart';
import 'package:foodtrack/mappage.dart';
import 'package:foodtrack/payment.dart';
import 'package:foodtrack/user.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
class CheckOutPage extends StatefulWidget {
  final User user;
  final double total;
  //final List payListItem;
  const CheckOutPage({Key key, this.user, this.total}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  double screenHeight, screenWidth;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController _userlocctrl = new TextEditingController();
  String _name = "Click to set";
  String _phone = "Click to set";
  int _radioValue = 0;
  String _selectedtime = "09:00 A.M";
  bool _statuspickup = true;
  bool _statusdel = false;
  String address = "";
  String _delivery = "Pickup";
  String _curtime = "";
  SharedPreferences prefs;
  // List _payListItem = [];
  // String _titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    final now = new DateTime.now();
    _curtime = DateFormat("Hm").format(now);
    int cm = _convMin(_curtime);
    _selectedtime = _minToTime(cm);
    _loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final now = new DateTime.now();
    String today = DateFormat('hh:mm a').format(now);
    String todaybanner = DateFormat('dd/MM/yyyy').format(now);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('Checkout',
        style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex:1,
            child: Stack(
              children: [
                Container(
                  width: screenWidth,
                  color: Colors.red,
                  child: Image.asset(
                    'assets/images/checkout.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          child: Text(
                            todaybanner, 
                            style: GoogleFonts.openSans(
                              color: Colors.white, fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                )
              ]
            )
          ),
          SizedBox(height: 5),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          Expanded(
            flex: 3,
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20,5,20,5),
                    child: Column(
                      children: [
                        SizedBox(height: 3),
                        Text("CUSTOMER DETAILS",
                          style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              flex: 3, 
                              child: Text("Email:",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                ),
                              )
                            ),
                            Container(
                              height: 20,
                              child: VerticalDivider(color: Colors.grey)
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(widget.user.email, 
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3, 
                              child: Text("Name:",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                ),
                              )
                            ),
                            Container(
                              height: 20,
                              child: VerticalDivider(color: Colors.grey)
                            ),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                onTap: () => {_nameDialog()},
                                child: Text(_name,
                                  style: GoogleFonts.openSans(
                                    fontSize: 15,
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3, 
                              child: Text("Phone:",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                ),
                              )
                            ),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)
                              ),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                onTap: () => {_phoneDialog()},
                                child: Text(_phone,
                                  style: GoogleFonts.openSans(
                                    fontSize: 15,
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        Text("DELIVERY METHOD",
                          style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Pickup",
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                              ),
                            ),
                            new Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: (int value) {
                                _handleRadioValueChange(value);
                              },
                            ),
                            Text("Delivery",
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                              ),
                            ),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: (int value) {
                                _handleRadioValueChange(value);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Visibility(
                  visible: _statuspickup,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        children: [
                          Text("PICKUP TIME",
                            style: GoogleFonts.openSans(
                              fontSize: 18, fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(5),
                            width: 300,
                            child: Text(
                              "Pickup time daily from 9.00 A.M to 7.00 P.M from our store. Please allow 15-30 minutes to prepare your order before pickup time.",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4, 
                                child: Text("Current Time: ",
                                  style: GoogleFonts.openSans(
                                    fontSize: 15, fontWeight: FontWeight.bold,
                                  ),
                                )
                              ),
                              Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)
                              ),
                              Expanded(
                                flex: 7,
                                child: Text(today),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4, 
                                child: Text("Set Pickup Time: ",
                                  style: GoogleFonts.openSans(
                                    fontSize: 15, fontWeight: FontWeight.bold,
                                  ),
                                )
                              ),
                              Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)
                              ),
                              Expanded(
                                flex: 7,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Text(_selectedtime,
                                        style: GoogleFonts.openSans(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        child: IconButton(
                                          iconSize: 32,
                                          icon: Icon(Icons.timer),
                                          onPressed: () =>
                                          {_selectTime(context)}
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _statusdel,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Text("DELIVERY ADDRESS",
                            style: GoogleFonts.openSans(
                              fontSize: 18, fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _userlocctrl,
                                      style: GoogleFonts.openSans(fontSize: 14),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Search/Enter Your Address',
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      minLines: 4,  //Normal textInputField will be displayed
                                      maxLines: 4,  // when user presses enter it will adapt to it
                                    ),
                                  ],
                                )
                              ),
                              Container(
                                height: 120,
                                child: VerticalDivider(color: Colors.grey)
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () =>{_getUserCurrentLoc()},
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            Color(0xff2171cc)
                                          )
                                        ),
                                        child: Text("Location",
                                          style: GoogleFonts.openSans(
                                            fontSize: 15, fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                                    Container(
                                    width: 150,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Delivery _del = await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => MapPage(),
                                            ),
                                          );
                                          print(address);
                                          setState(() {
                                            _userlocctrl.text = _del.address;
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            Color(0xff2171cc)
                                          )
                                        ),
                                        child: Text("Map",
                                          style: GoogleFonts.openSans(
                                            fontSize: 15, fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Color(0xff2171cc),
            ),
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Divider(height:1, thickness:2.0),
                SizedBox(height: 3),
                Text("Total Payment: RM" + widget.total.toStringAsFixed(2),
                  style: GoogleFonts.openSans(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _payNowDialog();
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                  child:Text("PAY NOW",
                    style: GoogleFonts.openSans(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2171cc),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name") ?? 'Click to set';
    _phone = prefs.getString("phone") ?? 'Click to set';
    setState(() {});
  }

  void _nameDialog() {
    showDialog(
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))
        ),
        title: new Text('Name',
          style: GoogleFonts.openSans(
            fontSize: 20, fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
        TextField(
          controller: nameController,
            style: GoogleFonts.openSans(fontSize: 16),
            decoration: InputDecoration(
              border: OutlineInputBorder(), 
              hintText: 'Enter Your Name', 
            ),
            keyboardType: TextInputType.name,
            ),
            TextButton(
              child: Text("OK",
                style: GoogleFonts.openSans(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff2171cc),
                )
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _name = nameController.text;
                prefs = await SharedPreferences.getInstance();
                await prefs.setString("name", _name);
                setState(() {});
              },
            ),
        ]
      ),
      context: context
    );
  }

  _phoneDialog() {
    showDialog(
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        title: new Text('Phone Number',
          style: GoogleFonts.openSans(
            fontSize: 20, fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
        TextField(
          controller: phoneController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              border: OutlineInputBorder(), 
              hintText: 'Enter Phone Number'
            ),
            keyboardType: TextInputType.phone,
            ),
            TextButton(
              child: Text("OK",
                style: GoogleFonts.openSans(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff2171cc),
                )
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _phone = phoneController.text;
                prefs = await SharedPreferences.getInstance();
                await prefs.setString("phone", _phone);
                setState(() {});
              },
            ),
        ]
      ),
      context: context
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _delivery = "Pickup";
          _statusdel = false;
          _statuspickup = true;
          _setPickupExt();
          break;
        case 1:
          _delivery = "Delivery";
          _statusdel = true;
          _statuspickup = false;
          break;
      }
      print(_delivery);
    });
  }

  Future <Null> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
    final now = new DateTime.now();
    print("NOW: " + now.toString());
    String year = DateFormat('y').format(now);
    String month = DateFormat('M').format(now);
    String day = DateFormat('d').format(now);

    String _hour, _minute, _time = "";
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute;
        _selectedtime = _time;
        _curtime = DateFormat("Hm").format(now);

        _selectedtime = formatDate(
          DateTime(int.parse(year), int.parse(month), int.parse(day),
          selectedTime.hour, selectedTime.minute),
          [hh, ':', nn, " ", am]).toString();
          int ct = _convMin(_curtime);
          int st = _convMin(_time);
          int diff = st - ct;
          if (diff < 30) {
            Fluttertoast.showToast(
              msg: "Invalid time selection",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            _selectedtime = _minToTime(ct);
            setState(() {});
            return;
          }
      }
    );
  }

  _getUserCurrentLoc() async {
    ProgressDialog progressDialog = ProgressDialog(context,
      message: Text("Searching address"), title: Text("Locating...")
    );
    progressDialog.show();
    await _determinePosition().then((value) => {_getPlace(value)});
    setState(
      () {},
    );
    progressDialog.dismiss();
  }

  void _payNowDialog() {
    showDialog(
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        title: Text("Total RM" + widget.total.toStringAsFixed(2),
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text("Continue to pay?",
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("No",
              style: GoogleFonts.openSans(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Yes",
              style: GoogleFonts.openSans(
                color: Color(0xff2171cc),
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            onPressed: () async{
              Navigator.of(context).pop();
              Customer _customer = new Customer(
                widget.user.email, _phone, _name, widget.total.toString(),
              );
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(customer: _customer),
                ),
              );
            }
          ),
        ],
      ),
      context: context
    );
  }

  int _convMin(String c) {
    var val = c.split(":");
    int h = int.parse(val[0]);
    int m = int.parse(val[1]);
    int tmin = (h * 60) + m;
    return tmin;
  }

  String _minToTime(int min) {
    var m = min + 30;
    var d = Duration(minutes: m);
    List<String> parts = d.toString().split(':');
    String tm = '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    return DateFormat.jm().format(DateFormat("hh:mm").parse(tm));
  }

  void _setPickupExt() {
    final now = new DateTime.now();
    _curtime = DateFormat("Hm").format(now);
    int cm = _convMin(_curtime);
    _selectedtime = _minToTime(cm);
    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _getPlace(Position pos) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    // this is all you need
    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    address = name +
        "," +
        subLocality +
        ",\n" +
        locality +
        "," +
        postalCode +
        ",\n" +
        administrativeArea +
        "," +
        country;
    _userlocctrl.text = address;
  }

  // void _loadCheckoutItem() {
  //   http.post(
  //     Uri.parse("http://crimsonwebs.com/s271304/foodtrack/php/loadusercart.php"),
  //     body: {"email": widget.user.email}).then((response){
  //       if (response.body == "nodata") {
  //         _titlecenter = "No product";
  //         _payListItem = [];
  //         return;
  //       } 
  //       else {
  //         var jsondata = json.decode(response.body);
  //         print(jsondata);
  //         _payListItem = jsondata["cart"];
  //         // _totalprice = 0.0;
  //         // for (int i = 0; i < _payListItem.length; i++) {
  //         //   _totalprice = _totalprice + double.parse(_payListItem[i]['prprice']) * int.parse(_payListItem[i]['cartqty']);
  //         // }
  //       }
  //       setState(() {});
  //     }
  //   );
  // }
}