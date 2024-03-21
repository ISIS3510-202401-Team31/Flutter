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
  final bool
      showCounter; // Nuevo parámetro para controlar la visibilidad del contador de caracteres

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
    this.showCounter = true, // Se inicializa como true por defecto
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(screenHeight * 0.002),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLength: widget.maxLength, // Establece el máximo número de caracteres
        style: TextStyle(
            fontSize: screenHeight * 0.017), // Ajustar el tamaño de la fuente
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(fontSize: screenHeight * 0.015),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: screenHeight * 0.015),
          prefixIcon: IconTheme(
            data: IconThemeData(
                size: screenHeight * 0.025), // Ajustar el tamaño del icono
            child: widget.icon,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  iconSize: screenHeight * 0.025, // Tamaño del icono del ojito
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
          counterText: widget.showCounter
              ? null
              : '', // Controla la visibilidad del contador
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
