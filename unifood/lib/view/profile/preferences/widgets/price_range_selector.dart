import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PriceRangeSelector extends StatefulWidget {
  final RangeValues currentRangeValues;
  final Function(RangeValues) onChanged;
  final bool isConnected;

  const PriceRangeSelector({
    Key? key,
    required this.currentRangeValues,
    required this.onChanged,
    required this.isConnected,
  }) : super(key: key);

  @override
  _PriceRangeSelectorState createState() => _PriceRangeSelectorState();
}

class _PriceRangeSelectorState extends State<PriceRangeSelector> {
  late SliderThemeData _cachedSliderTheme;
  late RangeValues _cachedRangeValues;

  @override
  void initState() {
    super.initState();
    _loadCachedThemeAndValues();
  }

  Future<void> _loadCachedThemeAndValues() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Color activeTrackColor = Color(prefs.getInt('activeTrackColor') ?? Colors.grey.value);
    Color inactiveTrackColor = Color(prefs.getInt('inactiveTrackColor') ?? Colors.grey[300]!.value);
    double trackHeight = prefs.getDouble('trackHeight') ?? 10.0;

    _cachedSliderTheme = SliderTheme.of(context).copyWith(
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: inactiveTrackColor,
      trackHeight: trackHeight,
    );

    double startValue = prefs.getDouble('startValue') ?? widget.currentRangeValues.start;
    double endValue = prefs.getDouble('endValue') ?? widget.currentRangeValues.end;
    _cachedRangeValues = RangeValues(startValue, endValue);
  }
  Future<void> _cacheThemeAndValuesData(SliderThemeData theme, RangeValues values) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('activeTrackColor', theme.activeTrackColor?.value ?? Colors.grey.value);
    await prefs.setInt('inactiveTrackColor', theme.inactiveTrackColor?.value ?? Colors.grey[300]!.value);
    await prefs.setDouble('trackHeight', theme.trackHeight ?? 10.0);
    await prefs.setDouble('startValue', values.start);
    await prefs.setDouble('endValue', values.end);
  }

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double thumbRadius = width * 0.05;
    double overlayRadius = thumbRadius * 1.5;

    if (!widget.isConnected) {
      // Display cached values if no connection
      return _buildSliderWithCachedValues(context);
    } else {
      return _buildConnectedSlider(context);
    }
  }

  Widget _buildConnectedSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COP ${widget.currentRangeValues.start.round()} - COP ${widget.currentRangeValues.end.round()}',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SliderTheme(
          data: _cachedSliderTheme,
          child: RangeSlider(
            values: widget.currentRangeValues,
            min: 10000,
            max: 80000,
            labels: RangeLabels(
              'COP ${widget.currentRangeValues.start.round()}',
              'COP ${widget.currentRangeValues.end.round()}',
            ),
            onChanged: (values) {
              RangeValues newValues = RangeValues(
                (values.start / 500).round() * 500.toDouble(),
                (values.end / 500).round() * 500.toDouble(),
              );
              widget.onChanged(newValues);
              _cacheThemeAndValuesData(_cachedSliderTheme, newValues);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSliderWithCachedValues(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COP ${_cachedRangeValues.start.round()} - COP ${_cachedRangeValues.end.round()}',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SliderTheme(
          data: _cachedSliderTheme,
          child: RangeSlider(
            values: _cachedRangeValues,
            min: 10000,
            max: 80000,
            labels: RangeLabels(
              'COP ${_cachedRangeValues.start.round()}',
              'COP ${_cachedRangeValues.end.round()}',
            ),
            onChanged: null,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: const Text('No Connection. Try again Later', 
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ),
      ],
    );
  }
}
