class PreferencesEntity {
  final List<PreferenceItem> restrictions;
  final List<PreferenceItem> tastes;
  final PriceRange priceRange;

  PreferencesEntity({
    required this.restrictions,
    required this.tastes,
    required this.priceRange,
  });

  factory PreferencesEntity.fromMap(Map<String, dynamic> map,
      {bool isUserPreferences = false}) {
    List<PreferenceItem> convertListForUser(List<dynamic> list) {
      return list
          .map((item) => PreferenceItem(text: item, imageUrl: ''))
          .toList();
    }

    List<PreferenceItem> convertMapForGeneral(Map<String, dynamic> map) {
      List<PreferenceItem> list = [];
      map.forEach((key, value) {
        if (key != 'text' && value is String) {
          // Assuming the value is always a String URL
          var textKey = '${key}text';
          var textValue = map[
              textKey]; // Retrieve the actual text using 'text' appended key
          if (textValue is String) {
            list.add(PreferenceItem(text: textValue, imageUrl: value));
          }
        }
      });
      return list;
    }

    List<PreferenceItem> restrictions;
    List<PreferenceItem> tastes;

    if (isUserPreferences) {
      restrictions = map['restrictions'] != null
          ? convertListForUser(map['restrictions'])
          : [];
      tastes = map['tastes'] != null ? convertListForUser(map['tastes']) : [];
    } else {
      restrictions = map['Restrictions'] != null
          ? convertMapForGeneral(map['Restrictions'])
          : [];
      tastes = map['tastes'] != null ? convertMapForGeneral(map['tastes']) : [];
    }

    PriceRange priceRange = PriceRange.fromMap(map['priceRange']);

    return PreferencesEntity(
      restrictions: restrictions,
      tastes: tastes,
      priceRange: priceRange,
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

  factory PriceRange.fromMap(Map<String, dynamic> map) {
    return PriceRange(
      minPrice: map['minPrice'] ?? 0,
      maxPrice: map['maxPrice'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'minPrice': minPrice,
      'maxPrice': maxPrice,
    };
  }
}

class PreferenceItem {
  final String imageUrl;
  final String text;

  PreferenceItem({
    required this.imageUrl,
    required this.text,
  });

  factory PreferenceItem.fromMap(Map<String, dynamic> map) {
    return PreferenceItem(
      imageUrl: map['imageUrl'] ?? '', // Providing a default value if null
      text: map['text'], // Assuming 'text' is always provided
    );
  }
}
