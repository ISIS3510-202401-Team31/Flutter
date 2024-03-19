import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final bool obscureText;
  final TextEditingController controller;
  final int? maxLength; // Propiedad para el máximo número de caracteres
  final String? errorMessage; // Nuevo parámetro para el mensaje de error
  final bool hasError; // Nuevo parámetro para indicar si hay un error

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    required this.controller,
    this.maxLength, // Se añade como argumento opcional
    this.errorMessage, // Se añade como argumento opcional
    this.hasError = false, // Se inicializa como false por defecto
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLength: widget.maxLength, // Establece el máximo número de caracteres
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          prefixIcon: widget.icon,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          errorText: widget.hasError
              ? widget.errorMessage
              : null, // Muestra el mensaje de error si hay un error
          border: const UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        obscureText: widget.obscureText ? _obscureText : false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.errorMessage ??
                'Por favor ingrese su email'; // Mensaje de error personalizado
          }
          // Puedes agregar validaciones adicionales aquí
          return null;
        },
      ),
    );
  }
}
