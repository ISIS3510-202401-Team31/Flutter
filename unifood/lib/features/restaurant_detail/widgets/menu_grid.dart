import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unifood/widgets/custom_circled_button.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'name': 'Combo Familiar',
        'description': 'Descripción del Plato 1',
        'price': 5.99
      },
      {
        'name': 'Combo Familiar',
        'description': 'Descripción del Plato 1 aaaaaaaaaaaaaaaaaaaaa',
        'price': 5.99
      },
      {
        'name': 'Combo Familiar',
        'description': 'Descripción del Plato 1',
        'price': 5.99
      },
      {
        'name': 'Combo Familiar',
        'description': 'Descripción del Plato 1',
        'price': 5.99
      },
      // Agrega más elementos según sea necesario
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Menú',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
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
          GridView.builder(
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
          
              return Card(
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.5, // Adjust as needed
                      child: Image.asset(
                        'assets/elcarnal_image.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                            child: Text(
                              item['description'],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '\$${item['price'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
