import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.05),
        child: AppBar(
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
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(screenHeight * 0.06);
}
