import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_circled_button.dart';
import 'package:unifood/widgets/custom_settings_button.dart';
import 'package:unifood/widgets/custom_settings_options.dart';
import 'package:unifood/widgets/custom_settings_options_preferences.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  RangeValues _currentRangeValues = const RangeValues(10000, 80000);

  final List<String> _checkboxTitles = [
    "Recommend Restaurants with Daily Discounts",
    "Only Recommend Healthy Restaurants",
    "Notify Me When I Have Enough Redeemable Points",
    "Show Restaurants Slightly out of my Price Range",
    "Enable Location while not using the app",
  ];

  List<bool> _isChecked = List<bool>.filled(5, false);

PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    flexibleSpace: Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 16, top: 50), // Ajusta el margen según sea necesario
      child: CustomCircledButton(
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
        diameter: 28, 
        icon: Icon(
          Icons.chevron_left_sharp,
          color: Colors.black,
          size: 24, // Reducir el tamaño del icono si es necesario
        ),
        buttonColor: Colors.white,
      ),
    ),
    title: const Text(
      'Preferences',
      style: TextStyle(color: Colors.black),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              sectionHeader(context, 'Dietary Restrictions', 'Modify Restrictions'),
              CustomSettingOptionWithIcons(
                imagePath1: 'assets/vegan.png',
                imagePath2: 'assets/GlutenFree.png',
                imagePath3: 'assets/NutFree.png',
                imagePath4: 'assets/SugarFree.png',
                onPressed: () {},
              ),
              sectionHeader(context, 'Tastes', 'Modify Tastes'),
              CustomSettingOptionWithIcons(
                imagePath1: 'assets/Burgers.png',
                imagePath2: 'assets/Tacos.png',
                imagePath3: 'assets/Pasta.png',
                imagePath4: 'assets/Nuggets.png',
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
      
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center( // Centrar el texto
                          child: Text(
                            'Price Range for Restaurants',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 16), // Espacio debajo del texto, ajusta la altura según necesites
                        // ...resto de tus widgets...
                      ],
                    ),
                    Divider(),
                    Text(
                      'COP ${_currentRangeValues.start.round()} - COP ${_currentRangeValues.end.round()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.grey, // Color de la barra activa
                        inactiveTrackColor: Colors.grey[300], // Color de la barra inactiva
                        trackHeight: 10.0, // Altura de la barra del slider
                        thumbColor: Colors.brown[700], // Color del thumb
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 20.0), // Forma y tamaño del thumb
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0), // Tamaño del overlay del thumb
                      ),
                      child: RangeSlider(
                        values: _currentRangeValues,
                        min: 10000,
                        max: 80000,
                        divisions: 20,
                        labels: RangeLabels(
                          'COP ${_currentRangeValues.start.round()}',
                          'COP ${_currentRangeValues.end.round()}',
                        ),
                        onChanged: (values) {
                          setState(() {
                            _currentRangeValues = values;
                          });
                        },
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...List.generate(_checkboxTitles.length, (index) => CheckboxListTile(
                          title: Text(_checkboxTitles[index]),
                          value: _isChecked[index],
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked[index] = value!;
                            });
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionHeader(BuildContext context, String title, String actionText) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Acción definida para modificar restricciones/gustos
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                actionText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
