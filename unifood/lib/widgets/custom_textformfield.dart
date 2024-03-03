import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final bool obscureText;

  const CustomTextFormField(
      {super.key, required this.labelText,
      required this.hintText,
      required this.icon,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: PhysicalModel(
          color: Colors.transparent,
          elevation: 3, // Altura del relieve
          borderRadius: BorderRadius.circular(5),
          shadowColor: Colors.white.withOpacity(0.2), // Color de la sombra
          child: TextFormField(
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: icon,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            ),
            keyboardType: TextInputType.emailAddress,
            obscureText: obscureText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su email';
              }
              // Puedes agregar validaciones adicionales aquí
              return null;
            },
            // onChanged: (value) {
            //   // Puedes hacer algo con el valor ingresado
            // },
          )),
    );
  }
}
