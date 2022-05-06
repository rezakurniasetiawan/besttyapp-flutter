import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class UsersInfo {
  Future setToken(String? value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("token", value!);
  }
}
