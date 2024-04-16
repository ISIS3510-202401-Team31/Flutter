import 'package:flutter/material.dart';
import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/utils/string_utils.dart';

class PlateInfo extends StatefulWidget {
  final Plate plate;

  const PlateInfo({Key? key, required this.plate}) : super(key: key);

  @override
  _PlateInfoState createState() => _PlateInfoState();
}

class _PlateInfoState extends State<PlateInfo> {
  bool isLiked = false;

  void _onUserInteraction(String feature, String action) {
    final event = {
      'feature': feature,
      'action': action,
    };
    AnalyticsRepository().saveEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.95,
      child: Padding(
        padding: EdgeInsets.only(
          top:screenHeight * 0.04,
          left:screenWidth * 0.05,
          right:screenWidth * 0.05,
          bottom :screenHeight * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Image.network(
                widget.plate.imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
                height:screenHeight * 0.3,
              ),
            ),
            SizedBox(height:screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.plate.name,
                  style: TextStyle(
                    fontSize:screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                    _onUserInteraction("Plate Like", "Tap");
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left:screenWidth * 0.01),
              child: Text(
                widget.plate.description,
                style: TextStyle(fontSize:screenWidth * 0.035),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left:screenWidth * 0.01, top:screenHeight * 0.01),
              child: Text(
                formatNumberWithCommas(widget.plate.price),
                style: TextStyle(fontSize:screenWidth * 0.035, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
