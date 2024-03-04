import 'package:flutter/material.dart';
import 'package:unifood/features/restaurant_detail/widgets/details_bar.dart';
import 'package:unifood/features/restaurant_detail/widgets/location_details.dart';
import 'package:unifood/features/restaurant_detail/widgets/menu_grid.dart';
import 'package:unifood/features/restaurant_detail/widgets/restaurant_info.dart';
import 'package:unifood/features/restaurant_detail/widgets/review_list.dart';
import 'package:unifood/widgets/custom_circled_button.dart';

class RestaurantDetail extends StatelessWidget {
  const RestaurantDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 16, top: 50),
          child: CustomCircledButton(
            onPressed: () {
              Navigator.pushNamed(context, '/landing');
            },
            diameter: 28,
            icon: const Icon(
              Icons.chevron_left_sharp,
              color: Colors.black,
            ),
            buttonColor: Colors.white,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            RestaurantInfo(),

            DetailsBar(),
            
            LocationDetails(),

            MenuGrid(),

            ReviewList(),

          ],
        ),
      ),
    );
  } 
}

