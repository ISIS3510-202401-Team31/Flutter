import 'package:flutter/material.dart';

class CustomAuthButton extends StatefulWidget {
  final String text;
  final double height;
  final double width;
  final double fontSize;
  final VoidCallback onPressed;
  final Color textColor;

  const CustomAuthButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.height,
    required this.width,
    required this.fontSize,
    required this.textColor,
  }) : super(key: key);

  @override
  _CustomAuthButtonState createState() => _CustomAuthButtonState();
}

class _CustomAuthButtonState extends State<CustomAuthButton> {
  bool _isPressed = false;

  void _handleOnPressed() {
    if (!_isPressed) {
      setState(() {
        _isPressed = true;
      });
      widget.onPressed();
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _isPressed = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = _isPressed ? Colors.grey : const Color(0xFFE2D2B4);

    return ElevatedButton(
      onPressed: _isPressed ? null : _handleOnPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
        foregroundColor: MaterialStateProperty.all<Color>(widget.textColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(widget.width, widget.height)),
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontFamily: 'Gudea',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
