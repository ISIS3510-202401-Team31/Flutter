import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_circled_button.dart';
import 'package:unifood/widgets/custom_settings_button.dart';
import 'package:unifood/widgets/custom_settings_options.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 16, top: 50),
          child: Row(
            children: <Widget>[
              CustomCircledButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/landing');
                },
                diameter: 28,
                icon: const Icon(
                  Icons.chevron_left_sharp,
                  color: Colors.black,
                ),
                buttonColor: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 75.0),
                child: Text(
                  'Bogotá',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Upper Part of the Screen (User Details)
            const Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pedro Perez',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'pedroperez@uniandes.edu.co',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                ],
              ),
            ),
            // Rest of the Page (Settings Buttons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                        onPressed: () {Navigator.pushNamed(context, '/preferences');},
                      ),
                      CustomSettingOption(
                        icon: Icons.point_of_sale_rounded, 
                        text: 'Points', 
                        onPressed: () {},
                      ),
                      CustomSettingOption(
                        icon: Icons.help, 
                        text: 'Help', 
                        onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
