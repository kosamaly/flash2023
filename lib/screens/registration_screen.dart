import 'package:flash/screens/constants.dart';
import 'package:flutter/material.dart';
import '../components/rounded-button.dart';
import 'constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: "logo",
              child: SizedBox(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
                onChanged: (value) {
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter Email")),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
                onChanged: (value) {
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter Password")),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                colour: Colors.blueAccent,
                title: "Registration",
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
