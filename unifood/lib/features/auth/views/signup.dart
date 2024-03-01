import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_button.dart';
import 'package:unifood/widgets/custom_circled_button.dart';
import 'package:unifood/widgets/custom_textformfield.dart';

class Signup extends StatelessWidget {
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
                  'Create Account',
                  style: TextStyle(
                    fontSize: 31.0,
                    color: Colors.black,
                    fontFamily: 'Gudea',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Be part of this community!',
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
                SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Full name',
                  hintText: 'Type your email here',
                  icon: Icon(Icons.person),
                  obscureText: false,
                ),
                SizedBox(height: 7),
                CustomTextFormField(
                  labelText: 'Email',
                  hintText: 'Type your email here',
                  icon: Icon(Icons.email),
                  obscureText: false,
                ),
                SizedBox(height: 7),
                CustomTextFormField(
                  labelText: 'Password',
                  hintText: 'Type your password here',
                  icon: Icon(Icons.lock),
                  obscureText: true,
                ),
                SizedBox(height: 7),
                CustomTextFormField(
                  labelText: 'Confirm password',
                  hintText: 'Confirm your password here',
                  icon: Icon(Icons.lock),
                  obscureText: true,
                ),
                SizedBox(height: 7),
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
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontFamily: 'Gudea',
                      ),
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Login',
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
