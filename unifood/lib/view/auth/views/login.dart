import 'package:flutter/material.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/auth_repositorydart';
import 'package:unifood/view/widgets/custom_appbar.dart';
import 'package:unifood/view/widgets/custom_button.dart';
import 'package:unifood/view/auth/widgets/custom_textformfield.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                        fontSize: 15),
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
                  CustomTextFormField(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'Type your email here',
                    icon: Icon(Icons.email),
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Type your password here',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    onPressed: () async {
                      Users? user = await Auth().signInWithEmailPassword(
                          emailController.text, passwordController.text);
                      if (user != null) {
                        // El inicio de sesión fue exitoso, navega a la página de restaurantes
                        Navigator.pushNamed(context, '/restaurants');
                      } else {
                        // El inicio de sesión falló, muestra un AlertDialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error de inicio de sesión'),
                            content: Text(
                                'No se pudo iniciar sesión. Por favor, revisa tus credenciales.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Limpiar los campos de texto
                                  emailController.clear();
                                  passwordController.clear();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      }
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
