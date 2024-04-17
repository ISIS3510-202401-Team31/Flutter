import 'package:flutter/material.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';

class CustomAppBarBuilder {
  Widget? rightWidget;
  double? screenHeight;
  double? screenWidth;
  bool showBackButton;

  CustomAppBarBuilder({
    this.showBackButton = false,
    required this.screenHeight,
    required this.screenWidth,
  });

  CustomAppBarBuilder setRightWidget(Widget rightWidget) {
    this.rightWidget = rightWidget;
    return this;
  }

  CustomAppBarBuilder setScreenHeight(double screenHeight) {
    this.screenHeight = screenHeight;
    return this;
  }

  CustomAppBarBuilder setScreenWidth(double screenWidth) {
    this.screenWidth = screenWidth;
    return this;
  }

  CustomAppBarBuilder setShowBackButton(bool showBackButton) {
    this.showBackButton = showBackButton;
    return this;
  }

  CustomAppBar build(BuildContext context) {
    return CustomAppBar(
      rightWidget: rightWidget!,
      screenHeight: screenHeight!,
      screenWidth: screenWidth!,
      showBackButton: showBackButton,
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget rightWidget;
  final double screenHeight;
  final double screenWidth;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.rightWidget,
    required this.screenHeight,
    required this.screenWidth,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        if (showBackButton)
          CustomCircledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            diameter: screenHeight * 0.0335,
            icon: Icon(
              Icons.chevron_left_sharp,
              color: Colors.black,
              size: screenHeight * 0.0335,
            ),
            buttonColor: Colors.white,
          ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                rightWidget,
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(screenHeight * 0.06);
}
