import 'package:flutter/material.dart';
import 'package:unifood/view/profile/preferences/widgets/custom_settings_options_preferences.dart';
import 'package:unifood/view/profile/preferences/widgets/custom_app_bar.dart';
import 'package:unifood/view/profile/preferences/widgets/price_range_selector.dart';
import 'package:unifood/view/profile/preferences/widgets/section_header.dart';
import 'package:unifood/view/profile/preferences/widgets/settings_checkbox_list.dart';
import 'package:unifood/model/preferences_entity.dart';
import 'package:unifood/view_model/preferences_view_model.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  RangeValues _currentRangeValues = const RangeValues(10000, 80000);
  final PreferencesViewModel _viewModel = PreferencesViewModel();

  // Add a list for each of the preference types to hold the items.
  List<PreferenceItem> _restrictions = [];
  List<PreferenceItem> _tastes = [];
  bool _isEditingRestrictions = false;
  bool _isEditingTastes = false;
  final List<String> _checkboxTitles = [
    "Recommend Restaurants with Daily Discounts",
    "Only Recommend Healthy Restaurants",
    "Notify Me When I Have Enough Redeemable Points",
    "Show Restaurants Slightly out of my Price Range",
    "Enable Location while not using the app",
  ];

  final List<bool> _isChecked = List<bool>.filled(5, false);

  // Dummy user ID for example purposes, replace with the actual user ID as needed.
  final String userId = 'dummy_user_id';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    var preferences = await _viewModel.loadCommonPreferences();
    if (preferences != null) {
      setState(() {
        _restrictions = preferences.restrictions;
        _tastes = preferences.tastes;
        _currentRangeValues = RangeValues(
          preferences.priceRange.minPrice.toDouble(),
          preferences.priceRange.maxPrice.toDouble(),
        );
      });
    }
  }

  void handleDeleteItem(int index, String type) async {
    setState(() {
      if (type == 'restrictions') {
        _restrictions.removeAt(index);
      } else if (type == 'tastes') {
        _tastes.removeAt(index);
      }
    });

    PriceRange currentPriceRange = PriceRange(
      minPrice: _currentRangeValues.start
          .round(), // Assuming _currentRangeValues is a RangeValues object
      maxPrice: _currentRangeValues.end.round(),
    );

    PreferencesEntity updatedPreferences = PreferencesEntity(
      restrictions: _restrictions,
      tastes: _tastes,
      priceRange: currentPriceRange,
    );

    try {
      await _viewModel.updateUserPreferences(userId, updatedPreferences);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preference updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update preferences')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionHeader(
                title: 'Dietary Restrictions',
                actionText:
                    _isEditingRestrictions ? 'Done' : 'Modify Restrictions',
                onTap: () {
                  setState(() {
                    _isEditingRestrictions = !_isEditingRestrictions;
                  });
                },
              ),
              CustomSettingOptionWithIcons(
                items: _restrictions,
                userId: userId,
                onPressed: () {},
                onDeleteItem: (index, type) {
                  if (_isEditingRestrictions) {
                    handleDeleteItem(index, 'restrictions');
                  }
                },
              ),
              SectionHeader(
                title: 'Tastes',
                actionText: _isEditingTastes ? 'Done' : 'Modify Tastes',
                onTap: () {
                  setState(() {
                    _isEditingTastes = !_isEditingTastes;
                  });
                },
              ),
              CustomSettingOptionWithIcons(
                items: _tastes,
                userId: userId,
                onPressed: () {},
                onDeleteItem: (index, type) {
                  if (_isEditingTastes) {
                    handleDeleteItem(index, 'tastes');
                  }
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Price Range for Restaurants',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: const Divider(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: PriceRangeSelector(
                  currentRangeValues: _currentRangeValues,
                  onChanged: (values) {
                    setState(() {
                      _currentRangeValues = values;
                    });
                    // Consider saving the new price range to the database if necessary
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: const Divider(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SettingsCheckboxList(
                checkboxTitles: _checkboxTitles,
                isChecked: _isChecked,
                // Add onChange logic if necessary to save checkbox state
              ),
            ],
          ),
        ),
      ),
    );
  }
}
