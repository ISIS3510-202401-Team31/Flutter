import 'package:flutter/material.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/auth_repositorydart';
import 'package:unifood/view/widgets/custom_appbar.dart';
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
        child: CustomAppBar(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          showBackButton: true,
          rightWidget: Container(
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
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
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
                  CustomTextFormField(
                    controller: fullNameController,
                    labelText: 'Full name',
                    hintText: 'Type your full name here',
                    icon: Icon(Icons.person),
                    obscureText: false,
                    maxLength: 50,
                    hasError: fullNameError,
                    errorMessage: fullNameErrorMessage,
                  ),
                  SizedBox(height: 7),
                  CustomTextFormField(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'Type your email here',
                    icon: Icon(Icons.email),
                    obscureText: false,
                    maxLength: 50,
                    hasError: emailError,
                    errorMessage: emailErrorMessage,
                  ),
                  SizedBox(height: 7),
                  CustomTextFormField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Type your password here',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                    maxLength: 16,
                    hasError: passwordError,
                    errorMessage: passwordErrorMessage,
                  ),
                  SizedBox(height: 7),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm password',
                    hintText: 'Confirm your password here',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                    maxLength: 16,
                    hasError: confirmPasswordError,
                    errorMessage: confirmPasswordErrorMessage,
                  ),
                  SizedBox(height: 7),
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
                            title: Text('Sign Up Failed'),
                            content: Text(
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
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
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
