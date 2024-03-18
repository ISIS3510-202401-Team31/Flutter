import 'package:flutter/material.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/auth.dart';
import 'package:unifood/view/widgets/custom_appbar.dart';
import 'package:unifood/view/widgets/custom_button.dart';
import 'package:unifood/view/auth/widgets/custom_textformfield.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores para los campos de entrada
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

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
                    controller:
                        fullNameController, // Asigna el controlador al campo de entrada
                    labelText: 'Full name',
                    hintText: 'Type your full name here',
                    icon: Icon(Icons.person),
                    obscureText: false,
                  ),
                  SizedBox(height: 7),
                  CustomTextFormField(
                    controller:
                        emailController, // Asigna el controlador al campo de entrada
                    labelText: 'Email',
                    hintText: 'Type your email here',
                    icon: Icon(Icons.email),
                    obscureText: false,
                  ),
                  SizedBox(height: 7),
                  CustomTextFormField(
                    controller:
                        passwordController, // Asigna el controlador al campo de entrada
                    labelText: 'Password',
                    hintText: 'Type your password here',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                  ),
                  SizedBox(height: 7),
                  CustomTextFormField(
                    controller:
                        confirmPasswordController, // Asigna el controlador al campo de entrada
                    labelText: 'Confirm password',
                    hintText: 'Confirm your password here',
                    icon: Icon(Icons.lock),
                    obscureText: true,
                  ),
                  SizedBox(height: 7),
                  CustomButton(
                    onPressed: () async {
                      String fullName = fullNameController
                          .text; // Obtén el valor del campo de entrada
                      String email = emailController
                          .text; // Obtén el valor del campo de entrada
                      String password = passwordController
                          .text; // Obtén el valor del campo de entrada
                      String confirmPassword = confirmPasswordController
                          .text; // Obtén el valor del campo de entrada

                      if (fullName.isEmpty &&
                          email.isEmpty &&
                          password.isEmpty &&
                          confirmPassword.isEmpty) {
                        // Mostrar una alerta indicando que todos los campos son obligatorios
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('All fields are required.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return; // Salir de la función si todos los campos están vacíos
                      }

                      // Validar la contraseña
                      if (!_isPasswordValid(password)) {
                        // Mostrar una alerta indicando que la contraseña no es válida
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(
                              'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula y un carácter especial.',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return; // Salir de la función si la contraseña no es válida
                      }

                      // Validar que las contraseñas coincidan
                      if (password != confirmPassword) {
                        // Mostrar una alerta indicando que las contraseñas no coinciden
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('Las contraseñas no coinciden.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return; // Salir de la función si las contraseñas no coinciden
                      }

                      // Validar que el correo electrónico sea válido
                      if (!email.endsWith('@uniandes.edu.co')) {
                        // Mostrar una alerta indicando que el correo electrónico no es válido
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(
                              'El correo electrónico debe ser de dominio @uniandes.edu.co.',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return; // Salir de la función si el correo electrónico no es válido
                      }

                      Users? user =
                          await Auth().signUpWithEmailPassword(email, password);
                      if (user != null) {
                        // Si la cuenta se creó exitosamente, muestra un mensaje de éxito
                        _showSuccessDialog('Cuenta creada exitosamente!', context);
                        // Aquí puedes realizar alguna acción adicional, como navegar a otra pantalla
                      } else {
                        // Si la cuenta no se pudo crear, muestra un mensaje de error
                        _showErrorDialog(
                            'Error al crear la cuenta. El correo electrónico ya está en uso o la contraseña no cumple con los requisitos.', context);
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

  // Función para verificar si la contraseña cumple con los requisitos
  bool _isPasswordValid(String password) {
    // Verificar la longitud de la contraseña
    if (password.length < 8) return false;
    // Verificar si la contraseña contiene al menos una mayúscula
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    // Verificar si la contraseña contiene al menos una minúscula
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    // Verificar si la contraseña contiene al menos un carácter especial
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true; // La contraseña cumple con todos los requisitos
  }
}

// Función para mostrar una alerta de éxito
void _showSuccessDialog(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Success'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}

void _showErrorDialog(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}