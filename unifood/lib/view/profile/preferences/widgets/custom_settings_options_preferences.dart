import 'package:flutter/material.dart';
import 'package:unifood/model/preferences_entity.dart'; // Ensure the path is correct

typedef OnDeleteItem = void Function(int index, String userId);

class CustomSettingOptionWithIcons extends StatelessWidget {
  final List<PreferenceItem> items;
  final String userId;
  final VoidCallback onPressed;
  final OnDeleteItem onDeleteItem;
  final bool isEditing;

  const CustomSettingOptionWithIcons({
    required this.items,
    required this.userId,
    required this.onPressed,
    required this.onDeleteItem,
    this.isEditing = false, // Default value is false
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.2; // Adjusted to use MediaQuery
    double itemWidth =
        imageSize + 20; // Additional space for padding and separation
    double fontSize = screenWidth * 0.030; // Dynamically adjust the font size

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      height: imageSize + 40, // Adjust based on image size and text
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: onPressed,
                child: Container(
                  width: itemWidth,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        item.imageUrl,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: imageSize);
                        },
                      ),
                      Text(
                        item.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ],
                  ),
                ),
              ),
              if (isEditing)
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () => onDeleteItem(
                        index, userId), // Pass both index and userId
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.remove,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
