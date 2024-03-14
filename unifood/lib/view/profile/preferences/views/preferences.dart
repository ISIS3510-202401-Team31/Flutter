import 'package:flutter/material.dart';
import 'package:unifood/view/profile/preferences/widgets/custom_settings_options_preferences.dart';
import 'package:unifood/view/profile/preferences/widgets/custom_app_bar.dart';
import 'package:unifood/view/profile/preferences/widgets/price_range_selector.dart';
import 'package:unifood/view/profile/preferences/widgets/section_header.dart';
import 'package:unifood/view/profile/preferences/widgets/settings_checkbox_list.dart';

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

  final List<bool> _isChecked = List<bool>.filled(5, false);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeTitle = screenWidth * 0.045; // Ajuste dinámico del tamaño de la fuente

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionHeader(title: 'Dietary Restrictions', actionText: 'Modify Restrictions', onTap: () {}),
              CustomSettingOptionWithIcons(
                imagePaths: const [
                  'assets/images/vegan.png',
                  'assets/images/GlutenFree.png',
                  'assets/images/NutFree.png',
                  'assets/images/SugarFree.png',
                  'assets/images/GlutenFree.png', 
                ],
                texts: const [
                  'VEGAN',
                  'GLUTEN FREE',
                  'NUT FREE',
                  'SUGAR FREE',
                  'EXTRA', 
                ],
                onPressed: () {},
              ),
              SectionHeader(title: 'Tastes', actionText: 'Modify Tastes', onTap: () {}),
              CustomSettingOptionWithIcons(
                imagePaths: const [
                  'assets/images/Burgers.png',
                  'assets/images/Tacos.png',
                  'assets/images/Pasta.png',
                  'assets/images/Nuggets.png',
                  'assets/images/Tacos.png', 
                ],
                texts: const [
                  'BURGERS',
                  'TACOS',
                  'PASTA',
                  'NUGGETS',
                  'EXTRA TACOS', 
                ],
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Price Range for Restaurants',
                  style: TextStyle(
                    fontSize: fontSizeTitle, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Agregar Divider con Padding para margen
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Margen horizontal para el Divider
                child: Divider(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: PriceRangeSelector(
                  currentRangeValues: _currentRangeValues,
                  onChanged: (values) {
                    setState(() {
                      _currentRangeValues = values;
                    });
                  },
                ),
              ),
              // Agregar otro Divider con Padding para margen antes de SettingsCheckboxList
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Margen horizontal para el Divider
                child: Divider(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SettingsCheckboxList(checkboxTitles: _checkboxTitles, isChecked: _isChecked),
            ],
          ),
        ),
      ),
    );
  }
}
