// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lively/src/feature/lively_auth/data/database_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {Key? key,
      required this.userName,
      required this.groupName,
      required this.groupId})
      : super(key: key);
  final String userName, groupName, groupId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = '';
  @override
  void initState() {
    super.initState();
    getChatAndAdmin();
  }

  getChatAndAdmin() {
    DatabaseServices().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });

    DatabaseServices().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(widget.groupName),
      ),
    );
  }
}
