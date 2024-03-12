import 'package:flutter/material.dart';
import 'package:unifood/model/review_entity.dart';
import 'package:unifood/view/restaurant/detail/widgets/reviews_section/review_card.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';

class ReviewList extends StatefulWidget {
  final List<Review> reviews;

  const ReviewList({Key? key, required this.reviews}) : super(key: key);

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  bool areReviewsVisible = true;

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
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomCircledButton(
                onPressed: () {
                  setState(() {
                    areReviewsVisible = !areReviewsVisible;
                  });
                },
                diameter: 28,
                icon: Icon(
                  areReviewsVisible
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: Colors.black,
                ),
                buttonColor: Colors.white,
              ),
            ],
          ),
          Visibility(
            visible: areReviewsVisible,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.reviews.map((review) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ReviewCard(
                    userImage: review.userImage,
                    name: review.name,
                    rating: review.rating,
                    comment: review.comment,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
