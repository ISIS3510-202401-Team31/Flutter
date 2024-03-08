import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_circled_button.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reviews = [
      {
        'userName': 'Usuario1',
        'rating': '4.5',
        'comment': '¡Muy sabroso! Definitivamente volveré.',
      },
      {
        'userName': 'Usuario2',
        'rating': '5.0',
        'comment': 'Excelente servicio y calidad de comida.',
      },
      // Agrega más elementos según sea necesario
    ];

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: reviews.map((review) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ReviewCard(
                  userName: review['userName'],
                  rating: review['rating'],
                  comment: review['comment'],
                ),
              );
            }).toList(),
          ),
        ]));
  }
}

class ReviewCard extends StatelessWidget {
  final String userName;
  final String rating;
  final String comment;

  const ReviewCard({
    Key? key,
    required this.userName,
    required this.rating,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile_image.jpg'),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Row(
                          children: [
                            Text(
                              rating,
                              style: const TextStyle(
                                  fontSize: 14), // Ajusta el tamaño del texto
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 16, // Ajusta el tamaño del icono
                            ),
                          ],
                                              ),
                        ],
                      ),

                      Text(
                        comment,
                        style: const TextStyle(
                            fontSize: 12), 
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
