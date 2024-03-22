import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/user_repository.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/view/profile/dashboard/widgets/custom_settings_button.dart';
import 'package:unifood/view/profile/dashboard/widgets/custom_settings_options.dart';
import 'package:unifood/view_model/user_view_model.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(String userId) async {
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Selecciona una imagen"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Tomar una foto"),
              onTap: () async {
                Navigator.of(context)
                    .pop(await _picker.pickImage(source: ImageSource.camera));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Seleccionar de la galería"),
              onTap: () async {
                Navigator.of(context)
                    .pop(await _picker.pickImage(source: ImageSource.gallery));
              },
            ),
          ],
        ),
      ),
    );

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      setState(() {
        _image = imageFile;
      });

      await UserRepository().updateUserProfileImage(userId, imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<Users?>(
      future: UserRepository().getUserSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitThreeBounce(
              color: Colors.black,
              size: 30.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Oops! Something went wrong.\nPlease try again later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold, // Letra en negrita
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: MediaQuery.of(context).size.width * 0.08,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          final userData = snapshot.data!;
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenHeight * 0.05),
              child: CustomAppBarBuilder(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                showBackButton: true,
              )
                  .setRightWidget(
                    Container(
                      margin: EdgeInsets.only(right: screenWidth * 0.44),
                      child: Text(
                        'Bogotá',
                        style: TextStyle(
                          fontSize: screenHeight * 0.018,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  )
                  .build(context),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                width: screenWidth * 0.985,
                height: screenHeight * 0.82,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.025, left: screenWidth * 0.02),
                  child: SizedBox(
                    height: screenHeight * 0.2,
                    width: screenWidth * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: screenHeight * 0.05,
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.05),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          userData.name,
                                          style: TextStyle(
                                            fontSize: screenHeight * 0.0275,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.0025),
                                        Text(
                                          userData.email,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.033,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.008),
                                        FutureBuilder<String>(
                                          future: UserViewModel()
                                              .getDistanceFromCampus(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              // Muestra un indicador de carga mientras se espera el resultado
                                              return Center(
                                                child: SpinKitThreeBounce(
                                                  color: Colors.black,
                                                  size: screenHeight * 0.03,
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              // Muestra un mensaje de error si ocurre algún error
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              // Muestra el texto devuelto por la función
                                              final distance = snapshot.data;
                                              return Row(
                                                children: [
                                                  Text(
                                                    '$distance',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: screenHeight *
                                                            0.015),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          screenWidth * 0.01),
                                                  Text(
                                                    'km away from campus.',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: screenHeight *
                                                            0.015),
                                                  )
                                                ],
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _getImage(userData.uid);
                                  },
                                  child: CircleAvatar(
                                    radius: screenHeight * 0.05,
                                    backgroundImage: _image == null
                                        ? NetworkImage(
                                            userData.profileImageUrl!)
                                        : FileImage(_image!) as ImageProvider,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.075,
                                vertical: screenHeight * 0.015),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomSettingsButton(
                                      icon: Icons.thumb_up,
                                      backgroundColor: const Color.fromARGB(
                                          255, 169, 75, 75),
                                      onPressed: () {
                                        // Add functionality for the settings button
                                      },
                                    ),
                                    CustomSettingsButton(
                                      icon: Icons.home,
                                      backgroundColor: const Color.fromARGB(
                                          255, 169, 75, 75),
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            '/restaurants'); // Add functionality for the settings button
                                      },
                                    ),
                                    CustomSettingsButton(
                                      icon: Icons.people,
                                      backgroundColor: const Color.fromARGB(
                                          255, 169, 75, 75),
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
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/favorites');
                                      },
                                    ),
                                    CustomSettingOption(
                                      icon: Icons.settings,
                                      text: 'Preferences',
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/preferences');
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
                                      onPressed: () {},
                                    ),
                                    CustomSettingOption(
                                      icon: Icons.logout,
                                      text: 'Log Out',
                                      onPressed: () async {
                                        try {
                                          await FirebaseAuth.instance.signOut();
                                          // Navegar a la pantalla de inicio de sesión o a otra pantalla según sea necesario
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/login',
                                              (route) => false);
                                        } catch (error) {
                                          print('Error signing out: $error');
                                          // Manejar el error según sea necesario
                                        }
                                      },
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
      },
    );
  }
}
