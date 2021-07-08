import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:foodtrack/delivery.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ndialog/ndialog.dart';
 
class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double screenHeight, screenWidth;
  double dis = 0;
  Set<Marker> markers = Set();
  String _address = "No location selected";
  Delivery _delivery;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _shopPosition = CameraPosition(
    target: LatLng(6.443364, 100.428612),
    zoom: 17,
  );

  @override
  void initState() {
    super.initState();
    _showShopMarker();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2171cc),
        title: Text('Select Location',
        style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Flexible(
                flex: 7,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _shopPosition,
                  markers: markers.toSet(),
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                  },
                  onTap: (newLatLng) {
                    _loadAddress(newLatLng);
                  },
                ),
              ),
              Divider(
                height: 5,
              ),
              Flexible(
                flex: 3,
                child: Container(
                  width: screenWidth,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height:10),
                        Text("Please select your delivery location from map",
                          style: GoogleFonts.openSans(
                            fontSize: 16, fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: screenWidth / 1.2,
                          child: Divider(),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 70, child: Text(_address,
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                        )
                                      )
                                    ),
                                    Text("Delivery distance : " + dis.toStringAsFixed(2) + " km",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                      )
                                    ),
                                  ]
                                ),
                              ),
                              Container(
                                height: 50, 
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  child: ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context, _delivery);
                                    },
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff2171cc))),
                                    child: Text("Save",
                                      style: GoogleFonts.openSans(
                                        fontSize: 16, fontWeight: FontWeight.bold,
                                      )
                                    )
                                  ),
                                ),
                              )
                            ],
                          )
                        )
                      ]
                    )
                  ),
                )
              )
            ],
          )
        ),
      ),
    );
  }

  void _showShopMarker() {
    MarkerId markerId1 = MarkerId("13");
    markers.add(Marker(
      markerId: markerId1,
      position: LatLng(6.443364, 100.428612),
      infoWindow: InfoWindow(
        title: 'Shop Location',
        snippet: "",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  }

  void _loadAddress(LatLng newLatLng) async {
    MarkerId markerId1 = MarkerId("12");
    ProgressDialog progressDialog = ProgressDialog(context,
      message: Text("Searching address"), title: Text("Locating..."));
    progressDialog.show();
    List<Placemark> newPlace = await placemarkFromCoordinates(
      newLatLng.latitude, newLatLng.longitude
    );
    // this is all you need
    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    _address = name +
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
    markers.clear();
    markers.add(Marker(
      markerId: markerId1,
      position: LatLng(newLatLng.latitude, newLatLng.longitude),
      infoWindow: InfoWindow(
        title: 'Address',
        snippet: _address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ));
    dis = _calculateDistance(newLatLng.latitude, newLatLng.longitude);
    _delivery = Delivery(_address, newLatLng);
    setState(() {});
    progressDialog.dismiss();
  }

  double _calculateDistance(lat1, long1) {
    var lat2 = 6.443364;
    var long2 = 100.428612;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((long2 - long1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}