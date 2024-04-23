import 'package:flutter/material.dart';
import 'package:unifood/model/points_entity.dart';

class RestaurantPoints {
  final String url;
  final int earned;
  final int redeemed;
  final int available;

  RestaurantPoints({
    required this.url,
    required this.earned,
    required this.redeemed,
    required this.available,
  });
}

class RestaurantPointsWidget extends StatefulWidget  {
  final List<Points> restaurantPointsList;

  const RestaurantPointsWidget({Key? key, required this.restaurantPointsList}) : super(key: key);

  @override
  _RestaurantPointsWidgetState createState() => _RestaurantPointsWidgetState();

}

class _RestaurantPointsWidgetState extends State<RestaurantPointsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.1;
    final fontSize = screenWidth * 0.04;
    final iconSize = screenWidth * 0.08;

    final pointsToShow = _isExpanded ? widget.restaurantPointsList : widget.restaurantPointsList.take(3).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: imageSize),
              Expanded(child: Text('Earned', textAlign: TextAlign.center, style: TextStyle(fontSize: fontSize))),
              Expanded(child: Text('Redeemed', textAlign: TextAlign.center, style: TextStyle(fontSize: fontSize))),
              Expanded(child: Text('Available', textAlign: TextAlign.center, style: TextStyle(fontSize: fontSize))),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          ...pointsToShow.map((point) => Padding(
            padding: EdgeInsets.only(bottom: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(point.url),
                    backgroundColor: Colors.transparent,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Failed to load network image.');
                    },
                  ),
                ),
                _buildPoints(point.earned, fontSize),
                _buildPoints(point.redeemed, fontSize),
                _buildPoints(point.available, fontSize),
              ],
            ),
          )).toList(),
          if (widget.restaurantPointsList.length > 3)
            IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, size: iconSize, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
        ],
      ),
    );
  }



  Widget _buildPoints(int points, double fontSize) {
    return Expanded(
      flex: 2,
      child: Text(
        '$points',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
    );
  }
}
