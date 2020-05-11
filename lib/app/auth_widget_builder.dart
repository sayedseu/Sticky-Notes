import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/app/app_database.dart';
import 'package:stickynotes/app/session_manager.dart';
import 'package:stickynotes/model/user.dart';
import 'package:stickynotes/service/note_service.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Function(BuildContext, AsyncSnapshot<User>) builder;

  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    return StreamBuilder(
      stream: sessionManager.loginStream,
      builder: (context, snapshot) {
        final User user = snapshot.data;
        if (user != null) {
          return MultiProvider(
            providers: [
              Provider<User>.value(value: user),
              Provider<NoteService>(
                  create: (_) => NoteService(new AppDatabase(), user.id))
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
