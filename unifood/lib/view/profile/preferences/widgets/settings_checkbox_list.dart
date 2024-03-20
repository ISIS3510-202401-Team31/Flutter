import 'package:flutter/material.dart';

class SettingsCheckboxList extends StatefulWidget {
  final List<String> checkboxTitles;
  final List<bool> isChecked;

  const SettingsCheckboxList({
    Key? key,
    required this.checkboxTitles,
    required this.isChecked,
  }) : super(key: key);

  @override
  _SettingsCheckboxListState createState() => _SettingsCheckboxListState();
}

class _SettingsCheckboxListState extends State<SettingsCheckboxList> {
  @override
  Widget build(BuildContext context) {
    // Utilizando MediaQuery para adaptar los tamaños
    double width = MediaQuery.of(context).size.width;
    
    // Ajustes de tamaño basados en el ancho de la pantalla
    double fontSize = width * 0.04; // Ajusta el tamaño de la fuente para los títulos

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings', 
          style: TextStyle(
            fontSize: fontSize, // Usa el tamaño de fuente ajustado
            fontWeight: FontWeight.bold,
          )
        ),
        ...List.generate(widget.checkboxTitles.length, (index) => CheckboxListTile(
              title: Text(
                widget.checkboxTitles[index],
                style: TextStyle(
                  fontSize: fontSize, // Usa el tamaño de fuente ajustado para los títulos de las casillas de verificación
                ),
              ),
              value: widget.isChecked[index],
              onChanged: (bool? value) {
                setState(() {
                  widget.isChecked[index] = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading, // Mantiene el checkbox al inicio del tile
              dense: true, // Reduce el espacio vertical para mantener el estilo compacto
              activeColor: Colors.green,
              checkColor: Colors.white,
            )),
      ],
    );
  }
}
