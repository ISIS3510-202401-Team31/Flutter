import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_button.dart';
import 'package:unifood/widgets/custom_textformfield.dart';
import 'package:unifood/widgets/custom_circled_button.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                    'Login',
                    style: TextStyle(
                      fontSize: 31.0,
                      color: Colors.black,
                      fontFamily: 'Inika',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Please sign in to continue',
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
                  const SizedBox(height: 40),
                  const CustomTextFormField(
                    labelText: 'Email',
                    hintText: 'Type your email here',
                    icon: Icon(Icons.email),
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  const CustomTextFormField(
                    labelText: 'Password',
                    hintText: 'Type your password here',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/homepage');
                    },
                    text: 'Login',
                    width: 151,
                    height: 41,
                    fontSize: 18,
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomCircledButton(
                        onPressed: () {},
                        diameter: 36,
                        icon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        buttonColor: const Color(0xFFE2D2B4),
                      ),
                      CustomCircledButton(
                        onPressed: () {},
                        diameter: 36,
                        icon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        buttonColor: const Color(0xFFE2D2B4),
                      )
                    ],
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member yet?',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                          fontFamily: 'Gudea',
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 17.0,
                              color: Color(0xFF965E4E),
                              fontFamily: 'Gudea',
                              fontWeight: FontWeight.bold),
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
