import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/screens/chat_screen.dart';
import 'package:flash/widgets/loading_widget.dart';
import 'package:flash/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  bool isObscured = true;

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
                  obscureText: isObscured,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your password",
                    suffixIcon: IconButton(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      icon: isObscured
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                    ),
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

                            ///what is this?
                            final newUser = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email!, password: password!);

                            log("Register Success $newUser");

                            setState(() {
                              isLoading = false;
                            });
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(
                                context, ChatScreen.id, (_) => false);
                          }
                        } catch (e) {
                          log("Register Error $e");
                          setState(() {
                            isLoading = false;

                            Alert(
                                    context: context,
                                    title: "Failed Registration",
                                    desc: "Incorrect Email Or Password.")
                                .show();
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
