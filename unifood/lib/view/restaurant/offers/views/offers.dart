import 'package:flutter/material.dart';
import 'package:unifood/view/restaurant/offers/widgets/offer_card.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for the offers
    final List<Map<String, dynamic>> offers = [
      {
        'imagePath': 'assets/images/oferta1.png', 
        'mainText': '50% off on Combo Familiar',
        'subText': 'Available until 21/02/2024',
        'points': 100,
      },

            {
        'imagePath': 'assets/images/oferta2.jpg', 
        'mainText': '50% off on Combo Montañero',
        'subText': 'Available until 02/03/2024',
        'points': 10,
      },

      {
        'imagePath': 'assets/images/oferta3.png', 
        'mainText': '50% off on Combo Burrito para 2',
        'subText': 'Available until 12/01/2024',
        'points': 200,
      },
      
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Offers'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/elcarnal_logo.jpeg'),
                    radius: 36,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "El Carnal",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "306-9855122",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            '21',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.favorite, color: Colors.red),
                          Icon(Icons.star, color: Colors.yellow),
                        ],
                      ),
                      Row(
                        children: List.generate(3, (_) => const Icon(
                          Icons.star,
                          color: Colors.black,
                          size: 16,
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0), // Add more vertical padding
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: "You have: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "40 points", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0), // Add more vertical padding
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: "You have redeemed: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "1 offer", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
        
            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8, // Increased aspect ratio
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return OfferCard(
                  imagePath: offer['imagePath'],
                  mainText: offer['mainText'],
                  subText: offer['subText'],
                  points: offer['points'],
                  onRedeem: () {
                    // TODO: Implement redeem action
                  },
                );
              },
            ),
            // You might need to add some padding at the bottom if content is still overflowing
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
