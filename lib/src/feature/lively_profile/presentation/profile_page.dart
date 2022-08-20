// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:lively/src/feature/lively_auth/domain/auth_services.dart';
import 'package:lively/src/feature/lively_chat/presentation/home.dart';

import '../../../shared/constants.dart';
import '../../../shared/ui_helper.dart';
import '../../../shared/widgets.dart';
import '../../lively_auth/presentation/signin_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.userName, required this.email})
      : super(key: key);
  final String userName;
  final String email;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: UIHelper.kMediumFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.grey.shade700,
              size: 150,
            ),
            UIHelper.verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Full name:'),
                Text(widget.userName),
              ],
            ),
            UIHelper.verticalSPaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Email address: '),
                Text(widget.email),
              ],
            ),
          ],
        ),
      ),
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
              widget.userName,
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
              onTap: () {
                nextScreen(context, LivelyHomePage());
              },
              leading: Icon(Icons.group),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Text(
                'Groups',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: UIHelper.kMediumFont,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              selectedColor: primaryColor,
              selected: true,
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
    );
  }
}
