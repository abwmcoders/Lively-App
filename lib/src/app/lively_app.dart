import 'package:flutter/material.dart';
import 'package:lively/src/core/helper.dart';
import 'package:lively/src/shared/constants.dart';

import '../feature/lively_auth/presentation/signin_page.dart';
import '../feature/lively_chat/presentation/home.dart';

class LivelyApp extends StatefulWidget {
  const LivelyApp({Key? key}) : super(key: key);

  @override
  State<LivelyApp> createState() => _LivelyAppState();
}

class _LivelyAppState extends State<LivelyApp> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await Helper.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isSignedIn ? LivelyHomePage() : const LoginPage(),
    );
  }
}
