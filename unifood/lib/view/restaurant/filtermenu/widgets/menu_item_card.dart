// menu_item_card.dart
import 'package:flutter/material.dart';

class MenuItemCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  final double rating;
  final String author;
  final String price;

  const MenuItemCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.rating,
    required this.author,
    required this.price,
  }) : super(key: key);

  @override
  _MenuItemCardState createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                widget.imagePath,
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20.0),
                        Text('${widget.rating} • By ${widget.author}'),
                      ],
                    ),
                    Text('\$${widget.price}'),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
