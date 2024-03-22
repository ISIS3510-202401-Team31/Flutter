import 'package:flutter/material.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onBackButtonPressed;

  const SearchAppBar({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomCircledButton(
                    onPressed: onBackButtonPressed,
                    diameter: screenWidth * 0.07,
                    icon: Icon(
                      Icons.chevron_left_sharp,
                      color: Colors.black,
                    ),
                    buttonColor: Colors.white,
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.00625),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: screenWidth * 0.005,
                            blurRadius: screenWidth * 0.01,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          labelText: 'What do you want to eat?',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 128, 126, 126),
                            fontSize: screenWidth * 0.0325,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05,
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    onSearchChanged('');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 34);
}
