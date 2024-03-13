import 'package:flutter/material.dart';
import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/view/restaurant/detail/widgets/menu_section/plate_card.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';

class MenuGrid extends StatefulWidget {
  final List<Plate> menuItems;

  const MenuGrid({Key? key, required this.menuItems}) : super(key: key);

  @override
  _MenuGridState createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  bool isGridVisible = true;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: screenWidth * 0.075, vertical: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'Menu',
                  style: TextStyle(
                    fontSize:  screenHeight * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomCircledButton(
                  onPressed: () {
                    setState(() {
                      isGridVisible = !isGridVisible;
                    });
                  },
                  diameter: screenHeight * 0.0025,
                  icon: Icon(
                    isGridVisible
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.black,
                    size: screenHeight * 0.03,
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
                          imagePath: item.imagePath,
                          name: item.name,
                          description: item.description,
                          price: item.price,
                        );
                      },
                    )
                  : const Text('No menu items available.'),
            ),
          ],
        ),
      ),
    );
  }
}
