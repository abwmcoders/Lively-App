import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  //! keys
  static String userLoggedInKey = 'USERLOGGEDINKEY';
  static String userEmailKey = 'USEREMAILKEY';
  static String userNameKey = 'USERNAMEKEY';

  //! save data
  static Future<bool?> saveUserLoggedInStatus(bool? isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn!);
  }

  static Future<bool?> saveUserName(String? userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName!);
  }

  static Future<bool?> saveUserEmail(String? userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail!);
  }

  //! get data
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserNameFromSp() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserEmailFromSp() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
}
