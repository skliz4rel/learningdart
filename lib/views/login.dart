import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learningdart/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Colors.lime.hashCode),
        title: Text('Sign In'),
      ),

      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      debugPrint("Login button was clicked ....");

                      try {
                        final email = _email.text;
                        final password = _password.text;

                        dynamic userCredentials = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                        debugPrint("This is the result $userCredentials");
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          debugPrint("User not found $e");
                        } else if (e.code == 'invalid-credential') {
                          debugPrint(
                            'invalid credentials was supplied by the user',
                          );
                        } else if (e.code == 'invalid-email') {
                          debugPrint(
                            "An unexplained exception happened ${e.toString()}",
                          );
                        }
                      }
                    },
                    child: Text('Login'),
                  ),
                ],
              );
            default:
              return const Text('Loading ......');
          }
        },
      ),
    );
  }
}
