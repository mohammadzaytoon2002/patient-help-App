import 'package:flutter/material.dart';
import 'package:watch3/componant/const.dart';

class GridItem_scan extends StatelessWidget {
  final String status;
  final String time;
  final String value;
  final String unit;
  final ImageProvider image;
  final Color color;
  final String remarks;

  // GridItem_scan(this.status, this.value, this.unit, this.time, this.image,
  //     this.remarks, this.color);
  GridItem_scan({
    // required Key key,
    required this.status,
    required this.value,
    required this.unit,
    required this.time,
    required this.image,
    required this.remarks,
    required this.color,
  }); //: super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  status,
                  style: TextStyle(fontSize: 15, color: Constants.textPrimary),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            (image == null)
                ? Column(
                    children: <Widget>[
                      Text(
                        value,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 35,
                            color: color),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Image(
                        height: 20,
                        width: 12,
                        image: image,
                      ),
                      Text(
                        remarks,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
