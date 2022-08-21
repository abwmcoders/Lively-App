// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lively/src/core/helper.dart';
import 'package:lively/src/feature/lively_auth/data/database_services.dart';
import 'package:lively/src/feature/lively_chat/presentation/chat_page.dart';
import 'package:lively/src/shared/ui_helper.dart';
import 'package:lively/src/shared/widgets.dart';

import '../../../shared/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasSearched = false;
  String userName = '';
  User? user;
  bool isJoined = false;

  @override
  void initState() {
    getUserNameAndId();
    super.initState();
  }

  //! string manipulation
  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  getUserNameAndId() async {
    await Helper.getUserNameFromSp().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text('Group Info'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        helperStyle: TextStyle(
                          color: Colors.white,
                          fontSize: UIHelper.kMediumFont,
                        ),
                        hintText: 'Search group ....'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white.withOpacity(.1),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (controller.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseServices().searchGroupByName(controller.text).then((value) {
        setState(() {
          searchSnapshot = value;
          isLoading = false;
          hasSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasSearched
        ? Container(
          height: 500,
          child: ListView.builder(
              itemCount: searchSnapshot!.docs.length,
              itemBuilder: (context, index) {
                return groupTile(
                    userName,
                    searchSnapshot!.docs[index]['groupAdmin'],
                    searchSnapshot!.docs[index]['groupId'],
                    searchSnapshot!.docs[index]['groupName']);
              }),
        )
        : Container();
  }

  joinedOrNot(String groupAdmin, groupName, groupId, userName) async {
    await DatabaseServices(userId: user!.uid)
        .isuserJoined(userName, groupName, groupId)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(String userName, groupAdmin, groupId, groupName) {
    //! function to check if user already exist in group
    joinedOrNot(groupAdmin, groupName, groupId, userName);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontSize: UIHelper.kMediumFont,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        groupName,
        style: TextStyle(
          fontSize: UIHelper.kMediumFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text("Admin: ${getName(groupAdmin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseServices(userId: user!.uid)
              .toggleGroupJoin(groupName, userName, groupId);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            shoeSnackbar(context, 'Succesfully joined the group', Colors.green);
            Future.delayed(Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                      userName: userName,
                      groupName: groupName,
                      groupId: groupId));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
              shoeSnackbar(context, 'Left the group: $groupName', Colors.red);
            });
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Joined",
                  style: TextStyle(
                    fontSize: UIHelper.kMediumFont,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Join now",
                  style: TextStyle(
                    fontSize: UIHelper.kMediumFont,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
