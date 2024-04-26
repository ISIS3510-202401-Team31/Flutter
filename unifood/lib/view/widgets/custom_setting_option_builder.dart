import 'package:flutter/material.dart';
import 'package:unifood/model/preferences_entity.dart'; // Ensure the path is correct
import 'package:unifood/view/profile/preferences/widgets/custom_settings_options_preferences.dart';

typedef OnDeleteItem = void Function(int index, String type);
typedef OnRestoreItem = void Function(int index, String type);

class CustomSettingOptionWithIconsBuilder {
  List<PreferenceItem> items = [];
  String userId = '';
  VoidCallback onPressed = () {};
  Set<int> markedForDeletion = {};
  OnDeleteItem onDeleteItem = (index, type) {};
  OnRestoreItem onRestoreItem = (index, type) {};
  bool isEditing = false;
  String type = '';
  bool isConnected = false;

  CustomSettingOptionWithIconsBuilder setItems(List<PreferenceItem> items) {
    this.items = items;
    return this;
  }

  CustomSettingOptionWithIconsBuilder setUserId(String userId) {
    this.userId = userId;
    return this;
  }

  CustomSettingOptionWithIconsBuilder setOnPressed(VoidCallback onPressed) {
    this.onPressed = onPressed;
    return this;
  }

  CustomSettingOptionWithIconsBuilder setMarkedForDeletion(
      Set<int> markedForDeletion) {
    this.markedForDeletion = markedForDeletion;
    return this;
  }

  CustomSettingOptionWithIconsBuilder setOnDeleteItem(
      OnDeleteItem onDeleteItem) {
    this.onDeleteItem = onDeleteItem;
    return this;
  }

  CustomSettingOptionWithIconsBuilder setOnRestoreItem(
      OnRestoreItem onRestoreItem) {
    this.onRestoreItem = onRestoreItem;
    return this;
  }

  CustomSettingOptionWithIconsBuilder setIsEditing(bool isEditing) {
    this.isEditing = isEditing;
    return this;
  }

  CustomSettingOptionWithIconsBuilder setIsConnected(bool isConnected) {
    this.isConnected = isConnected;
    return this;
  }

  CustomSettingOptionWithIconsBuilder setType(String type) {
    this.type = type;
    return this;
  }

  CustomSettingOptionWithIcons build() {
    return CustomSettingOptionWithIcons(
      items: items,
      userId: userId,
      onPressed: onPressed,
      markedForDeletion: markedForDeletion,
      onDeleteItem: onDeleteItem,
      onRestoreItem: onRestoreItem,
      type: type,
      isEditing: isEditing,
      isConnected: isConnected
    );
  }
}
