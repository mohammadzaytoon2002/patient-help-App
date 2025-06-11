import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  Future<void> getImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _scanBarcodeFromFile(_image!);
    } else {
      print('No image selected.');
    }
  }

  void _scanBarcodeFromFile(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://zxing.org/w/decode'),
    );
    request.files.add(await http.MultipartFile.fromPath('f', image.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final barcode = _extractBarcodeFromZxingResponse(responseBody);
      if (barcode != null) {
        _fetchProductInfo(barcode);
      } else {
        print('No barcode found in image.');
      }
    } else {
      print('Failed to scan barcode from image.');
    }
  }

  String? _extractBarcodeFromZxingResponse(String responseBody) {
    final regex = RegExp(r'<pre>(.*?)</pre>', dotAll: true);
    final match = regex.firstMatch(responseBody);
    return match?.group(1)?.trim();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                height: height * 0.5, // نصف الشاشة للتأكد من أنه يمكن التمرير
                width: width,
                child: _buildQrView(context)),
            controller != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (result != null)
                        Container(
                            width: width * 0.8,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Data: ${result!.code}',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ))
                      else
                        Container(
                            width: width * 0.8,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Scan a code',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            )),
                    ],
                  )
                : Container(
                    height: height * 0.5,
                    width: width,
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImageFromGallery,
        child: Icon(Icons.photo_library),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width * 0.9;
    (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) async {
      if (result == null || result!.code != scanData.code) {
        controller.pauseCamera();
        setState(() {
          result = scanData;
          print(result!.code);
        });
        _fetchProductInfo(scanData.code!);
      }
    });
  }

  void _fetchProductInfo(String barcode) async {
    final url = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final productInfo = json.decode(response.body);
      _showProductInfoBottomSheet(productInfo['product']).then((value) {
        controller!.resumeCamera();
      });
    } else {
      print('Failed to fetch product information');
    }
  }

  Future<void> _showProductInfoBottomSheet(Map<String, dynamic> productInfo) {
    bool isProductSafe = false;
    final sugars = productInfo['nutriments']['sugars_100g'] ?? 0.0;
    final quantity = int.parse(productInfo['product_quantity']) ?? 0.0;
    final sugarContent = (sugars * quantity) / 100;
    isProductSafe = sugarContent <= 7.5;
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Name: ${productInfo['product_name']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Brand: ${productInfo['brands']}'),
                SizedBox(height: 8),
                Image.network(
                  productInfo['image_url'],
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 8),
                Text('Ingredients: ${productInfo['ingredients_text']}'),
                SizedBox(height: 8),
                if (isProductSafe)
                  Text(
                    'Sugar Content: ${sugarContent}g',
                    style: TextStyle(color: Colors.green),
                  )
                else
                  Text(
                    'High Sugar Content: ${sugarContent}g',
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 8),
                if (isProductSafe)
                  Text(
                    'You can consume this product.',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )
                else
                  Text(
                    'This product has a high sugar content. Please consume with caution.',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
