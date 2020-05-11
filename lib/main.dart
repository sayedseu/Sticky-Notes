import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/app/app_database.dart';
import 'package:stickynotes/app/auth_widget.dart';
import 'package:stickynotes/app/auth_widget_builder.dart';
import 'package:stickynotes/app/session_manager.dart';
import 'package:stickynotes/service/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => AuthService(new AppDatabase())),
          Provider<SessionManager>(create: (_) => SessionManager()),
        ],
        child: AuthWidgetBuilder(builder: (context, snapshot) {
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(primarySwatch: Colors.blue),
              home: AuthWidget(userSnapshot: snapshot));
        }));
  }
}
