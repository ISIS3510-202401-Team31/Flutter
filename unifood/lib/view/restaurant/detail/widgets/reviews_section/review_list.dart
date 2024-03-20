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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
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
                  'Reviews',
                  style: TextStyle(
                    fontSize: screenHeight * 0.0225,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomCircledButton(
                  onPressed: () {
                    setState(() {
                      areReviewsVisible = !areReviewsVisible;
                    });
                  },
                  diameter: screenHeight * 0.005,
                  icon: Icon(
                    areReviewsVisible
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
              visible: areReviewsVisible,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (widget.reviews.isNotEmpty) // Mostrar solo si hay reviews
                    ...widget.reviews.map((review) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.005),
                        child: ReviewCard(
                          userImage: review.userImage,
                          name: review.name,
                          rating: review.rating,
                          comment: review.comment,
                        ),
                      );
                    }).toList(),
                  if (widget.reviews.isEmpty) // Mostrar si no hay reviews
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                      child: Text(
                        'No reviews available',
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
