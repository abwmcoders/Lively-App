// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lively/src/shared/constants.dart';
import 'package:lively/src/shared/ui_helper.dart';
import 'package:lively/src/shared/widgets.dart';

import 'chat_page.dart';

class GroupTile extends StatefulWidget {
  const GroupTile(
      {Key? key,
      required this.userName,
      required this.groupId,
      required this.groupName})
      : super(key: key);
  final String userName, groupId, groupName;

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(context, ChatPage(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName,));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: UIHelper.kLargeFont,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'join the conversation as ${widget.userName}',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: UIHelper.kMediumFont,
            ),
          ),
        ),
      ),
    );
  }
}
