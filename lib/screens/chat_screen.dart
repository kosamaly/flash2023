import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/models/message_model.dart';
import 'package:flash/screens/welcome_screen.dart';
import 'package:flash/widgets/loading_widget.dart';
import 'package:flash/widgets/message_widget.dart';
import 'package:flash/widgets/send_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    print("ChatScreen Build");
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
                                      (doc) => MessageWidget(
                                        msgModel: MsgModel.fromJson(
                                          doc.data(),
                                        ),
                                        userEmail: loggedInUser.email ?? "",
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
            SendWidget(userEmail: loggedInUser.email ?? ""),
          ],
        ),
      ),
    );
  }
}
