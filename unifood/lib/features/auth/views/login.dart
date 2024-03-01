import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_button.dart';
import 'package:unifood/widgets/custom_textformfield.dart';
import 'package:unifood/widgets/custom_circled_button.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 0),
            child: Container(
              padding: EdgeInsets.only(left: 8),
              height: 45,
              width: 138,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF965E4E),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.food_bank, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'UNIFOOD',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 16, top: 50),
          child: CustomCircledButton(
            onPressed: () {
              Navigator.pushNamed(context, '/landing');
            },
            diameter: 28,
            icon: Icon(
              Icons.chevron_left_sharp,
              color: Colors.black,
            ),
            buttonColor: Colors.white,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 31.0,
                    color: Colors.black,
                    fontFamily: 'Gudea',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Please sign in to continue',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                    fontFamily: 'Gudea',
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                CustomTextFormField(
                  labelText: 'Email',
                  hintText: 'Type your email here',
                  icon: Icon(Icons.email),
                  obscureText: false,
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  labelText: 'Password',
                  hintText: 'Type your password here',
                  icon: Icon(Icons.lock),
                  obscureText: true,
                ),
                SizedBox(height: 40),
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
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomCircledButton(
                      onPressed: () {},
                      diameter: 36,
                      icon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      buttonColor: Color(0xFFE2D2B4),
                    ),
                    CustomCircledButton(
                      onPressed: () {},
                      diameter: 36,
                      icon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      buttonColor: Color(0xFFE2D2B4),
                    )
                  ],
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member yet?',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontFamily: 'Gudea',
                      ),
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Color(0xFF965E4E),
                          fontFamily: 'Gudea',
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
    );
  }
}
