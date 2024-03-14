import 'package:flutter/material.dart';
import 'package:unifood/view/restaurant/offers/widgets/offer_card.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;


    double titleFontSize = screenWidth < 350 ? 16 : 18;
    double subTitleFontSize = screenWidth < 350 ? 12 : 14;
    double pointsFontSize = screenWidth < 350 ? 20 : 22;

    EdgeInsets padding = screenWidth < 350
        ? const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 8.0)
        : const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0);
    EdgeInsets gridPadding = screenWidth < 350
        ? const EdgeInsets.all(8)
        : const EdgeInsets.all(10);

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
              padding: padding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/elcarnal_logo.jpeg'),
                    radius: 36,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "El Carnal",
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "306-9855122",
                          style: TextStyle(
                            fontSize: subTitleFontSize,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children:  [
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
              padding: padding,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: pointsFontSize,
                    color: Colors.black,
                  ),
                  children: const <TextSpan>[
                    TextSpan(text: "You have: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "40 points", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: padding,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: pointsFontSize,
                    color: Colors.black,
                  ),
                  children: const <TextSpan>[
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
              padding: gridPadding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth < 600 ? 2 : 3, 
                childAspectRatio: 0.75, 
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
                  onRedeem: () {},
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
