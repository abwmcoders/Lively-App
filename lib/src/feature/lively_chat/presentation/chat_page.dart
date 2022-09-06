// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lively/src/feature/lively_auth/data/database_services.dart';
import 'package:lively/src/feature/lively_chat/presentation/group_info.dart';
import 'package:lively/src/feature/lively_chat/presentation/message_tile.dart';
import 'package:lively/src/shared/ui_helper.dart';
import 'package:lively/src/shared/widgets.dart';

import '../../../shared/constants.dart';

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
  TextEditingController controller = TextEditingController();
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
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(widget.groupName),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                        groupAdmin: admin,
                        groupName: widget.groupName,
                        groupId: widget.groupId));
              },
              icon: Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: screenWidth(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              color: Colors.grey[700],
              width: screenWidth(context),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter a message ...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: UIHelper.kSmallFont,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpaceMedium,
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index]["message"],
                        sender: snapshot.data.docs[index]["sender"],
                        sendByMe:
                            widget.userName == snapshot.data.docs[index]["sender"]);
                  })
              : Container();
        });
  }

  sendMessage() {
    if (controller.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": controller.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseServices().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        controller.clear();
      });
    }
  }
}
