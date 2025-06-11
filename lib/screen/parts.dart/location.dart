// import 'package:flutter/material.dart';
// import 'package:location/location.dart' as loc;
// import 'package:geocoding/geocoding.dart';
// import 'package:location_permissions/location_permissions.dart' as location_permissions;




// class MyLocationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Location'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             loc.Location location = loc.Location();
//             bool _serviceEnabled;
//             PermissionStatus _permissionGranted;
//             loc.LocationData _locationData;

//             _serviceEnabled = await location.serviceEnabled();
//             if (!_serviceEnabled) {
//               _serviceEnabled = await location.requestService();
//               if (!_serviceEnabled) {
//                 return;
//               }
//             }

//             _permissionGranted = await location.hasPermission();
//             if (_permissionGranted == PermissionStatus.denied) {
//               _permissionGranted = await location.requestPermission();
//               if (_permissionGranted != PermissionStatus.granted) {
//                 return;
//               }
//             }

//             _locationData = await location.getLocation();
//             print('Latitude: ${_locationData.latitude}');
//             print('Longitude: ${_locationData.longitude}');

//             List<Placemark> placemarks = await placemarkFromCoordinates(
//                 _locationData.latitude ?? 0, _locationData.longitude ?? 0);
//             if (placemarks != null && placemarks.isNotEmpty) {
//               Placemark placemark = placemarks[0];
//               print('Place: ${placemark.name}');
//             } else {
//               print('Failed to get placemarks or placemarks list is empty');
//             }
//           },
//           child: Text('Get My Location'),
//         ),
//       ),
//     );
//   }
// }
