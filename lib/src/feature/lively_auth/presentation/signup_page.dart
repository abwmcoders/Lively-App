// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lively/src/core/helper.dart';
import 'package:lively/src/feature/lively_auth/domain/auth_services.dart';
import 'package:lively/src/feature/lively_auth/presentation/signin_page.dart';
import 'package:lively/src/feature/lively_chat/presentation/home.dart';
import 'package:lively/src/shared/constants.dart';
import 'package:lively/src/shared/ui_helper.dart';
import 'package:lively/src/shared/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  bool isLoading = false;
  AuthServices authServices = AuthServices();

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
                        image: AssetImage('assets/images/signup.png'))),
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
                                'Create an account to explore the world of fun'),
                            //Image.asset('assets/images/login.png'),
                            const Spacer(),
                            TextFormField(
                              decoration: textDecoration.copyWith(
                                  labelText: 'Full Name',
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: UIHelper.kMediumFont,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onChanged: ((value) {
                                setState(() {
                                  fullName = value;
                                  debugPrint(fullName);
                                });
                              }),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Full name can\'t be empty';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            UIHelper.verticalSPaceSmall,
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
                                  _signUp();
                                },
                                child: const Text(
                                  'Sign up',
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
                                text: 'Already have an account  ',
                                style: TextStyle(
                                  fontSize: UIHelper.kSmallFont,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'Login now',
                                      style: TextStyle(
                                        fontSize: UIHelper.kMediumFont,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(context, LoginPage());
                                        })
                                ])),
                          ],
                        ),
                      )),
                ),
              ),
            ),
    );
  }

  _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authServices
          .registerUser(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //! saving to shared preferences database or storage
          await Helper.saveUserLoggedInStatus(true);
          await Helper.saveUserEmail(email);
          await Helper.saveUserName(fullName);
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
