// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:geocoding/geocoding.dart';

// // class MyLocationScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('My Location'),
// //       ),
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: () async {
// //             // الحصول على الموقع الحالي
// //             Position position = await Geolocator.getCurrentPosition(
// //               desiredAccuracy: LocationAccuracy.high,
// //             );

// //             // استخدام Geocoding للحصول على اسم المدينة
// //             List<Placemark>? placemarks = await placemarkFromCoordinates(
// //                 position.latitude, position.longitude);
// //             if (placemarks != null && placemarks.isNotEmpty) {
// //               Placemark placemark = placemarks[0];
// //               print('City: ${placemark.locality}');
// //             } else {
// //               print('Failed to get placemarks or placemarks list is empty');
// //             }
// //           },
// //           child: Text('Get My Location'),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MyLocationScreen extends StatefulWidget {
//   @override
//   _MyLocationScreenState createState() => _MyLocationScreenState();
// }

// class _MyLocationScreenState extends State<MyLocationScreen> {
//   GoogleMapController? _controller;
//   LatLng? _center;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Location'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 // الحصول على الموقع الحالي
//                 Position position = await Geolocator.getCurrentPosition(
//                   desiredAccuracy: LocationAccuracy.high,
//                 );

//                 setState(() {
//                   _center = LatLng(position.latitude, position.longitude);
//                 });

//                 // استخدام Geocoding للحصول على اسم المدينة
//                 List<Placemark>? placemarks = await placemarkFromCoordinates(
//                     position.latitude, position.longitude);
//                 if (placemarks != null && placemarks.isNotEmpty) {
//                   Placemark placemark = placemarks[0];
//                   print('City: ${placemark.locality}');
//                 } else {
//                   print('Failed to get placemarks or placemarks list is empty');
//                 }

//                 _controller?.animateCamera(CameraUpdate.newLatLng(_center!));
//               },
//               child: Text('Get My Location'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: _center == null
//                   ? Container()
//                   : GoogleMap(
//                       onMapCreated: (GoogleMapController controller) {
//                         _controller = controller;
//                       },
//                       initialCameraPosition: CameraPosition(
//                         target: _center!,
//                         zoom: 15.0,
//                       ),
//                       markers: {
//                         Marker(
//                           markerId: MarkerId('my_location'),
//                           position: _center!,
//                           infoWindow: InfoWindow(
//                             title: 'My Location',
//                           ),
//                         ),
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
