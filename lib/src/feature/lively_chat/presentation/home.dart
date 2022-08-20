// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lively/src/core/helper.dart';
import 'package:lively/src/feature/lively_auth/data/database_services.dart';
import 'package:lively/src/feature/lively_auth/domain/auth_services.dart';
import 'package:lively/src/feature/lively_auth/presentation/signin_page.dart';
import 'package:lively/src/feature/lively_chat/presentation/group_tile.dart';
import 'package:lively/src/feature/lively_profile/presentation/profile_page.dart';
import 'package:lively/src/feature/lively_search/presentation/search_page.dart';
import 'package:lively/src/shared/constants.dart';
import 'package:lively/src/shared/ui_helper.dart';
import 'package:lively/src/shared/widgets.dart';

class LivelyHomePage extends StatefulWidget {
  LivelyHomePage({Key? key}) : super(key: key);

  @override
  State<LivelyHomePage> createState() => _LivelyHomePageState();
}

class _LivelyHomePageState extends State<LivelyHomePage> {
  final AuthServices authServices = AuthServices();

  String userName = '';
  Stream? groups;
  String email = '';
  String groupName = '';
  bool? _isLoading = false;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await Helper.getUserEmailFromSp().then((value) {
      setState(() {
        email = value!;
      });
    });

    await Helper.getUserNameFromSp().then((value) {
      setState(() {
        userName = value!;
      });
    });

    //! getting the list of snapshot in our stream
    await DatabaseServices(userId: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  //! string manipulation for group id
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  //! string manipulation for user name
  String getUserName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        title: const Text(
          'Groups',
          style: TextStyle(
            fontSize: UIHelper.kMediumFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: groupList(),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.grey.shade700,
              size: 150,
            ),
            UIHelper.verticalSPaceSmall,
            Text(
              userName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: UIHelper.kMediumFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            UIHelper.verticalSPaceSmall,
            Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selectedColor: primaryColor,
              leading: Icon(Icons.group),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              selected: true,
              title: Text(
                'Groups',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: UIHelper.kMediumFont,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplacement(
                    context,
                    ProfilePage(
                      userName: userName,
                      email: email,
                    ));
              },
              leading: Icon(Icons.person),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: UIHelper.kMediumFont,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('You are about to logout'),
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
                                authServices.signOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false);
                              },
                              icon: Icon(
                                Icons.done,
                                color: Colors.red,
                              )),
                        ],
                      );
                    });
              },
              leading: Icon(Icons.exit_to_app),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: UIHelper.kMediumFont,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        backgroundColor: primaryColor,
        elevation: 0,
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return StatefulBuilder(builder: (context, snapshot) {
            return AlertDialog(
              title: Text(
                'Create a group',
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              groupName = value;
                              debugPrint(groupName);
                            });
                          },
                          style: TextStyle(color: Colors.black),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(primary: primaryColor),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != '') {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseServices(
                              userId: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.pop(context);
                      shoeSnackbar(
                          context, 'Group created successfully', Colors.green);
                    }
                  },
                  child: Text('Create'),
                  style: ElevatedButton.styleFrom(primary: primaryColor),
                ),
              ],
            );
          });
        }));
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: ((context, AsyncSnapshot snapshot) {
        //! make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    //! this line brings the most recent group to the top
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        groupName: getUserName(snapshot.data['groups'][reverseIndex]),
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        userName: snapshot.data['fullName']);
                  });
            } else {
              return noGroupWidgets();
            }
          } else {
            return noGroupWidgets();
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
          ));
        }
      }),
    );
  }

  noGroupWidgets() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: (() => popUpDialog(context)),
            icon: Icon(
              Icons.add_circle,
              size: 80,
              color: Colors.grey[700],
            ),
          ),
          UIHelper.verticalSpaceLarge,
          Text(
            'You do not have any group at the moment, use the add button to create one or search a group name',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: UIHelper.kMediumFont,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
