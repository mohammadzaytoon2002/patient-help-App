// appBar: PreferredSize(
//         preferredSize: Size.fromHeight(250.0),
//         child: AppBar(
//           backgroundColor: Colors.blue,
//           shape: CustomShapeBorder(),
//           toolbarHeight: 150.0,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Prediction',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontSize: 25.0,
//                 ),
//               ),
//               SizedBox(width: 16),
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Color.fromARGB(255, 35, 61, 209).withOpacity(0.3),
//                 ),
//                 padding: EdgeInsets.all(10),
//                 child: Image.asset(
//                   'assets/images/logo.png',
//                   height: 120,
//                   width: 120,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),