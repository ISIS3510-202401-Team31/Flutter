import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unifood/model/restaurant_entity.dart';

class RestaurantDropdown extends StatefulWidget {
  final Restaurant initialValue;
  final List<Restaurant> restaurants;
  final ValueChanged<Restaurant?> onChanged;

  const RestaurantDropdown({
    required this.initialValue,
    required this.restaurants,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _RestaurantDropdownState createState() => _RestaurantDropdownState();
}

class _RestaurantDropdownState extends State<RestaurantDropdown> {
  late Restaurant _selectedRestaurant;

  @override
  void initState() {
    super.initState();
    _selectedRestaurant = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: DropdownButton<Restaurant>(
        value: _selectedRestaurant,
        onChanged: (value) {
          setState(() {
            _selectedRestaurant = value!;
            widget.onChanged(value);
          });
        },
        items: widget.restaurants.map<DropdownMenuItem<Restaurant>>((restaurant) {
          return DropdownMenuItem<Restaurant>(
            value: restaurant,
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.04,
                  backgroundImage: CachedNetworkImageProvider(restaurant.logoUrl),
                ),
                const SizedBox(width: 10),
                Text(restaurant.name, style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.black87)),
              ],
            ),
          );
        }).toList(),
        elevation: 4, 
        isExpanded: true, 
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black87), 
        underline: const SizedBox(),
        itemHeight: 60, // Fixed size of the dropdown menu
      ),
    );
  }
}
