import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_button.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_landing.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
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
              SizedBox(height: 20),
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
