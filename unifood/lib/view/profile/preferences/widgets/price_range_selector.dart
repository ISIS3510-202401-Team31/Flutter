import 'package:flutter/material.dart';

class PriceRangeSelector extends StatefulWidget {
  final RangeValues currentRangeValues;
  final Function(RangeValues) onChanged;

  const PriceRangeSelector({
    Key? key,
    required this.currentRangeValues,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PriceRangeSelectorState createState() => _PriceRangeSelectorState();
}

class _PriceRangeSelectorState extends State<PriceRangeSelector> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double thumbRadius = width * 0.05; // Ajuste del tamaño del thumb según el ancho de la pantalla
    double overlayRadius = thumbRadius * 1.5; // Ajuste del tamaño del overlay

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'COP ${widget.currentRangeValues.start.round()} - COP ${widget.currentRangeValues.end.round()}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: width * 0.04, // Ajusta el tamaño de la fuente según el ancho de la pantalla
            fontWeight: FontWeight.bold,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.grey,
            inactiveTrackColor: Colors.grey[300],
            trackHeight: 10.0,
            thumbColor: Colors.brown[700],
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: thumbRadius),
            overlayShape: RoundSliderOverlayShape(overlayRadius: overlayRadius),
          ),
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
            },
          ),
        ),
      ],
    );
  }
}
