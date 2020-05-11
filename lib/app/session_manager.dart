import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stickynotes/model/user.dart';

class SessionManager {
  static final String IS_LOGIN = "isLoggedIn";
  static final String KEY_USER_ID = "id";
  static final String KEY_USER_NAME = "username";
  static final String KEY_PASSWORD = "password";

  static final _loginController = StreamController<User>.broadcast();

  Stream<User> get loginStream {
    addCurrentUserToStream();
    return _loginController.stream;
  }

  static final SessionManager _instance = SessionManager._();

  factory SessionManager() => _instance;

  SessionManager._();

  Future<void> addCurrentUserToStream() async {
    _loginController.sink.add(await currentUser());
  }

  Future<User> currentUser() async {
    print("login state checkinh");
    final pref = await SharedPreferences.getInstance();
    final isLogin = pref.getBool(IS_LOGIN) ?? false;
    if (isLogin) {
      User user = User(
          id: pref.getInt(KEY_USER_ID) ?? -1,
          username: pref.getString(KEY_USER_NAME) ?? null,
          password: pref.getString(KEY_PASSWORD) ?? null);
      return user;
    } else
      return null;
  }

  Future<void> createLoginSession(User user) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(IS_LOGIN, true);
    pref.setInt(KEY_USER_ID, user.id);
    pref.setString(KEY_USER_NAME, user.username);
    pref.setString(KEY_PASSWORD, user.password);
    print(await currentUser());
    addCurrentUserToStream();
  }

  Future<void> logoutUser() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    addCurrentUserToStream();
  }

  void dispose() {
    _loginController.close();
  }
}
