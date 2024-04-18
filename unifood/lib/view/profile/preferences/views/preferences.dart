import 'package:flutter/material.dart';
import 'package:unifood/view/profile/preferences/widgets/custom_app_bar.dart';
import 'package:unifood/view/profile/preferences/widgets/price_range_selector.dart';
import 'package:unifood/view/profile/preferences/widgets/section_header.dart';
import 'package:unifood/view/profile/preferences/widgets/save_changes_boton.dart';
import 'package:unifood/view/profile/preferences/widgets/reset_button.dart';
import 'package:unifood/model/preferences_entity.dart';
import 'package:unifood/view_model/preferences_controller.dart';
import 'package:unifood/view/widgets/custom_setting_option_builder.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  RangeValues _currentRangeValues = const RangeValues(10000, 80000);
  final Preferencescontroller _viewModel = Preferencescontroller();

  List<PreferenceItem> _restrictions = [];
  List<PreferenceItem> _tastes = [];
  bool _isEditingRestrictions = false;
  bool _isEditingTastes = false;
  final Set<int> _markedForDeletionRestrictions = <int>{};
  final Set<int> _markedForDeletionTastes = <int>{};

  final String userId = 'dummy_user_id';
  late PreferencesEntity _updatedPreferences;
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    // Attempt to load the common (general) preferences.
    PreferencesEntity? commonPreferences =
        await _viewModel.loadCommonPreferences();

    // Attempt to load the user-specific preferences.
    PreferencesEntity? userPreferences = await _viewModel.loadUserPreferences();

    // Use common preferences as a fallback if specific user preferences are not found.
    // This ensures that preferences are always available, even for new users.
    setState(() {
      // Display restrictions: Use user preferences if available; otherwise, use common preferences.
      _restrictions = userPreferences?.restrictions.isNotEmpty ?? false
          ? _mergePreferencesWithImages(commonPreferences?.restrictions ?? [],
              userPreferences?.restrictions ?? [])
          : commonPreferences?.restrictions ?? [];

      // Display tastes: Use user preferences if available; otherwise, use common preferences.
      _tastes = userPreferences?.tastes.isNotEmpty ?? false
          ? _mergePreferencesWithImages(
              commonPreferences?.tastes ?? [], userPreferences?.tastes ?? [])
          : commonPreferences?.tastes ?? [];

      // Display price range: Use user preferences if available; otherwise, use common preferences.
      _currentRangeValues = userPreferences != null
          ? RangeValues(
              userPreferences.priceRange.minPrice.toDouble(),
              userPreferences.priceRange.maxPrice.toDouble(),
            )
          : commonPreferences != null
              ? RangeValues(
                  commonPreferences.priceRange.minPrice.toDouble(),
                  commonPreferences.priceRange.maxPrice.toDouble(),
                )
              : const RangeValues(0,
                  0); // Fallback to a default range if neither are available.

      // Set the updated preferences model: Use user preferences if available; otherwise, use common preferences.
      _updatedPreferences = userPreferences ??
          commonPreferences ??
          PreferencesEntity(
            restrictions: [],
            tastes: [],
            priceRange: PriceRange(minPrice: 0, maxPrice: 0),
          );
    });

    // If common preferences failed to load, handle the error appropriately.
    if (commonPreferences == null) {
      print("Failed to load common preferences.");
      // Consider implementing additional error handling or user notifications here.
    }
  }

  List<PreferenceItem> _mergePreferencesWithImages(
      List<PreferenceItem> generalPrefs, List<PreferenceItem> userPrefs) {
    Set<String> userPrefsTextSet = userPrefs.map((e) => e.text).toSet();
    return generalPrefs
        .where((item) => userPrefsTextSet.contains(item.text))
        .toList();
  }

  void handleRestoreItem(int index, String type) {
    setState(() {
      if (type == 'restrictions') {
        _markedForDeletionRestrictions.remove(index);
      } else if (type == 'tastes') {
        _markedForDeletionTastes.remove(index);
      }
      _updatePreferencesEntity();
    });
  }

  void _reloadGeneralPreferences() async {
    // Load general (common) preferences without changing the _currentRangeValues
    PreferencesEntity? commonPreferences =
        await _viewModel.loadCommonPreferences();

    if (commonPreferences != null) {
      setState(() {
        _restrictions = commonPreferences.restrictions;
        _tastes = commonPreferences.tastes;
        // Do not update _currentRangeValues here, keeping the user's selected price range
        // _currentRangeValues remains unchanged

        // Optionally reset _updatedPreferences if you want to discard user changes but keep the price range
        _updatedPreferences = PreferencesEntity(
          restrictions: commonPreferences.restrictions,
          tastes: commonPreferences.tastes,
          priceRange: PriceRange(
            minPrice: _currentRangeValues.start.round(),
            maxPrice: _currentRangeValues.end.round(),
          ),
        );
      });
    }
  }

  void handleDeleteItem(int index, String type) {
    setState(() {
      if (type == 'restrictions') {
        _markedForDeletionRestrictions.add(index);
      } else if (type == 'tastes') {
        _markedForDeletionTastes.add(index);
      }
      _updatePreferencesEntity();
    });
  }

  void _updatePreferencesEntity() {
    List<PreferenceItem> updatedRestrictions = [];
    for (int i = 0; i < _restrictions.length; i++) {
      if (!_markedForDeletionRestrictions.contains(i)) {
        updatedRestrictions.add(_restrictions[i]);
      }
    }
    List<PreferenceItem> updatedTastes = [];
    for (int i = 0; i < _tastes.length; i++) {
      if (!_markedForDeletionTastes.contains(i)) {
        updatedTastes.add(_tastes[i]);
      }
    }
    _updatedPreferences = PreferencesEntity(
      restrictions: updatedRestrictions,
      tastes: updatedTastes,
      priceRange: PriceRange(
        minPrice: _currentRangeValues.start.round(),
        maxPrice: _currentRangeValues.end.round(),
      ),
    );
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
              CustomSettingOptionWithIconsBuilder()
                  .setItems(_restrictions)
                  .setIsEditing(_isEditingRestrictions)
                  .setUserId(userId)
                  .setType('restrictions')
                  .setMarkedForDeletion(_markedForDeletionRestrictions)
                  .setOnPressed(() {
                // Your onPressed logic here, if any.
              }).setOnDeleteItem((index, type) {
                if (_isEditingRestrictions) {
                  handleDeleteItem(index, 'restrictions');
                }
              }).setOnRestoreItem((index, type) {
                if (_isEditingRestrictions) {
                  handleRestoreItem(index, 'restrictions');
                }
              }).build(),
              SectionHeader(
                title: 'Tastes',
                actionText: _isEditingTastes ? 'Done' : 'Modify Tastes',
                onTap: () {
                  setState(() {
                    _isEditingTastes = !_isEditingTastes;
                  });
                },
              ),
              CustomSettingOptionWithIconsBuilder()
                  .setItems(_tastes)
                  .setIsEditing(_isEditingTastes)
                  .setUserId(userId)
                  .setType('tastes')
                  .setMarkedForDeletion(_markedForDeletionTastes)
                  .setOnPressed(() {
                // Your onPressed logic here, if any.
              }).setOnDeleteItem((index, type) {
                if (_isEditingTastes) {
                  handleDeleteItem(index, 'tastes');
                }
              }).setOnRestoreItem((index, type) {
                if (_isEditingTastes) {
                  handleRestoreItem(index, 'tastes');
                }
              }).build(),
              ResetWidget(
                onReset: () {
                  _reloadGeneralPreferences();
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
                      _updatePreferencesEntity();
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: const Divider(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SaveChangesButton(
                onPressed: () async {
                  try {
                    await _viewModel.updateUserPreferences(_updatedPreferences);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Preferences updated successfully')),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update preferences')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
