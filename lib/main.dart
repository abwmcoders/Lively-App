import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lively/src/app/lively_app.dart';
import 'package:lively/src/shared/firebase_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: FirebaseConstant.apiKey,
            appId: FirebaseConstant.appId,
            messagingSenderId: FirebaseConstant.messageSenderId,
            projectId: FirebaseConstant.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const LivelyApp());
}

