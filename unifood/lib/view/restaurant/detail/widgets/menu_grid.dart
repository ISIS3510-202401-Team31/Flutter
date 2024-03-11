import 'package:flutter/material.dart';
import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/view/restaurant/detail/widgets/plate_card.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';
import 'package:unifood/view_model/plate_view_model.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                  Navigator.pushNamed(context, '/landing');
                },
                diameter: 28,
                icon: const Icon(
                  Icons.chevron_right_sharp,
                  color: Colors.black,
                ),
                buttonColor: Colors.white,
              ),
            ],
          ),
          FutureBuilder<List<Plate>>(
            future: PlateViewModel().getMenuItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    Text('Error: ${snapshot.error}'),
                    ElevatedButton(
                      onPressed: () {
                        // Retry fetching data
                        PlateViewModel().getMenuItems();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final menuItems = snapshot.data!;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: menuItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return PlateCard(
                      imagePath: item.imagePath,
                      name: item.name,
                      description: item.description,
                      price: item.price,
                    );
                  },
                );
              } else {
                return const Text('No menu items available.');
              }
            },
          ),
        ],
      ),
    );
  }
}
