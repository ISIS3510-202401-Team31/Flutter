import 'package:flutter/material.dart';
import 'package:unifood/model/offer_entity.dart';  
import 'package:unifood/model/restaurant_entity.dart'; // Assuming you have this file
import 'package:unifood/view/restaurant/offers/widgets/offer_card.dart';
import 'package:unifood/controller/offers_controller.dart';  

class OffersPage extends StatelessWidget {
  final String restaurantId;  // Identifier for the restaurant
  const OffersPage({Key? key, required this.restaurantId}) : super(key: key);

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

    OffersController offersController = OffersController();  // Controller instance

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Offers'),
        centerTitle: true,
      ),
      body: FutureBuilder<Restaurant>(
        future: offersController.getRestaurantInformationById(restaurantId),
        builder: (context, restaurantSnapshot) {
          if (restaurantSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (restaurantSnapshot.hasError) {
            return Text('Error: ${restaurantSnapshot.error}');
          } else if (restaurantSnapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
                  Padding(
                    padding: padding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(restaurantSnapshot.data!.logoUrl),
                          radius: 36,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurantSnapshot.data!.name,
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                restaurantSnapshot.data!.phoneNumber,
                                style: TextStyle(
                                  fontSize: subTitleFontSize,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: List.generate(4, (_) => const Icon(
                                Icons.star,
                                color: Colors.yellow,
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
                          TextSpan(text: "50 points", style: TextStyle(color: Colors.grey)),
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
                  FutureBuilder<List<Offer>>(
                    future: offersController.getOffersByRestaurantId(restaurantId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: gridPadding,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: screenWidth < 600 ? 2 : 3,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Offer offer = snapshot.data![index];
                            return OfferCard(
                              imagePath: offer.imagePath,
                              mainText: offer.mainText,
                              subText: offer.subText,
                              points: offer.points,
                              onRedeem: () {},
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No offers available.'));
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No restaurant data available.'));
          }
        },
      ),
    );
  }
}
