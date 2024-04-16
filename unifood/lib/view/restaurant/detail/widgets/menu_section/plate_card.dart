import 'package:flutter/material.dart';
import 'package:unifood/utils/string_utils.dart';
import 'package:unifood/view/restaurant/plateDetail/view/plate_detail.dart';

class PlateCard extends StatelessWidget {
  final String id;
  final String restaurantId;
  final String imagePath;
  final String name;
  final String description;
  final double price;

  const PlateCard({
    Key? key,
    required this.id,
    required this.restaurantId,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
         Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlateDetail(plateId: id, restaurantId: restaurantId)));
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: SizedBox(
          width: screenWidth * 0.9,
          height: screenHeight * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(screenWidth * 0.02)),
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: screenHeight * 0.109,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: screenWidth * 0.025,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      formatNumberWithCommas(price),
                      style:  TextStyle(
                        fontSize: screenWidth * 0.025,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
