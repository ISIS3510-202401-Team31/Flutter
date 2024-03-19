// CategoryItem.dart
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.title,
    required this.count,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.brown.shade200,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, size: 16.0),
              const SizedBox(width: 8.0),
            ],
            Text(title),
            const SizedBox(width: 8.0),
            Text('($count)', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
