import 'package:flutter/material.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';
import 'package:unifood/view/profile/dashboard/widgets/custom_settings_button.dart';
import 'package:unifood/view/profile/dashboard/widgets/custom_settings_options.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.05),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            margin:  EdgeInsets.only(left: screenWidth*0.015 , top: screenHeight*0.045),
            child: Row(
              children: <Widget>[
                CustomCircledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/restaurants');
                  },
                  diameter: screenHeight * 0.0335,
                  icon: Icon(
                    Icons.chevron_left_sharp,
                    color: Colors.black,
                    size: screenHeight * 0.0335
                  ),
                  buttonColor: Colors.white,
                ),
                 Padding(
                   padding: EdgeInsets.only(top: screenHeight * 0.01, left : screenWidth * 0.2),
                   child: Text(
                     'Bogotá',
                     style: TextStyle(
                       fontSize: screenHeight * 0.018,
                       fontWeight: FontWeight.w300,
                     ),
                   ),
                 ),
              ],
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth * 0.985,
          height: screenHeight * 0.8,
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.025, left: screenWidth *0.02),
            child: Container(
              height: screenHeight * 0.2,
              width : screenWidth *0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                   Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.05, left: screenWidth *0.05, right: screenWidth *0.05),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Pedro Perez',
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.0275,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.0025),
                                Text(
                                  'pedroperez@uniandes.edu.co',
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.02,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: screenHeight * 0.05,
                          backgroundImage:
                              AssetImage('assets/images/profile_image.jpg'),
                        ),
                      ],
                    ),
                  ),
                  // Rest of the Page (Settings Buttons)
                  Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.075),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CustomSettingsButton(
                                icon: Icons.thumb_up,
                                backgroundColor: const Color.fromARGB(255, 169, 75, 75),
                                onPressed: () {
                                  // Add functionality for the settings button
                                },
                              ),
                              CustomSettingsButton(
                                icon: Icons.notifications,
                                backgroundColor: const Color.fromARGB(255, 169, 75, 75),
                                onPressed: () {
                                  // Add functionality for the settings button
                                },
                              ),
                              CustomSettingsButton(
                                icon: Icons.people,
                                backgroundColor: const Color.fromARGB(255, 169, 75, 75),
                                onPressed: () {
                                  // Add functionality for the settings button
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: <Widget>[
                              CustomSettingOption(
                                icon: Icons.star,
                                text: 'Favorites',
                                onPressed: () {},
                              ),
                              CustomSettingOption(
                                icon: Icons.settings,
                                text: 'Preferences',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/preferences');
                                },
                              ),
                              CustomSettingOption(
                                icon: Icons.point_of_sale_rounded,
                                text: 'Points',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/points');
                                },
                              ),
                              CustomSettingOption(
                                icon: Icons.help,
                                text: 'Help',
                                onPressed: () { 
                                },
                              ),
                              CustomSettingOption(
                                icon: Icons.logout,
                                text: 'Log Out',
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
