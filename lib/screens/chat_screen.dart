import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// for database in firebase
import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  const ChatScreen({super.key});
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final fireStore = FirebaseFirestore.instance;
  // final _auth = FirebaseAuth.instance;

  String messageText = "";
  late User logedInUser;
  @override
  void initState() {
    // getCurrentUser();
    super.initState();
  }

  // void getCurrentUser() async {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       logedInUser = user;
  //       print(logedInUser.email);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void messageStream() async {
    await for (var snapshot in fireStore.collection('message').snapshots()) {
      for (var message in snapshot.docChanges) {
        print(message.doc);
      }
    }
  }

  /// a variable to save firebase message in it

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!mounted) return;
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: fireStore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data?.docChanges;
                    List<Text> messageWidgets = [];
                    for (var message in messages)

                      ///doc or data like Angla
                      final messageText = message.doc['text'];
                    final messageSender =message.doc ['sender'];
                    final messageWidget = Text(messageText from $messageSender);
                    messageWidget.doc(messageWidget);
                  }
                  return Column( children: messageWidgets,);
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      fireStore.collection("messages").add({
                        "text": messageText,
                        "sender": logedInUser.email,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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
