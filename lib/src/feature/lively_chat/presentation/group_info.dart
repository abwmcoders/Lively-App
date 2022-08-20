import 'package:flutter/material.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo(
      {Key? key,
      required this.groupAdmin,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  final String groupAdmin, groupName, groupId;

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
