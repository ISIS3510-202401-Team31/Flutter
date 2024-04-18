import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final bool obscureText;
  final TextEditingController controller;
  final int? maxLength;
  final String? errorMessage;
  final bool hasError;
  final bool showCounter;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    required this.controller,
    this.maxLength,
    this.errorMessage,
    this.hasError = false,
    this.showCounter = true,
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

    // Define el tamaño personalizado de la línea
    const double lineWidth = 2.0;

    // Define el borde personalizado con el ancho de línea personalizado
    final InputBorder border = UnderlineInputBorder(
      borderSide:
          BorderSide(color: Theme.of(context).primaryColor, width: lineWidth),
    );

    return Container(
      padding: EdgeInsets.all(screenHeight * 0.002),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLength: widget.maxLength,
        style: TextStyle(fontSize: screenHeight * 0.017),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(fontSize: screenHeight * 0.017),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: screenHeight * 0.017),
          prefixIcon: IconTheme(
            data: IconThemeData(size: screenHeight * 0.025),
            child: widget.icon,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  iconSize: screenHeight * 0.025,
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          errorText: widget.hasError ? widget.errorMessage : null,
          counterText: widget.showCounter ? null : '',
          //border: border,
          focusedBorder: border,
        ),
        keyboardType: TextInputType.emailAddress,
        obscureText: widget.obscureText ? _obscureText : false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.errorMessage ?? 'Por favor ingrese su email';
          }
          return null;
        },
      ),
    );
  }
}
