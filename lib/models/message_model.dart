import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MsgModel {
  final String sender;
  final String text;
  final DateTime date;
  MsgModel({
    required this.text,
    required this.sender,
    required this.date,
  });

  factory MsgModel.fromJson(Map<String, dynamic> json) {
    final timestamp = (json['date'] as Timestamp?);
    DateTime dateTime;

    if (timestamp != null) {
      dateTime = timestamp.toDate();
    } else {
      dateTime = DateTime.now();
    }

    return MsgModel(
      sender: json['sender'],
      text: json['text'],
      date: dateTime,
    );
  }
}
