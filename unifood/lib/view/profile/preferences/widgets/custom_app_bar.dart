import 'package:flutter/material.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart'; // Asegúrate de que la ruta sea correcta

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usando MediaQuery para adaptar el tamaño y el margen
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Ajusta el tamaño del botón y el icono basado en el tamaño de la pantalla
    double buttonDiameter = screenHeight * 0.04;
    double iconSize = buttonDiameter * 0.85;

    // Ajusta el margen superior y el tamaño de la fuente del título
    double topMargin = screenHeight * 0.07;
    double titleFontSize = screenWidth * 0.05;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      flexibleSpace: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 16, top: topMargin), // Margen ajustado con MediaQuery
        child: CustomCircledButton(
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
          diameter: buttonDiameter, // Diámetro ajustado con MediaQuery
          icon: Icon(
            Icons.chevron_left_sharp,
            color: Colors.black,
            size: iconSize, // Tamaño del icono ajustado con MediaQuery
          ),
          buttonColor: Colors.white,
        ),
      ),
      title: Text(
        'Preferences',
        style: TextStyle(
          color: Colors.black,
          fontSize: titleFontSize, // Tamaño de la fuente del título ajustado con MediaQuery
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
