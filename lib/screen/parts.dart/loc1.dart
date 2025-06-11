// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:latlng/latlng.dart';



// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Map Example',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter Map Example'),
//         ),
//         body: FlutterMap(
//           options: MapOptions(
//             center: LatLng(51.5, -0.09),
//             zoom: 13.0,
//           ),
//           layers: [
//             TileLayerOptions(
//               urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//               subdomains: ['a', 'b', 'c'],
//             ),
//             MarkerLayerOptions(
//               markers: [
//                 Marker(
//                   width: 80.0,
//                   height: 80.0,
//                   point: LatLng(51.5, -0.09),
//                   builder: (ctx) => Container(
//                     child: FlutterLogo(),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
