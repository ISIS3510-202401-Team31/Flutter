import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_button.dart';
import 'package:unifood/widgets/custom_circled_button.dart';
import 'package:unifood/widgets/custom_textformfield.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 0),
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              height: 45,
              width: 138,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF965E4E),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.food_bank, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'UNIFOOD',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'KeaniaOne',
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 31.0,
                      color: Colors.black,
                      fontFamily: 'Inika',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Be part of this community!',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      fontFamily: 'Inika',
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const CustomTextFormField(
                    labelText: 'Full name',
                    hintText: 'Type your email here',
                    icon: Icon(Icons.person),
                    obscureText: false,
                  ),
                  const SizedBox(height: 7),
                  const CustomTextFormField(
                    labelText: 'Email',
                    hintText: 'Type your email here',
                    icon: Icon(Icons.email),
                    obscureText: false,
                  ),
                  const SizedBox(height: 7),
                  const CustomTextFormField(
                    labelText: 'Password',
                    hintText: 'Type your password here',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                  ),
                  const SizedBox(height: 7),
                  const CustomTextFormField(
                    labelText: 'Confirm password',
                    hintText: 'Confirm your password here',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                  ),
                  const SizedBox(height: 7),
                  CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/homepage');
                    },
                    text: 'Sign Up',
                    width: 151,
                    height: 41,
                    fontSize: 18,
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already a member?',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                          fontFamily: 'Gudea',
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Color(0xFF965E4E),
                            fontFamily: 'Gudea',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
