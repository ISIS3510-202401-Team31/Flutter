import 'package:flutter/material.dart';

class SaveChangesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveChangesButton({
    Key? key,
    required this.onPressed, // The onPressed parameter should be a named parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth =
        screenWidth * 0.6; // The button will take 60% of the screen width
    double buttonHeight = 50; // Fixed height for the button

    return Center(
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        margin: EdgeInsets
            .symmetric(), // Centers the button in the middle of the page
        child: ElevatedButton.icon(
          onPressed: onPressed, // Use the named parameter here
          icon: const Icon(Icons.save,
              color: Colors.white), // Changed to a save icon
          label: const Text(
            'Save Changes',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.deepPurple[900], // Dark blue background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // Padding inside the button
          ),
        ),
      ),
    );
  }
}
