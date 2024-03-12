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
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomCircledButton(
                  onPressed: () {
                    setState(() {
                      isGridVisible = !isGridVisible;
                    });
                  },
                  diameter: 28,
                  icon: Icon(
                    isGridVisible
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.black,
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
