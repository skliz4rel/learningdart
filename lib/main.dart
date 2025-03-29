import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/firebase_options.dart';
import 'package:learningdart/views/login.dart';
import 'package:learningdart/views/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //This helps to initialize the firebase required state. Very important

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Colors.lime.hashCode),
        title: Text('App home'),
      ),

      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;

              if (user?.emailVerified == true) {
                debugPrint('is user verified ${user?.emailVerified}');
              } else {
                debugPrint('is user is not verified');

                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => VerifyEmail()));
              }

              return Text('loaded');
            default:
              return const Text('Loading ......');
          }
        },
      ),
    );
  }
}

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Email Verification')));
  }
}
