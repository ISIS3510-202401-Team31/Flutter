import 'package:flutter/material.dart';

class ViewBuilder {
  PreferredSizeWidget? appBar;
  Widget? body;
  FloatingActionButton? floatingActionButton;
  Drawer? drawer;
  BottomNavigationBar? bottomNavigationBar;

  ViewBuilder setAppBar(PreferredSizeWidget appBar) {
    this.appBar = appBar;
    return this;
  }

  ViewBuilder setBody(Widget body) {
    this.body = body;
    return this;
  }

  ViewBuilder setFloatingActionButton(
      FloatingActionButton floatingActionButton) {
    this.floatingActionButton = floatingActionButton;
    return this;
  }

  ViewBuilder setDrawer(Drawer drawer) {
    this.drawer = drawer;
    return this;
  }

  ViewBuilder setBottomNavigationBar(BottomNavigationBar bottomNavigationBar) {
    this.bottomNavigationBar = bottomNavigationBar;
    return this;
  }

  Scaffold build() {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
