// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lively/src/shared/constants.dart';
import 'package:lively/src/shared/ui_helper.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({Key? key, required this.message, required this.sender, required this.sendByMe}) : super(key: key);

  final String message, sender;
  final bool sendByMe;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sendByMe ? 0 : 24,
        right: widget.sendByMe ? 24 : 0,
      ),
      child: Container(
        margin: widget.sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 18, bottom: 18, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: widget.sendByMe ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20)) : BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: widget.sendByMe ? primaryColor : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.sender.toLowerCase(), textAlign: TextAlign.center, style:  TextStyle(fontSize: UIHelper.kMediumFont, fontWeight: FontWeight.bold,color: Colors.white, letterSpacing: -.5),),
            UIHelper.verticalSPaceSmall,
            Text(widget.message, textAlign: TextAlign.center, style:  TextStyle(
              fontSize: UIHelper.kSmallFont,
              color: Colors.white,
            ),)
          ],
        ),
      ),
    );
  }
}
