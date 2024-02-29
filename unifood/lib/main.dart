import 'package:flutter/material.dart';
import 'package:unifood/widgets/custom_button.dart';
import 'package:unifood/widgets/custom_circled_button.dart';
import 'package:unifood/widgets/custom_restaurant.dart';
import 'package:unifood/widgets/custom_textformfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton(
              onPressed: () {},
              text: 'Login',
              width: 165,
              height: 47,
              fontSize: 24,
              textColor: Colors.white,
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: () {},
              text: 'Sign Up',
              width: 165,
              height: 47,
              fontSize: 24,
              textColor: Colors.white,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCircledButton(
                  onPressed: () {},
                  diameter: 36,
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  buttonColor: Color(0xFF965E4E),
                ),
                CustomCircledButton(
                  onPressed: () {},
                  diameter: 36,
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                  buttonColor: Colors.white,
                )
              ],
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              labelText: 'Email',
              hintText: 'Type your email here',
              icon: Icon(Icons.email),
              obscureText: false,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              labelText: 'Password',
              hintText: 'Type your password here',
              icon: Icon(Icons.lock),
              obscureText: true,
            ),
            SizedBox(height: 20),
            CustomRestaurant(
              imageUrl: '../assets/elcarnal_image.jpg',
              logoUrl: '../assets/elcarnal_logo.jpeg',
              name: 'El carnal',
              isOpen: false,
              distance: 1.5,
              rating: 4,
              avgPrice: 25.500,
            )
          ],
        ),
      ),
    );
  }
}
