import 'package:flutter/material.dart';
import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/restaurant/detail/widgets/menu_section/plate_card.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';

class MenuGrid extends StatefulWidget {
  final String restaurantId;
  final List<Plate> menuItems;

  const MenuGrid(
      {Key? key, required this.menuItems, required this.restaurantId})
      : super(key: key);

  @override
  _MenuGridState createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  bool isGridVisible = true;

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

    return GestureDetector(
      onTap: () {
        _onUserInteraction("Plates Grid", "Tap");
      },
      child: SizedBox(
        width: screenWidth * 0.9,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.075, vertical: screenHeight * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: screenHeight * 0.0225,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomCircledButton(
                    onPressed: () {
                      setState(() {
                        isGridVisible = !isGridVisible;
                      });
                      _onUserInteraction("Plates Grid", "Tap");
                    },
                    diameter: screenHeight * 0.0025,
                    icon: Icon(
                      isGridVisible
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
                visible: isGridVisible,
                child: widget.menuItems.isNotEmpty
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: widget.menuItems.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = widget.menuItems[index];
                          return PlateCard(
                            id: item.id,
                            restaurantId: widget.restaurantId,
                            imagePath: item.imagePath,
                            name: item.name,
                            description: item.description,
                            price: item.price,
                          );
                        },
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.025),
                        child: Text(
                          'No menu items available',
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
      ),
    );
  }
}
