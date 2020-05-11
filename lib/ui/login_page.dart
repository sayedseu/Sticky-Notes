import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickynotes/app/session_manager.dart';
import 'package:stickynotes/model/user.dart';
import 'package:stickynotes/service/auth_service.dart';
import 'package:stickynotes/utils/loading_button.dart';
import 'package:stickynotes/utils/validator.dart';

enum PageState { login, signup }

class LoginPageProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("login page provider");
    return MultiProvider(providers: [
      ChangeNotifierProvider<ValueNotifier<PageState>>(
          create: (context) => ValueNotifier<PageState>(PageState.login)),
      ChangeNotifierProvider<ValueNotifier<bool>>(
          create: (context) => ValueNotifier<bool>(false)),
    ], child: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final _formKey = GlobalKey<FormState>();
  static final _scaffoldKey = GlobalKey<ScaffoldState>();
  static String _username = "", _password = "";
  static ValueNotifier<PageState> globalPageState;
  static AuthService authService;
  static SessionManager sessionManager;
  static ValueNotifier<bool> globalLoadingState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("called didChangeDependencies");
    globalPageState =
        Provider.of<ValueNotifier<PageState>>(context, listen: false);
    globalLoadingState =
        Provider.of<ValueNotifier<bool>>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    sessionManager = Provider.of<SessionManager>(context, listen: false);
  }

  bool _validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print("called build");
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
            padding: EdgeInsets.all(16.0),
            child: Consumer<ValueNotifier<PageState>>(
              builder: (_, pageState, __) {
                if (pageState.value == PageState.login) {
                  print("called login consumer");
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            usernameTextFlied,
                            SizedBox(
                              height: 8,
                            ),
                            passwordTextFlied,
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Consumer<ValueNotifier<bool>>(
                        builder: (_, loading, __) {
                          print("calling login button consumer");
                          return LoadingButton(
                            text: "Login",
                            loading: loading.value,
                            onPressed: loading.value
                                ? null
                                : () {
                                    if (_validateAndSave()) {
                                      globalLoadingState.value = true;
                                      authService
                                          .authenticate(_username, _password)
                                          .then((value) {
                                        globalLoadingState.value = false;
                                        if (value != null) {
                                          sessionManager
                                              .createLoginSession(value);
                                        } else {
                                          _displaySnackBar(context,
                                              "Invalid username or password.");
                                        }
                                      });
                                    }
                                  },
                          );
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      signupPageButton
                    ],
                  );
                } else {
                  print("called signup consumer");
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            usernameTextFlied,
                            SizedBox(height: 8),
                            passwordTextFlied,
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Consumer<ValueNotifier<bool>>(
                        builder: (_, loading, __) {
                          print("calling signup button consumer");
                          return LoadingButton(
                            text: "Signup",
                            loading: loading.value,
                            onPressed: loading.value
                                ? null
                                : () {
                                    if (_validateAndSave()) {
                                      globalLoadingState.value = true;
                                      final user = User(
                                          username: _username,
                                          password: _password);
                                      authService.register(user).then((value) {
                                        globalLoadingState.value = false;
                                        if (value > 0) {
                                          globalPageState.value =
                                              PageState.login;
                                          _formKey.currentState.reset();
                                        } else
                                          _displaySnackBar(context,
                                              'Something went wrong. Please try again later.');
                                      });
                                    }
                                  },
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      loginPageButton
                    ],
                  );
                }
              },
            )),
      ),
    );
  }

  _displaySnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final usernameTextFlied = TextFormField(
    key: Key("username"),
    decoration: InputDecoration(
        labelText: "Username",
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder()),
    validator: Validator.validateUsername,
    onSaved: (String value) => _username = value,
  );

  final passwordTextFlied = TextFormField(
    key: Key("password"),
    decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder()),
    validator: Validator.validatePassword,
    onSaved: (String value) => _password = value,
  );

  final signupPageButton = FlatButton(
      child: Text("Havent't an account? Signup"),
      onPressed: () {
        globalPageState.value = PageState.signup;
        _formKey.currentState.reset();
      });

  final loginPageButton = FlatButton(
      child: Text("Already have an account? Login"),
      onPressed: () {
        globalPageState.value = PageState.login;
        _formKey.currentState.reset();
      });
}
