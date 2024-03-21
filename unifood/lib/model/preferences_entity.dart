class PreferencesEntity {
  final List<PreferenceItem> restrictions;
  final List<PreferenceItem> tastes;
  final PriceRange priceRange;
  PreferencesEntity({
    required this.restrictions,
    required this.tastes,
    required this.priceRange,
  });
  factory PreferencesEntity.fromMap(Map<String, dynamic> map) {
    List<PreferenceItem> convert(Map<String, dynamic> items) {
      List<PreferenceItem> list = [];
      items.forEach((key, value) {
        if (!key.endsWith('text') && value is String) {
          var textKey = '${key}text';
          var textValue = items[textKey];
          if (textValue is String) {
            list.add(PreferenceItem(imageUrl: value, text: textValue));
          }
        }
      });
      return list;
    }

    Map<String, dynamic> restrictionsMap =
        Map<String, dynamic>.from(map['Restrictions'] ?? {});
    Map<String, dynamic> tastesMap =
        Map<String, dynamic>.from(map['tastes'] ?? {});
    Map<String, dynamic> priceRangeMap =
        Map<String, dynamic>.from(map['priceRange'] ?? {});

    return PreferencesEntity(
      restrictions: convert(restrictionsMap),
      tastes: convert(tastesMap),
      priceRange: PriceRange.fromMap(priceRangeMap),
    );
  }
}

class PriceRange {
  final int minPrice;
  final int maxPrice;
  PriceRange({
    required this.minPrice,
    required this.maxPrice,
  });
  Map<String, dynamic> toMap() {
    return {
      'minPrice': minPrice,
      'maxPrice': maxPrice,
    };
  }

  factory PriceRange.fromMap(Map<String, dynamic> map) {
    return PriceRange(
      minPrice: map['minPrice'] ?? 0,
      maxPrice: map['maxPrice'] ?? 0,
    );
  }
}

class PreferenceItem {
  final String imageUrl;
  final String text;
  PreferenceItem({
    required this.imageUrl,
    required this.text,
  });
}
