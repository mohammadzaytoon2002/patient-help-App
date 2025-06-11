// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// void main() => runApp(MyApp6());

// class MyApp6 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Geocoding Example'),
//         ),
//         body: Center(
//           child: LocationWidget(),
//         ),
//       ),
//     );
//   }
// }

// class LocationWidget extends StatefulWidget {
//   @override
//   _LocationWidgetState createState() => _LocationWidgetState();
// }

// class _LocationWidgetState extends State<LocationWidget> {
//   String _locationMessage = "";
//   String _address = "";

//   void _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         _locationMessage = "Location services are disabled.";
//       });
//       print("Location services are disabled.");
//       return;
//     }

//     // Check for location permissions.
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _locationMessage = "Location permissions are denied.";
//         });
//         print("Location permissions are denied.");
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         _locationMessage = "Location permissions are permanently denied.";
//       });
//       print("Location permissions are permanently denied.");
//       return;
//     }

//     // Get the current location.
//     Position position = await Geolocator.getCurrentPosition();
//     setState(() {
//       _locationMessage =
//           "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
//     });
//     print(_locationMessage);

//     // Get the address from the coordinates.
//     try {
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       setState(() {
//         _address =
//             "${place.locality}, ${place.administrativeArea}, ${place.country}";
//       });
//       print("Address: $_address");
//     } catch (e) {
//       setState(() {
//         _address = "Error retrieving address: $e";
//       });
//       print("Error retrieving address: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(_locationMessage),
//           SizedBox(height: 20),
//           Text(_address),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _getCurrentLocation,
//             child: Text("Get Location"),
//           ),
//         ],
//       ),
//     );
//   }
// }
