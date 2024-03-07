import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: icon,
          border: UnderlineInputBorder(), // Usa UnderlineInputBorder aquí
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          // Para personalizar el color de la línea cuando el campo está enfocado, usa focusedBorder
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
      ),
    );
  }
}
