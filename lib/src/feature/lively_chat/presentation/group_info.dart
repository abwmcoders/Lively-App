// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lively/src/feature/lively_auth/data/database_services.dart';
import 'package:lively/src/feature/lively_auth/domain/auth_services.dart';
import 'package:lively/src/feature/lively_chat/presentation/home.dart';
import 'package:lively/src/shared/constants.dart';
import 'package:lively/src/shared/ui_helper.dart';
import 'package:lively/src/shared/widgets.dart';

import '../../lively_auth/presentation/signin_page.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo(
      {Key? key,
      required this.groupAdmin,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  final String groupAdmin, groupName, groupId;

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  AuthServices authServices = AuthServices();
  @override
  void initState() {
    getMenber();
    super.initState();
  }

  getMenber() async {
    DatabaseServices(userId: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  //! string manipulation for group admin
  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text('Group Info'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Exit'),
                        content:
                            Text('Are you sure you want to exit the group'),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.green,
                              )),
                          IconButton(
                              onPressed: () async {
                                DatabaseServices(
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .toggleGroupJoin(
                                        widget.groupName,
                                        getName(widget.groupAdmin),
                                        widget.groupId)
                                    .whenComplete(() {
                                  nextScreen(context, LivelyHomePage());
                                });
                              },
                              icon: Icon(
                                Icons.done,
                                color: Colors.red,
                              )),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: primaryColor.withOpacity(.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: UIHelper.kMediumFont,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  UIHelper.horizontalSpaceMedium,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: UIHelper.kMediumFont),
                      ),
                      UIHelper.verticalSPaceSmall,
                      Text(
                        "Admin: ${getName(widget.groupAdmin)}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: UIHelper.kSmallFont),
                      )
                    ],
                  )
                ],
              ),
            ),
            membersList(),
          ],
        ),
      ),
    );
  }

  membersList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor,
                          child: Text(getName(snapshot.data['members'][index]).substring(0,1).toUpperCase(),
                          style: TextStyle(
                              fontSize: UIHelper.kMediumFont,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          // child: Text(
                          //   getName(snapshot.data['members'])
                          //       .substring(0,1)
                          //       .toUpperCase().toString(),
                          //   style: TextStyle(
                          //     fontSize: UIHelper.kMediumFont,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ),
                        title: Text(
                          getName(snapshot.data['members'][index]),
                          //snapshot.data['members'][index],
                          style: TextStyle(
                            fontSize: UIHelper.kMediumFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(getId(snapshot.data['members'][index])),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('No member'),
                );
              }
            } else {
              return Center(
                child: Text('No member'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
        });
  }
}
