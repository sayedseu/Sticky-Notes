import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stickynotes/model/user.dart';
import 'package:stickynotes/ui/login_page.dart';
import 'package:stickynotes/ui/root_page.dart';

class AuthWidget extends StatelessWidget {
  final AsyncSnapshot<User> userSnapshot;

  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? RootPage() : LoginPageProvider();
    }
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
