import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_button.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              const Text(
                'UNIFOOD',
                style: TextStyle(
                    fontFamily: 'KeaniaOne', fontSize: 50, color: Colors.white),
              ),
              const Text(
                'It´s all here',
                style: TextStyle(
                    fontFamily: 'Katibeh', fontSize: 40, color: Colors.white),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                text: 'Login',
                width: 165,
                height: 47,
                fontSize: 24,
                textColor: Colors.white,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                text: 'Sign Up',
                width: 165,
                height: 47,
                fontSize: 24,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
