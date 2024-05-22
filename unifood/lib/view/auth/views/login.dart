import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/auth_repository.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/view/auth/widgets/custom_textformfield.dart';
import 'package:unifood/view/widgets/custom_auth_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late bool _isConnected;

  // ignore: unused_field
  late StreamSubscription _connectivitySubscription;
  final Stopwatch _stopwatch = Stopwatch();

  bool emailError = false;
  bool passwordError = false;
  String? emailErrorMessage;
  String? passwordErrorMessage;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _checkConnectivity();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _stopwatch.stop();
    debugPrint(
        'Time spent on the page: ${_stopwatch.elapsed.inSeconds} seconds');
    AnalyticsRepository().saveScreenTime(
        {'screen': 'Login', 'time': _stopwatch.elapsed.inSeconds});
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.13),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: screenHeight * 0.033,
                        color: Colors.black,
                        fontFamily: 'Inika',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Please sign in to continue',
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
                    SizedBox(height: screenHeight * 0.04),
                    CustomTextFormField(
                      controller: emailController,
                      labelText: 'Email',
                      hintText: 'Type your email here',
                      icon: const Icon(Icons.email),
                      obscureText: false,
                      maxLength: 50,
                      errorMessage: emailError ? emailErrorMessage : null,
                      hasError: emailError,
                      showCounter: false,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextFormField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: 'Type your password here',
                      icon: const Icon(Icons.lock),
                      obscureText: true,
                      maxLength: 16,
                      errorMessage: passwordError ? passwordErrorMessage : null,
                      hasError: passwordError,
                      showCounter: false,
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    CustomAuthButton(
                      onPressed: () async {
                        if (_isConnected) {
                          setState(() {
                            emailError = false;
                            passwordError = false;
                          });

                          bool isValid = true;
                          if (emailController.text.isEmpty) {
                            setState(() {
                              emailError = true;
                              emailErrorMessage = 'Please enter your email';
                            });
                            isValid = false;
                          }

                          if (passwordController.text.isEmpty) {
                            setState(() {
                              passwordError = true;
                              passwordErrorMessage =
                                  'Please enter your password';
                            });
                            isValid = false;
                          }

                          if (!isValid) return;

                          Users? user = await Auth().signInWithEmailPassword(
                            emailController.text,
                            passwordController.text,
                          );
                          if (user != null) {
                            Navigator.pushNamed(context, '/restaurants');
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error de inicio de sesión'),
                                content: const Text(
                                  'Failed to sign in. Please check your credentials.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      emailController.clear();
                                      passwordController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          // No hay conexión a Internet, mostrar un diálogo
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('No Internet'),
                              content: const Text(
                                  'You cannot log in without internet connection. Please try again later.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      text: 'Login',
                      width: screenWidth * 0.35,
                      height: screenHeight * 0.051,
                      fontSize: screenWidth * 0.045,
                      textColor: Colors.black,
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member yet?',
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            color: Colors.black,
                            fontFamily: 'Gudea',
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.009),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: const Color(0xFF965E4E),
                              fontFamily: 'Gudea',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
