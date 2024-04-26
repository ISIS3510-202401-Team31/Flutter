import 'package:flutter/material.dart';
import 'package:unifood/model/preferences_entity.dart'; 
import 'package:cached_network_image/cached_network_image.dart';

typedef OnDeleteItem = void Function(int index, String type);
typedef OnRestoreItem = void Function(int index, String type);

class CustomSettingOptionWithIcons extends StatelessWidget {
  final List<PreferenceItem> items;
  final String userId;
  final VoidCallback onPressed;
  final Set<int> markedForDeletion;
  final OnDeleteItem onDeleteItem;
  final OnRestoreItem onRestoreItem; // Callback to restore the item
  final bool isEditing;
  final String type;
  final bool isConnected;

  const CustomSettingOptionWithIcons({
    required this.items,
    required this.userId,
    required this.onPressed,
    required this.markedForDeletion,
    required this.onDeleteItem,
    required this.onRestoreItem,
    required this.type,
    required this.isConnected,
    this.isEditing = false, // Default value is false
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isConnected && items.isEmpty) {
      // No connection and no cached items, return the 'No Connection' message widget
      return _buildNoConnectionWidget(context);
    } else{
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.2; // Adjusted to use MediaQuery
    double itemWidth =
        imageSize + 20; // Additional space for padding and separation
    double fontSize = screenWidth * 0.030; // Dynamically adjust the font size

    // Create a filtered list of items based on edit mode and marked for deletion
    List<PreferenceItem> filteredItems = isEditing
        ? items
        : items
            .asMap()
            .entries
            .where((entry) => !markedForDeletion.contains(entry.key))
            .map((entry) => entry.value)
            .toList();

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
      height: imageSize + 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length, // Use the full length of items
        itemBuilder: (context, index) {
          final item = items[index];
          final bool isMarkedForDeletion = markedForDeletion.contains(index);

          // Only render the item if not marked for deletion, or if in editing mode
          if (isMarkedForDeletion && !isEditing) {
            return Container(); // Skip rendering this item entirely
          }

          double opacity = isMarkedForDeletion
              ? 0.5
              : 1.0; // Apply opacity if marked for deletion

          return Opacity(
            opacity: opacity,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: onPressed,
                  child: Container(
                    width: itemWidth,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircularProgressIndicator(), // Placeholder widget while loading
                          errorWidget: (context, url, error) => Icon(Icons.broken_image, size: imageSize), // Widget to display in case of error
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
                if (isEditing && !isMarkedForDeletion)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () => onDeleteItem(index, type),
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
                if (isEditing && isMarkedForDeletion)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () => onRestoreItem(index, type),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
  }
    Widget _buildNoConnectionWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: const Text('No Connection. Try again Later', 
                     style: TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }
}
