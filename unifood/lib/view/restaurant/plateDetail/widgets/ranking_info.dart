import 'package:flutter/material.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';

class RankingInfo extends StatefulWidget {
  final Map<String, dynamic> characteristics;

  RankingInfo({required this.characteristics});

  @override
  _RankingInfoState createState() => _RankingInfoState();
}

class _RankingInfoState extends State<RankingInfo> {
  bool isInfoVisible = true;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.075, vertical: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ranking',
                  style: TextStyle(
                    fontSize: screenHeight * 0.0225,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomCircledButton(
                  onPressed: () {
                    setState(() {
                      isInfoVisible = !isInfoVisible;
                    });
                  },
                  diameter: screenHeight * 0.0025,
                  icon: Icon(
                    isInfoVisible
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.black,
                    size: screenHeight * 0.0335,
                  ),
                  buttonColor: Colors.white,
                ),
              ],
            ),
            Visibility(
              visible: isInfoVisible,
              child: widget.characteristics.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.characteristics.entries.map((entry) {
                          return _buildCharacteristicRow(
                              entry.key, entry.value, screenWidth);
                        }).toList(),
                      ),
                    )
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                      child: Text(
                        'No ranking available',
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacteristicRow(
      String characteristic, double rating, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$characteristic: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildStarRating(rating),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    double remainder = rating - fullStars;
    List<Widget> starWidgets = [];
    for (int i = 0; i < fullStars; i++) {
      starWidgets.add(Icon(Icons.star, color: Colors.yellow));
    }
    if (remainder > 0) {
      starWidgets.add(Icon(Icons.star_half, color: Colors.yellow));
    }
    return Row(children: starWidgets);
  }
}
