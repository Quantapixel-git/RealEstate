import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String _adminLoginKey = "isAdminLoggedIn";
  static const String _userLoginKey = "isUserLoggedIn";

  /// Set the admin login status
  Future<void> setAdminLogin(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adminLoginKey, isLoggedIn);
  }

  /// Get the admin login status
  Future<bool?> isAdminLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adminLoginKey);
  }

  /// Set the user login status
  Future<void> setUserLogin(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userLoginKey, isLoggedIn);
  }

  /// Get the user login status
  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userLoginKey) ?? false;
  }

  /// Clear all login data (useful for logout)
  Future<void> clearLoginData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_adminLoginKey);
    await prefs.remove(_userLoginKey);
  }
}
