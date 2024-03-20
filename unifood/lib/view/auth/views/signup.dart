import 'package:flutter/material.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/auth_repository.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/view/widgets/custom_button.dart';
import 'package:unifood/view/auth/widgets/custom_textformfield.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool fullNameError = false;
  String fullNameErrorMessage = '';

  bool emailError = false;
  String emailErrorMessage = '';

  bool passwordError = false;
  String passwordErrorMessage = '';

  bool confirmPasswordError = false;
  String confirmPasswordErrorMessage = '';

  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.06),
        child: CustomAppBarBuilder(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          showBackButton: true,
        )
            .setRightWidget(
              Container(
                margin: const EdgeInsets.only(right: 0),
                child: Container(
                  padding: EdgeInsets.only(left: screenWidth * 0.03),
                  height: screenHeight * 0.063,
                  width: screenWidth * 0.33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenHeight * 0.01),
                    color: const Color(0xFF965E4E),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.food_bank, color: Colors.black),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        'UNIFOOD',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'KeaniaOne',
                          fontSize: screenHeight * 0.02,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .build(context),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: screenHeight * 0.03),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: screenHeight * 0.033,
                      color: Colors.black,
                      fontFamily: 'Inika',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Be part of this community!',
                    style: TextStyle(
                      fontSize: screenHeight * 0.017,
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
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextFormField(
                    controller: fullNameController,
                    labelText: 'Full name',
                    hintText: 'Type your full name here',
                    icon: const Icon(Icons.person),
                    obscureText: false,
                    maxLength: 50,
                    hasError: fullNameError,
                    errorMessage: fullNameErrorMessage,
                  ),
                  SizedBox(height: screenHeight * 0.007),
                  CustomTextFormField(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'Type your email here',
                    icon: const Icon(Icons.email),
                    obscureText: false,
                    maxLength: 50,
                    hasError: emailError,
                    errorMessage: emailErrorMessage,
                  ),
                  SizedBox(height: screenHeight * 0.007),
                  CustomTextFormField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Type your password here',
                    icon: const Icon(Icons.lock),
                    obscureText: true,
                    maxLength: 16,
                    hasError: passwordError,
                    errorMessage: passwordErrorMessage,
                  ),
                  SizedBox(height: screenHeight * 0.007),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm password',
                    hintText: 'Confirm your password here',
                    icon: const Icon(Icons.lock),
                    obscureText: true,
                    maxLength: 16,
                    hasError: confirmPasswordError,
                    errorMessage: confirmPasswordErrorMessage,
                  ),
                  SizedBox(height: screenHeight * 0.007),
                  CustomButton(
                    onPressed: () async {
                      String fullName = fullNameController.text;
                      String email = emailController.text;
                      String password = passwordController.text;
                      String confirmPassword = confirmPasswordController.text;

                      // Reset errors
                      setState(() {
                        fullNameError = false;
                        emailError = false;
                        passwordError = false;
                        confirmPasswordError = false;
                      });

                      // Validate fields
                      bool isValid = true;
                      if (fullName.isEmpty) {
                        setState(() {
                          fullNameError = true;
                          fullNameErrorMessage = 'Please enter your full name';

                          isValid = false;
                        });
                      }

                      if (email.isEmpty) {
                        setState(() {
                          emailError = true;
                          emailErrorMessage = 'Please enter an email';
                          isValid = false;
                        });
                      } else if (!email.endsWith('@uniandes.edu.co')) {
                        setState(() {
                          emailError = true;
                          emailErrorMessage =
                              'Email must be of the domain @uniandes.edu.co.';
                        });
                      }

                      if (password.isEmpty) {
                        setState(() {
                          passwordError = true;
                          passwordErrorMessage = 'Please enter your password';
                          isValid = false;
                        });
                      } else if (!_isPasswordValid(password)) {
                        setState(() {
                          passwordError = true;
                          passwordErrorMessage =
                              'Password must have at least 8 characters, one uppercase, one lowercase, and one special character.';
                          isValid = false;
                        });
                      }

                      if (confirmPassword.isEmpty) {
                        setState(() {
                          confirmPasswordError = true;
                          confirmPasswordErrorMessage =
                              'Please confirm your password';
                          isValid = false;
                        });
                      } else if (confirmPassword != password) {
                        setState(() {
                          confirmPasswordError = true;
                          confirmPasswordErrorMessage =
                              'Passwords do not match';
                          isValid = false;
                        });
                      }

                      if (!isValid) return;

                      Users? user = await Auth().signUpWithEmailPassword(
                        fullName,
                        email,
                        password,
                      );

                      if (user != null) {
                        // Navigate to login page after successful sign up
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        // Handle sign up failure
                        // For example, display an error message
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sign Up Failed'),
                            content: const Text(
                              'Failed to sign up. Please try again later.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Clear text fields
                                  fullNameController.clear();
                                  emailController.clear();
                                  passwordController.clear();
                                  confirmPasswordController.clear();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    text: 'Sign Up',
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.051,
                    fontSize: screenWidth * 0.045,
                    textColor: Colors.black,
                  ),
                  SizedBox(height: screenHeight * 0.045),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: Colors.black,
                          fontFamily: 'Gudea',
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.009),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            color: const Color(0xFF965E4E),
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
