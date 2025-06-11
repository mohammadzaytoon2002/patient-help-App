import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watch3/api/QRapi.dart';
import 'package:watch3/componant/const.dart';
import 'package:watch3/componant/custom_clipper.dart';
import 'package:watch3/componant/grid_item_scan.dart';

class Scan_Prod extends StatefulWidget {
  @override
  _ScanProdState createState() => _ScanProdState();
}

class _ScanProdState extends State<Scan_Prod> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> getImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _fetchProductInfoFromFile(_image!);
    } else {
      print('No image selected.');
    }
  }

  void _fetchProductInfoFromFile(File image) async {
    // Implement the logic to scan the QR code from the image file
    // and fetch product information using the scanned QR code
    // Similar to the _fetchProductInfo function in QRViewExample
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    // For Grid Layout
    double _crossAxisSpacing = 16, _mainAxisSpacing = 16, _cellHeight = 150.0;
    int _crossAxisCount = 2;

    double _width = (MediaQuery.of(context).size.width -
            ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    double _aspectRatio =
        _width / (_cellHeight + _mainAxisSpacing + (_crossAxisCount + 1));

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Constants.blue,
              height: Constants.headerHeight + statusBarHeight,
            ),
          ),
          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 220,
                width: 220,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Constants.paddingSide),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 34,
                      child: RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back_ios,
                            size: 15.0, color: Colors.white),
                        shape: CircleBorder(
                          side: BorderSide(
                              color: Colors.white,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "QR",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          mainAxisAlignment: MainAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              "",
                              style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                    Spacer(),
                    Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/logo.png'),
                        height: 73,
                        width: 80,
                        color: Colors.white.withOpacity(1)),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(height: 30),
                Container(
                    height: 35,
                    child: GridItem_scan(
                        status: "Direct the Camera to scan Prod",
                        time: "",
                        value: "",
                        unit: "",
                        color: Constants.darkGreen,
                        image: AssetImage('assets/images/qr.png'),
                        remarks: "")),
                SizedBox(height: 30),
                Container(
                  child: MaterialButton(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 6, bottom: 6),
                    color: Colors.green,
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRViewExample()),
                      )
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.green, width: 2)),
                    child: const Text(
                      'Scan',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: MaterialButton(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 6, bottom: 6),
                    color: Colors.blue,
                    onPressed: getImageFromGallery,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.blue, width: 2)),
                    child: const Text(
                      'Choose Barcode from Gallery',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
