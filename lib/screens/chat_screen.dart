import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/screens/welcome_screen.dart';
import 'package:flash/widgets/loading_widget.dart';
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
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  TextEditingController textEditingController = TextEditingController();
  late User loggedInUser;

  get msg => null;

  @override
  void initState() {
    super.initState();
    loggedInUser = _auth.currentUser!;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

/*
Widget buttonKey(Color color, int soundNumber) {
    return Expanded(
      child: InkWell(
        onTap: () {
          playSound(soundNumber);
        },
        child: Container(
          color: color,
        ),
      ),
    );
  }

*/

  Widget singleMsgUI(Map<String, dynamic> msg) {
    final isMe = msg["sender"]! == loggedInUser.email;
    final messageDate = msg["date"]!.toDate().hour.toString() +
        ":" +
        msg['date']!.toDate().minute.toString();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Text(
            msg["sender"]!,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            child: GestureDetector(
              onTap: () {
                Column(
                  children: [
                    Text(
                      "$messageDate",
                      style: TextStyle(fontSize: 100, color: Colors.red),
                    ),
                  ],
                );

                setState(() {
                  Text(
                    "$messageDate",
                    style: TextStyle(fontSize: 100, color: Colors.red),
                  );
                  print(messageDate);
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isMe ? Colors.green : Colors.redAccent,
                ),
                child: Column(
                  children: [
                    Text(
                      msg["text"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],

                  //
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          // Logout Button
          IconButton(
              icon: const Icon(Icons.close),
              // Logout Function
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
            //* List of messages
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _fireStore
                    .collection('messages')
                    .orderBy("date")
                    .snapshots(),
                builder: (context, collection) {
                  // Success
                  if (collection.hasData) {
                    final docs = collection.data!.docs;

                    return

                        // Docs is empty
                        docs.isEmpty
                            ? const Center(
                                child: Text(
                                  "There is no messages.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            :
                            // Has messages
                            ListView(
                                children: docs
                                    .map(
                                      (doc) => singleMsgUI(
                                        doc.data(),
                                      ),
                                    )
                                    .toList());
                  }
                  // Error
                  else if (collection.hasError) {
                    return const Center(
                      child: Text(
                        "Something went wrong!",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  // Loading
                  else {
                    return const LoadingWidget();
                  }
                },
              ),
            ),

            //* Send Area
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  InkWell(
                    child: TextButton(
                      onPressed: () {
                        if (textEditingController.text.trim().isNotEmpty) {
                          // Send msg

                          _fireStore.collection("messages").add(
                              // Message Map
                              {
                                "text": textEditingController.text,
                                "sender": loggedInUser.email,
                                "date": FieldValue.serverTimestamp(),
                              });
                          // Clear text
                          textEditingController.clear();
                        }

                        // ()
                      },
                      child: const Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
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
