import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/screens/chat_screen.dart';
import 'package:flash/widgets/loading_widget.dart';
import 'package:flash/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "registration_screen";

  const RegistrationScreen({super.key});
  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  String? email;
  String? password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 48.0,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: BackButton(),
              ),
              SizedBox(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your email")),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your password",
                  )),
              const SizedBox(
                height: 24.0,
              ),
              isLoading
                  ? const LoadingWidget()
                  : RoundedButton(
                      colour: Colors.blueAccent,
                      title: 'Register',
                      onPressed: () async {
                        try {
                          if (email != null && password != null) {
                            setState(() {
                              isLoading = true;
                            });
                            final newUser = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email!, password: password!);

                            log("Register Success $newUser");

                            setState(() {
                              isLoading = false;
                            });
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        } catch (e) {
                          log("Register Error $e");
                          setState(() {
                            isLoading = false;
                          });
                        }
                      })
            ],
          ),
        ),
      ),
    );
  }
}
