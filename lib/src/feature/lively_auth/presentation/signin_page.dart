// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lively/src/core/helper.dart';
import 'package:lively/src/feature/lively_auth/data/database_services.dart';
import 'package:lively/src/feature/lively_auth/domain/auth_services.dart';
import 'package:lively/src/feature/lively_auth/presentation/signup_page.dart';
import 'package:lively/src/shared/constants.dart';
import 'package:lively/src/shared/ui_helper.dart';
import 'package:lively/src/shared/widgets.dart';

import '../../lively_chat/presentation/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;
  final AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: screenHeight(context),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/login.png'))),
                child: Container(
                  color: Colors.white30,
                  child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 80),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Lively',
                              style: TextStyle(
                                fontSize: UIHelper.kLargeFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            UIHelper.verticalSPaceSmall,
                            const Text(
                                'Get familier with the world aroung you'),
                            //Image.asset('assets/images/login.png'),
                            const Spacer(),
                            TextFormField(
                              decoration: textDecoration.copyWith(
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: UIHelper.kMediumFont,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onChanged: ((value) {
                                setState(() {
                                  email = value;
                                  debugPrint(email);
                                });
                              }),
                              validator: (val) {
                                return RegExp(pattern).hasMatch(val!)
                                    ? null
                                    : 'Please enter a valid email';
                              },
                            ),
                            UIHelper.verticalSPaceSmall,
                            TextFormField(
                              decoration: textDecoration.copyWith(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: UIHelper.kMediumFont,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                  debugPrint(password);
                                });
                              },
                              validator: ((value) {
                                if (value!.length < 6) {
                                  return 'Password most be atleast 6 character long';
                                } else {
                                  return null;
                                }
                              }),
                              obscureText: true,
                            ),
                            UIHelper.verticalSpaceMedium,
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                onPressed: () {
                                  _login();
                                },
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: UIHelper.kMediumFont,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            UIHelper.verticalSPaceSmall,
                            Text.rich(TextSpan(
                                text: 'Don\'t have an account?  ',
                                style: TextStyle(
                                  fontSize: UIHelper.kSmallFont,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'Register here',
                                      style: TextStyle(
                                        fontSize: UIHelper.kMediumFont,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(context, RegisterPage());
                                        })
                                ])),
                            UIHelper.verticalSpaceLarge
                          ],
                        ),
                      )),
                ),
              ),
            ),
    );
  }

  _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authServices.logInUser(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseServices(
                  userId: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          //! saving the values to our shared preferences
          await Helper.saveUserLoggedInStatus(true);
          await Helper.saveUserEmail(email);
          await Helper.saveUserName(snapshot.docs[0]["fullName"]);
          nextScreenReplacement(context, LivelyHomePage());
        } else {
          setState(() {
            shoeSnackbar(context, value, primaryColor);
            isLoading = false;
          });
        }
      });
      debugPrint('logged in success');
    }
  }
}
