import 'package:flutter/material.dart';
import 'package:smartlifeorganizer/Pages/CalenderandSchedule.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: FutureBuilder(
      //   future: Firebase.initializeApp(
      //     options: DefaultFirebaseOptions.currentPlatform,
      //   ),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       final user = FirebaseAuth.instance.currentUser;
      //       if (user != null && user.emailVerified) {
      //         return const Login();
      //       } else {
      //         return const SignUp();
      //       }
      //     }

      //     // 👇 Handles other connection states (waiting, none, etc.)
      //     return const Scaffold(
      //       body: Center(child: CircularProgressIndicator()),
      //     );
      //   },
      // ),
      home: Calenderandschedule(),
    );
  }
}
